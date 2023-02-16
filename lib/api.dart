import 'package:com_pay/entities/measurment_water.dart';
import 'package:com_pay/entities/success_response.dart';

import 'entities/water_meter.dart';

const String _baseUrl = 'https://commpay.idc.md/api/v1';

//TODO request to api server

Future<String> login(String phone, String password) async {
  _baseUrl; //
  await Future.delayed(const Duration(seconds: 1));
  return 'key';
}

Future<List<WaterMeter>> getWaterMeters(String key) async {
  await Future.delayed(const Duration(seconds: 2));
  return [
    WaterMeter(
        'Счётчик ГВС №38377. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 15),
        DateTime(2023, 2, 15),
        123456,
        'Иванов Иван Иванович'),
    WaterMeter(
        'Счётчик ГВС №45787. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 17),
        DateTime(2023, 1, 17),
        452568,
        'Петров Пётр Петрович'),
    WaterMeter(
        'Счётчик ГВС №45735. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 25),
        DateTime(2023, 1, 25),
        785987,
        'Сидоров Сергей Фёдорович'),
  ];
}

Future<List<WaterMeter>> searchWaterMeter(String key, String text) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    WaterMeter(
        'Счётчик ГВС №38377. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 15),
        DateTime(2023, 2, 15),
        123456,
        'Иванов Иван Иванович'),
    WaterMeter(
        'Счётчик ГВС №45787. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 17),
        DateTime(2023, 1, 17),
        452568,
        'Петров Пётр Петрович'),
    WaterMeter(
        'Счётчик ГВС №45735. Днестровск, ул.Строителей 22, кв.3 - договор №80032',
        DateTime(2023, 1, 25),
        DateTime(2023, 1, 25),
        785987,
        'Сидоров Сергей Фёдорович'),
  ]
      .where((el) => el.title.contains(RegExp(text, caseSensitive: false)))
      .toList();
}

Future<SuccessResponse> addMeasurment(MeasurmentWater measurment) async {
  await Future.delayed(const Duration(seconds: 2));
  return SuccessResponse(true);
}
