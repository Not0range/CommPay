import 'dart:collection';
import 'dart:io';

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
    _removeImages(item);
    notifyListeners();
    _setData();
  }

  void removeAt(int index) {
    _removeImages(_photosToSend.removeAt(index));
    notifyListeners();
    _setData();
  }

  void clear() {
    for (var ps in _photosToSend) {
      _removeImages(ps);
    }
    _photosToSend.clear();
    notifyListeners();
    _setData();
  }

  Future _setData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'photo_queue', _photosToSend.map((e) => e.toJson()).toList());
  }

  Future _removeImages(PhotoSend ps) async {
    for (var e in ps.paths) {
      var file = File(e);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
