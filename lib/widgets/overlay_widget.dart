import 'package:flutter/material.dart';

class OverlayWidget extends StatelessWidget {
  final Widget child;
  final Widget overlay;

  const OverlayWidget({super.key, required this.overlay, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [child, overlay],
    );
  }
}
