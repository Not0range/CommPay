import 'package:intl/intl.dart';

class ReplacementWater {
  final String id;
  final bool replacement;
  final String? serial;
  final DateTime? date;
  final int? value;

  ReplacementWater(this.id, this.replacement,
      {this.serial, this.date, this.value});

  Map<String, dynamic> toJson() {
    return {
      "object_id": id,
      "is_device_replacement": replacement ? 1 : 0,
      "new_serial_number": serial,
      "new_dev_curr_metrics_date":
          date != null ? DateFormat('dd.MM.yy').format(date!) : null,
      "new_dev_curr_metrics_value": value
    };
  }

  factory ReplacementWater.fromJson(Map<String, dynamic> json) {
    dynamic date = json['new_device_curr_metrics_date'];
    DateTime? d;
    if (date != null) d = DateFormat('dd.MM.yy').parse(date);
    return ReplacementWater(
        json['object_id'], json['is_device_replacement'] == '1',
        serial: json['new_serial_number'],
        date: d,
        value: int.tryParse(json['new_device_curr_metrics_value'] ?? ''));
  }
}
