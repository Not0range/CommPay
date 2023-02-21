import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterMeterItem extends StatelessWidget {
  final String title;
  final DateTime prev;
  final DateTime last;
  final VoidCallback? onTap;

  const WaterMeterItem(
      {super.key,
      required this.title,
      required this.prev,
      required this.last,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    TextStyle? ts;
    if (prev == last) {
      ts = TextStyle(color: Theme.of(context).colorScheme.error);
    }
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('dd.MM.yy').format(prev)),
              Text(DateFormat('dd.MM.yy').format(last), style: ts),
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
