import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension RexponseExtension on http.Response {
  bool get isOk {
    return statusCode >= 200 && statusCode < 300;
  }
}

extension StringExtension on String {
  bool get isEmptyOrSpace {
    return trim().isEmpty;
  }
}

AppBar loadingAppBar(BuildContext context) =>
    AppBar(title: Text(AppLocalizations.of(context)!.loading));

AppBar errorAppBar(BuildContext context) =>
    AppBar(title: Text(AppLocalizations.of(context)!.error));
