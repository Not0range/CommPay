import 'package:intl/intl.dart';

class WaterMeter {
  final String title;
  final DateTime prevMeasurment;
  final DateTime lastMeasurment;
  final String id;
  String? responsible;

  WaterMeter(this.title, this.prevMeasurment, this.lastMeasurment, this.id);

  factory WaterMeter.fromJson(Map<String, dynamic> json) {
    var j =
        Map.fromIterables(json.keys.map((e) => e.toLowerCase()), json.values);
    return WaterMeter(
        j['object_name'],
        DateFormat('dd.MM.yy').parse(j['prev_metrics_date']),
        DateFormat('dd.MM.yy').parse(j['current_metrics_date']),
        j['object_id']);
  }
}
