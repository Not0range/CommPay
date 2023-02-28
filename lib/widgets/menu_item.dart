import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const MenuItem(
      {super.key,
      required this.icon,
      this.text = '',
      this.onTap,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: backgroundColor,
        onTap: onTap,
        leading: Icon(icon, size: IconTheme.of(context).size! * 1.5),
        title: Text(
          text,
          overflow: TextOverflow.ellipsis,
        ));
  }
}
