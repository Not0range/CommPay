import 'dart:convert';

class TitleInterface {
  final String id;
  final String title;

  TitleInterface({required this.id, required this.title});

  String toJson() {
    return jsonEncode({'id': id, 'title': title});
  }

  factory TitleInterface.fromJson(Map<String, dynamic> json) {
    return TitleInterface(id: json['id'], title: json['title']);
  }
}
