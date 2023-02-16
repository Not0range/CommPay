//TODO must be fields from response

class MeasurmentWater {
  final int id;
  final bool noConsumption;
  final DateTime currentDate;
  final int currentValue;

  MeasurmentWater(
      this.id, this.noConsumption, this.currentDate, this.currentValue);

  Map<String, dynamic> toJson() {
    return {
      "object_id": id,
      "is_no_consumption": noConsumption,
      "curr_metrics_date": currentDate.toString(),
      "curr_metrics_value": currentValue
    };
  }
}
