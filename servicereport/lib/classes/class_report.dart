import 'package:servicereport/signals/signal_sqflite.dart';

class ClassReport {
  int id;
  String date = DateTime.now().toIso8601String();
  String location = 'none';
  String description = 'none';
  int duration = 0;
  int price = 0;
  int payed = 0;

  ClassReport(
    this.id,
    this.date,
    this.location,
    this.description,
    this.duration,
    this.price,
    this.payed,
  );

  ClassReport.fromMap(Map<String, Object?> map)
    : id = map[idColumn] as int,
      date = map[dateColumn] as String,
      location = map[locationColumn] as String,
      description = map[descriptionColumn] as String,
      duration = map[durationColumn] as int,
      price = map[priceColumn] as int,
      payed = map[payedColumn] as int;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      dateColumn: date,
      locationColumn: location,
      descriptionColumn: description,
      durationColumn: duration,
      priceColumn: price,
      payedColumn: payed,
    };
  }
}
