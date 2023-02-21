import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhotoSendItem extends StatelessWidget {
  final String title;
  final DateTime date;
  final int photoCount;
  final VoidCallback? onTap;

  const PhotoSendItem(
      {super.key,
      required this.title,
      required this.date,
      required this.photoCount,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${AppLocalizations.of(context)!.photoDate}: '
              '${DateFormat('dd.MM.yyyy').format(date)}'),
          Text('${AppLocalizations.of(context)!.fileInQueue}: $photoCount')
        ],
      ),
    );
  }
}
