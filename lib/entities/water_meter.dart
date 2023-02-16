class WaterMeter {
  final String title;
  final DateTime prevMeasurment;
  final DateTime lastMeasurment;
  final int id;
  final String liability;

  WaterMeter(this.title, this.prevMeasurment, this.lastMeasurment, this.id,
      this.liability);

  factory WaterMeter.fromJson(Map<String, dynamic> json) {
    return WaterMeter(json['title'], DateTime.parse(json['prev']),
        DateTime.parse(json['last']), int.parse(json['id']), json['liability']);
  }
}
