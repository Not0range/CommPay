import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhotoSendItem extends StatelessWidget {
  final String title;
  final DateTime date;
  final int photoCount;

  const PhotoSendItem(
      {super.key,
      required this.title,
      required this.date,
      required this.photoCount});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(title),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text('${AppLocalizations.of(context)!.photoDate}: '
              '${DateFormat('dd.MM.yyyy').format(date)}'),
        ),
        Text('${AppLocalizations.of(context)!.fileInQueue}: $photoCount')
      ]),
    );
  }
}
