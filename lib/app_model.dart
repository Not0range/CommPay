import 'dart:collection';

import 'package:com_pay/entities/photo_send.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends ChangeNotifier {
  final List<PhotoSend> _photosToSend = [];

  UnmodifiableListView<PhotoSend> get photosToSend =>
      UnmodifiableListView(_photosToSend);

  void add(PhotoSend item) {
    _photosToSend.add(item);
    notifyListeners();
    _setData();
  }

  void addAll(Iterable<PhotoSend> items, {bool refreshStorage = false}) {
    _photosToSend.addAll(items);
    notifyListeners();
    if (refreshStorage) _setData();
  }

  void remove(PhotoSend item) {
    _photosToSend.remove(item);
    notifyListeners();
    _setData();
  }

  void removeAt(int index) {
    _photosToSend.removeAt(index);
    notifyListeners();
    _setData();
  }

  void clear() {
    _photosToSend.clear();
    notifyListeners();
    _setData();
  }

  Future _setData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'photo_queue', _photosToSend.map((e) => e.toJson()).toList());
  }
}
