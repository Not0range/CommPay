import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  const MenuItem({super.key, required this.icon, this.text = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
              border: Border(
                  left:
                      BorderSide(style: BorderStyle.solid, color: Colors.black),
                  bottom:
                      BorderSide(style: BorderStyle.solid, color: Colors.black),
                  right: BorderSide(
                      style: BorderStyle.solid, color: Colors.black))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(icon, size: IconTheme.of(context).size! * 1.5),
              ),
              Expanded(
                child: Text(
                  text,
                  textScaleFactor: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          )),
    );
  }
}
