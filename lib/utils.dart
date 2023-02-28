import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'app_model.dart';
import 'entities/photo_send.dart';

extension ResponseExtension on http.Response {
  bool get isOk {
    return statusCode >= 200 && statusCode < 300;
  }
}

extension StringExtension on String {
  bool get isEmptyOrSpace {
    return trim().isEmpty;
  }
}

extension DateTimeExtension on DateTime {
  DateTime get today {
    return DateTime(year, month, day);
  }
}

extension ListExtension<T> on Iterable<T> {
  List<T> distinctBy<K>(
      K Function(T) keySelector, int Function(T, T)? sortFunc) {
    var list = toList();
    list.sort(sortFunc);
    var result = <T>[];
    var set = <K>{};
    for (var item in list) {
      if (set.add(keySelector(item))) {
        result.add(item);
      }
    }
    return result;
  }
}

Future<DialogResult?> showErrorDialog(BuildContext context, String title,
    String text, Map<String, DialogResult> actions) async {
  return showDialog<DialogResult?>(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: actions.keys
                .map((key) => TextButton(
                    onPressed: () => Navigator.pop(context, actions[key]),
                    child: Text(key)))
                .toList(),
          ));
}

int getPhotoCount(BuildContext context, String id) {
  var ps = Provider.of<AppModel>(context, listen: false)
      .photosToSend
      .cast<PhotoSend?>()
      .singleWhere((el) => el!.meter.id == id, orElse: () => null);
  var count = 0;
  if (ps != null) count = ps.paths.length;
  return count;
}

enum DialogResult { ok, cancel, retry }

AppBar loadingAppBar(BuildContext context) =>
    AppBar(title: Text(AppLocalizations.of(context)!.loading));

AppBar errorAppBar(BuildContext context) =>
    AppBar(title: Text(AppLocalizations.of(context)!.error));
