import 'dart:convert';

import 'package:com_pay/entities/water/measurment_water.dart';
import 'package:com_pay/entities/water/replacement_water.dart';
import 'package:com_pay/entities/success_response.dart';
import 'package:com_pay/entities/water/verification_water.dart';
import 'package:com_pay/utils.dart';
import 'package:http/http.dart' as http;

import 'entities/water/water_meter.dart';

const String _baseUrl = 'https://commpay.idc.md/api/v1';
const String _tempKey = '2662';
const Map<String, String> _defaultHeaders = {
  'Content-Type': 'application/json;charset=utf-8'
};

const List<String> phoneNumbers = ['77755571', '77717709'];

//TODO login
Future<String?> login(String phone, String password) async {
  await Future.delayed(const Duration(seconds: 1));
  if (phone == password) {
    return 'key';
  } else {
    return null;
  }
}

Future<List<WaterMeter>> getWaterMeters(String userId) async {
  http.Response res = await http
      .get(Uri.parse('$_baseUrl/water/get_counters_by_user_id/$_tempKey'));
  List<dynamic> meters = jsonDecode(res.body);
  return meters
      .cast<Map<String, dynamic>>()
      .map((e) => WaterMeter.fromJson(e))
      .distinctBy((m) => m.id, (m1, m2) => m1.isFavorite ? -1 : 1)
      .toList();
}

Future<List<WaterMeter>> searchWaterMeter(String userId, String text) async {
  http.Response res = await http.post(
      Uri.parse('$_baseUrl/water/get_counters_by_serial_number'),
      headers: _defaultHeaders,
      body: jsonEncode({'serial_number': text, 'user_id': _tempKey}));
  List<dynamic> meters = jsonDecode(res.body);
  return meters
      .cast<Map<String, dynamic>>()
      .map((e) => WaterMeter.fromJson(e))
      .toList();
}

Future<MeasurmentWater> getMeasurments(String userId, WaterMeter meter) async {
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

Future<VerificationWater> getVerification(
    String userId, WaterMeter meter) async {
  http.Response res = await http
      .get(Uri.parse('$_baseUrl/water/get_dev_verification/${meter.id}'));
  List<dynamic> verifications = jsonDecode(res.body);
  return verifications
      .cast<Map<String, dynamic>>()
      .map((e) => VerificationWater.fromJson(e))
      .first;
}

Future<ReplacementWater> getReplacemets(String userId, WaterMeter meter) async {
  http.Response res = await http
      .get(Uri.parse('$_baseUrl/water/get_dev_replacement/${meter.id}'));
  List<dynamic> replacements = jsonDecode(res.body);
  return replacements
      .cast<Map<String, dynamic>>()
      .map((e) => ReplacementWater.fromJson(e))
      .first;
}

Future<SuccessResponse> addMeasurment(MeasurmentWater measurment) async {
  http.Response res = await http.post(
      Uri.parse('$_baseUrl/water/save_dev_metrics'),
      headers: _defaultHeaders,
      body: jsonEncode(measurment.toJson()));
  return SuccessResponse.fromJson(jsonDecode(res.body));
}

Future<SuccessResponse> addVerification(VerificationWater verification) async {
  http.Response res = await http.post(
      Uri.parse('$_baseUrl/water/save_dev_verification'),
      headers: _defaultHeaders,
      body: jsonEncode(verification.toJson()));
  return SuccessResponse.fromJson(jsonDecode(res.body));
}

Future<SuccessResponse> addReplacement(ReplacementWater replacement) async {
  http.Response res = await http.post(
      Uri.parse('$_baseUrl/water/save_dev_replacement'),
      headers: _defaultHeaders,
      body: jsonEncode(replacement.toJson()));
  return SuccessResponse.fromJson(jsonDecode(res.body));
}

Future<SuccessResponse> setFavorite(String objectId, bool favorite) async {
  http.Response res = await http.patch(
      Uri.parse('$_baseUrl/water/change_object_flag_is_favorite'),
      headers: _defaultHeaders,
      body: jsonEncode({
        'user_id': _tempKey,
        'object_id': objectId,
        'is_object_favorite': favorite ? '1' : '0'
      }));
  return SuccessResponse.fromJson(jsonDecode(res.body));
}
