import 'dart:convert';

import 'package:com_pay/entities/water/measurment_water.dart';
import 'package:com_pay/entities/water/replacement_water.dart';
import 'package:com_pay/entities/success_response.dart';
import 'package:com_pay/entities/water/verification_water.dart';
import 'package:http/http.dart' as http;

import 'entities/water/water_meter.dart';

const String _baseUrl = 'https://commpay.idc.md/api/v1';
const String _tempKey = '1762';

Future<String> login(String phone, String password) async {
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
  var body = measurment.toJson();
  // ignore: dead_code
  if (false) {
    //TODO do real request
    http.Response res = await http.post(
        Uri.parse('$_baseUrl/water/save_dev_meters'),
        headers: {'Content-Type': 'application/json;charset=utf-8'},
        body: body);
    return SuccessResponse.fromJson(jsonDecode(res.body));
  }
  await Future.delayed(const Duration(seconds: 2));
  return SuccessResponse(true);
}

Future<SuccessResponse> addVerification(VerificationWater verification) async {
  var body = verification.toJson();
  // ignore: dead_code
  if (false) {
    //TODO do real request
    http.Response res = await http.post(
        Uri.parse('$_baseUrl/water/save_dev_verification'),
        headers: {'Content-Type': 'application/json;charset=utf-8'},
        body: body);
    return SuccessResponse.fromJson(jsonDecode(res.body));
  }
  await Future.delayed(const Duration(seconds: 2));
  return SuccessResponse(true);
}

Future<SuccessResponse> addReplacement(ReplacementWater replacement) async {
  var body = replacement.toJson();
  // ignore: dead_code
  if (false) {
    //TODO do real request
    http.Response res = await http.post(
        Uri.parse('$_baseUrl/water/save_dev_replacement'),
        headers: {'Content-Type': 'application/json;charset=utf-8'},
        body: body);
    return SuccessResponse.fromJson(jsonDecode(res.body));
  }
  await Future.delayed(const Duration(seconds: 2));
  return SuccessResponse(true);
}
