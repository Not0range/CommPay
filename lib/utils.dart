import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

enum DialogResult { ok, cancel, retry }

AppBar loadingAppBar(BuildContext context) =>
    AppBar(title: Text(AppLocalizations.of(context)!.loading));

AppBar errorAppBar(BuildContext context) =>
    AppBar(title: Text(AppLocalizations.of(context)!.error));
