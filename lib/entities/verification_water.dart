class VerificationWater {
  final int id;
  final DateTime fromDate;
  final DateTime toDate;

  VerificationWater(this.id, this.fromDate, this.toDate);

  Map<String, dynamic> toJson() {
    return {
      "object_id": id,
      "is_dev_verification_remove": 1,
      "dev_verification_from_date": fromDate,
      "dev_verification_to_date": toDate
    };
  }
}
