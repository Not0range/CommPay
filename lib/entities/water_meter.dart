class WaterMeter {
  final String title;
  final DateTime prevMeasurment;
  final DateTime lastMeasurment;

  WaterMeter(this.title, this.prevMeasurment, this.lastMeasurment);

  factory WaterMeter.fromJson(Map<String, dynamic> json) {
    return WaterMeter(json['title'], DateTime.parse(json['prev']),
        DateTime.parse(json['last']));
  }
}
