import 'package:com_pay/entities/title_interface.dart';
import 'package:intl/intl.dart';

class WaterMeter extends TitleInterface {
  final DateTime? prevMeasurment;
  final DateTime? lastMeasurment;
  bool isFavorite;
  String? responsible;

  WaterMeter(this.prevMeasurment, this.lastMeasurment,
      {required super.title, required super.id, required this.isFavorite});

  factory WaterMeter.fromJson(Map<String, dynamic> json) {
    var j =
        Map.fromIterables(json.keys.map((e) => e.toLowerCase()), json.values);
    return WaterMeter(
        j['prev_metrics_date'] != null
            ? DateFormat('dd.MM.yy').parse(j['prev_metrics_date'])
            : null,
        j['current_metrics_date'] != null
            ? DateFormat('dd.MM.yy').parse(j['current_metrics_date'])
            : null,
        title: j['object_name'] ?? '',
        id: j['object_id'] ?? '',
        isFavorite: j['is_favorite_object'] == '1');
  }
}
