import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:servicereport/classes/class_report.dart';
import 'package:signals/signals_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

const String databaseName = 'reports.db';
const String tableName = 'Reports';
const String idColumn = 'id';
const String dateColumn = 'date';
const String locationColumn = 'location';
const String descriptionColumn = 'description';
const String durationColumn = 'duration';
const String priceColumn = 'price';
const String payedColumn = 'payed';

class SignalSqflite {
  late Database database;
  late var databaseReportsList = <Map<String, Object?>>[];
  var reportsList = listSignal<ClassReport>([]);
  var unpayedReportsCount = signal(0);

  Future<void> initSqflite() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      var dir = await getApplicationSupportDirectory();
      await databaseFactory.setDatabasesPath(join(dir.path, 'databases'));
    }

    var path = join(await getDatabasesPath(), databaseName);

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $dateColumn TEXT NOT NULL, $locationColumn TEXT NOT NULL, $descriptionColumn TEXT NOT NULL, $durationColumn INT NOT NULL, $priceColumn INT NOT NULL, $payedColumn INT NOT NULL)',
        );
      },
      onOpen: (db) async {
        getReports(db);
      },
    );
  }

  Future<void> getReports(Database? db) async {
    databaseReportsList.clear();

    if (db != null) {
      databaseReportsList = await db.query(tableName);
    } else {
      databaseReportsList = await database.query(tableName);
    }

    reportsList.clear();
    if (databaseReportsList.isNotEmpty) {
      for (var databaseReport in databaseReportsList) {
        reportsList.add(ClassReport.fromMap(databaseReport));
      }
    }

    unpayedReportsCount.value = 0;
    if (reportsList.isNotEmpty) {
      for (var report in reportsList) {
        if (report.payed == 0) {
          unpayedReportsCount.value++;
        }
      }
    }
  }

  Future<int> deleteReport(ClassReport report) async {
    return await database.delete(
      tableName,
      where: '$idColumn = ?',
      whereArgs: [report.id],
    );
  }

  Future<int> insertReport(ClassReport report) async {
    return await database.insert(tableName, report.toMap());
  }

  Future<int> updateReport(ClassReport report) async {
    return await database.update(
      tableName,
      report.toMap(),
      where: '$idColumn = ?',
      whereArgs: [report.id],
    );
  }
}
