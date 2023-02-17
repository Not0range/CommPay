import 'dart:convert';

import 'package:com_pay/entities/measurment_water.dart';
import 'package:com_pay/entities/replacement_water.dart';
import 'package:com_pay/entities/success_response.dart';
import 'package:com_pay/entities/verification_water.dart';
import 'package:http/http.dart' as http;

import 'entities/water_meter.dart';

const String _baseUrl = 'https://commpay.idc.md/api/v1';
const String _tempKey = '1762';

//TODO edit requests to api server

Future<String> login(String phone, String password) async {
  _baseUrl; //
  await Future.delayed(const Duration(seconds: 1));
  return 'key';
}

Future<List<WaterMeter>> getWaterMeters(String key) async {
  http.Response res = await http
      .get(Uri.parse('$_baseUrl/water/get_counters_by_user_id/$_tempKey'));
  List<dynamic> meters = jsonDecode(res.body);
  return meters
      .cast<Map<String, dynamic>>()
      .map((e) => WaterMeter.fromJson(e))
      .toList();
}

Future<List<WaterMeter>> searchWaterMeter(String key, String text) async {
  http.Response res = await http.post(
      Uri.parse('$_baseUrl/water/get_counters_by_serial_number'),
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: jsonEncode({'serial_number': text, 'user_id': _tempKey}));
  List<dynamic> meters = jsonDecode(res.body);
  return meters
      .cast<Map<String, dynamic>>()
      .map((e) => WaterMeter.fromJson(e))
      .toList();
}

Future<MeasurmentWater> getMeasurments(String key, WaterMeter meter) async {
  http.Response res = await http
      .get(Uri.parse('$_baseUrl/water/get_dev_metrics/${meter.id}/$_tempKey'));
  List<dynamic> measurments = jsonDecode(res.body);
  var m = measurments
      .cast<Map<String, dynamic>>()
      .map((e) => MeasurmentWater.fromJson(e))
      .first;
  meter.responsible = m.responsible;
  return m;
}

Future<VerificationWater> getVerification(String key, WaterMeter meter) async {
  http.Response res = await http
      .get(Uri.parse('$_baseUrl/water/get_dev_verification/${meter.id}'));
  List<dynamic> verifications = jsonDecode(res.body);
  return verifications
      .cast<Map<String, dynamic>>()
      .map((e) => VerificationWater.fromJson(e))
      .first;
}

Future<ReplacementWater> getReplacemets(String key, WaterMeter meter) async {
  http.Response res = await http
      .get(Uri.parse('$_baseUrl/water/get_dev_replacement/${meter.id}'));
  List<dynamic> replacements = jsonDecode(res.body);
  return replacements
      .cast<Map<String, dynamic>>()
      .map((e) => ReplacementWater.fromJson(e))
      .first;
}

Future<SuccessResponse> addMeasurment(MeasurmentWater measurment) async {
  await Future.delayed(const Duration(seconds: 2));
  return SuccessResponse(true);
}
