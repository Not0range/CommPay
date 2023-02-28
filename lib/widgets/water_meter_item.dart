import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterMeterItem extends StatelessWidget {
  final String title;
  final bool favorite;
  final DateTime? prev;
  final DateTime? last;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const WaterMeterItem(
      {super.key,
      required this.title,
      required this.favorite,
      this.prev,
      this.last,
      this.onTap,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    TextStyle prevStyle = const TextStyle(fontWeight: FontWeight.bold);
    TextStyle currentStyle = const TextStyle(fontWeight: FontWeight.bold);
    if (prev == last || prev == null || last == null) {
      currentStyle =
          currentStyle.copyWith(color: Theme.of(context).colorScheme.error);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        tileColor: backgroundColor,
        onTap: onTap,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(favorite ? Icons.star : Icons.star_border)
            ],
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              prev != null ? DateFormat('dd.MM.yy').format(prev!) : '-',
              style: prevStyle,
            ),
            Text(last != null ? DateFormat('dd.MM.yy').format(last!) : '-',
                style: currentStyle),
          ],
        ),
      ),
    );
  }
}
