import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterMeterItem extends StatelessWidget {
  final String title;
  final bool favorite;
  final DateTime? prev;
  final DateTime? last;
  final VoidCallback? onTap;

  const WaterMeterItem(
      {super.key,
      required this.title,
      required this.favorite,
      this.prev,
      this.last,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    TextStyle? ts;
    if (prev == last || prev == null || last == null) {
      ts = TextStyle(color: Theme.of(context).colorScheme.error);
    }
    return Column(
      children: [
        ListTile(
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
              Text(prev != null ? DateFormat('dd.MM.yy').format(prev!) : '-',
                  style: ts),
              Text(last != null ? DateFormat('dd.MM.yy').format(last!) : '-',
                  style: ts),
            ],
          ),
        ),
        const Divider(
          thickness: 1.5,
        )
      ],
    );
  }
}
