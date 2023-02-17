import 'package:flutter/material.dart';

class RowSwitch extends StatelessWidget {
  final bool? state;
  final void Function(bool value)? onChanged;
  final String? text;

  const RowSwitch({super.key, this.state, this.text, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(value: state ?? false, onChanged: onChanged),
        InkWell(
            onTap: () => onChanged?.call(state ?? false),
            child: Text(text ?? ''))
      ],
    );
  }
}
