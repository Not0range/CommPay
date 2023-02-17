import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterMeterItem extends StatelessWidget {
  final String title;
  final DateTime prev;
  final DateTime last;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const WaterMeterItem(
      {super.key,
      required this.title,
      required this.prev,
      required this.last,
      this.backgroundColor = Colors.white,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    TextStyle? ts;
    if (prev == last) {
      ts = const TextStyle(color: Colors.red);
    }
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
              color: backgroundColor,
              border: const Border(
                  left:
                      BorderSide(style: BorderStyle.solid, color: Colors.black),
                  bottom:
                      BorderSide(style: BorderStyle.solid, color: Colors.black),
                  right: BorderSide(
                      style: BorderStyle.solid, color: Colors.black))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title,
                  textScaleFactor: 1.1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('dd.MM.yy').format(prev)),
                  Text(DateFormat('dd.MM.yy').format(last), style: ts),
                ],
              )
            ],
          )),
    );
  }
}
