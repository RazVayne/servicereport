import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SignalSqflite {
  late var database = initSqflite();

  Future<Database> initSqflite() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      var dir = await getApplicationSupportDirectory();
      await databaseFactory.setDatabasesPath(join(dir.path, 'databases'));
    }

    var path = join(await getDatabasesPath(), 'reports.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Reports (id INTEGER PRIMARY KEY, date TEXT NOT NULL, location TEXT NOT NULL, description TEXT NOT NULL, duration INT NOT NULL, price INT NOT NULL)',
        );
      },
    );
  }
}
