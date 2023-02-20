import 'package:com_pay/entities/title_interface.dart';
import 'package:intl/intl.dart';

class WaterMeter extends TitleInterface {
  final DateTime prevMeasurment;
  final DateTime lastMeasurment;
  String? responsible;

  WaterMeter(this.prevMeasurment, this.lastMeasurment,
      {required super.title, required super.id});

  factory WaterMeter.fromJson(Map<String, dynamic> json) {
    var j =
        Map.fromIterables(json.keys.map((e) => e.toLowerCase()), json.values);
    return WaterMeter(DateFormat('dd.MM.yy').parse(j['prev_metrics_date']),
        DateFormat('dd.MM.yy').parse(j['current_metrics_date']),
        title: j['object_name'], id: j['object_id']);
  }
}
