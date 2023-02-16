import 'entities/water_meter.dart';

//TODO request to api server

Future<String> login(String phone, String password) async {
  await Future.delayed(const Duration(seconds: 1));
  return 'key';
}

Future<List<WaterMeter>> getWaterMeters(String key) async {
  await Future.delayed(const Duration(seconds: 2));
  return [
    WaterMeter(
        'Счётчик ГВС №38377. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 15),
        DateTime(2023, 2, 15)),
    WaterMeter(
        'Счётчик ГВС №45787. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 17),
        DateTime(2023, 1, 17)),
    WaterMeter(
        'Счётчик ГВС №45735. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 25),
        DateTime(2023, 1, 25)),
  ];
}

Future<List<WaterMeter>> searchWaterMeter(String key, String text) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    WaterMeter(
        'Счётчик ГВС №38377. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 15),
        DateTime(2023, 2, 15)),
    WaterMeter(
        'Счётчик ГВС №45787. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 17),
        DateTime(2023, 1, 17)),
    WaterMeter(
        'Счётчик ГВС №45735. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 25),
        DateTime(2023, 1, 25)),
  ]
      .where((el) => el.title.contains(RegExp(text, caseSensitive: false)))
      .toList();
}
