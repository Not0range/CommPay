import 'package:intl/intl.dart';

class MeasurmentWater {
  final String id;
  final bool noConsumption;
  final DateTime? prevDate;
  final DateTime? currentDate;
  final int? prevValue;
  final int currentValue;
  final String? responsible;

  MeasurmentWater(
      this.id, this.noConsumption, this.currentDate, this.currentValue,
      {this.responsible, this.prevDate, this.prevValue});

  factory MeasurmentWater.fromJson(Map<String, dynamic> json) {
    return MeasurmentWater(
        json['object_id'],
        json['is_no_consumption'] == '1',
        json['current_metrics_date'] != null
            ? DateFormat('dd.MM.yy').parse(json['current_metrics_date'])
            : null,
        int.parse(json['current_indication_value']),
        responsible: json['responsible_person'],
        prevDate: json['prev_metrics_date'] != null
            ? DateFormat('dd.MM.yy').parse(json['prev_metrics_date'])
            : null,
        prevValue: int.parse(json['prev_indication_value']));
  }

  Map<String, dynamic> toJson() {
    return {
      "object_id": id,
      "is_no_consumption": noConsumption ? '1' : '0',
      "curr_metrics_date": currentDate != null
          ? DateFormat('dd.MM.yy').format(currentDate!)
          : null,
      "curr_metrics_value": currentValue
    };
  }
}
