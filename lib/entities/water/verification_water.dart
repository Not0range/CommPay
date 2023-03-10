import 'package:intl/intl.dart';

class VerificationWater {
  final String id;
  final bool verification;
  final DateTime? fromDate;
  final DateTime? toDate;

  VerificationWater(this.id, this.verification, {this.fromDate, this.toDate});

  Map<String, dynamic> toJson() {
    return {
      "object_id": id,
      "is_dev_verification_removal": verification ? 1 : 0,
      "dev_vefication_from_date":
          fromDate != null ? DateFormat('dd.MM.yy').format(fromDate!) : null,
      "dev_vefication_to_date":
          toDate != null ? DateFormat('dd.MM.yy').format(toDate!) : null
    };
  }

  factory VerificationWater.fromJson(Map<String, dynamic> json) {
    dynamic d1 = json['verification_from_date'];
    dynamic d2 = json['verification_to_date'];
    DateTime? fromDate;
    DateTime? toDate;
    if (d1 != null) fromDate = DateFormat('dd.MM.yy').parse(d1);
    if (d2 != null) toDate = DateFormat('dd.MM.yy').parse(d2);
    return VerificationWater(
        json['object_id'], json['is_device_verification'] == '1',
        fromDate: fromDate, toDate: toDate);
  }
}
