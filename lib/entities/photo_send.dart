import 'dart:convert';

import 'package:com_pay/entities/title_interface.dart';
import 'package:intl/intl.dart';

class PhotoSend {
  final TitleInterface meter;
  final DateTime date;
  final List<String> paths;

  PhotoSend(this.meter, this.date, this.paths);

  String toJson() {
    return jsonEncode(<String, String>{
      'meter': meter.toJson(),
      'date': DateFormat('dd.MM.yy').format(date),
      'paths': jsonEncode(paths)
    });
  }

  factory PhotoSend.fromJson(Map<String, dynamic> json) {
    List paths = jsonDecode(json['paths']);
    return PhotoSend(TitleInterface.fromJson(jsonDecode(json['meter'])),
        DateFormat('dd.MM.yyyy').parse(json['date']), paths.cast<String>());
  }
}
