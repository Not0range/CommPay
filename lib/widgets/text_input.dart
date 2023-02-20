import 'package:com_pay/utils.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String text;
  final String placeholder;
  final void Function()? onFocus;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmit;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? subText;
  final TextStyle? textStyle;
  final TextStyle? subTextStyle;

  const TextInput(
      {super.key,
      this.text = '',
      required this.placeholder,
      this.onFocus,
      this.onChanged,
      this.onSubmit,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.subText,
      this.textStyle,
      this.subTextStyle});

  @override
  State<StatefulWidget> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput>
    with SingleTickerProviderStateMixin {
  final FocusNode textFieldNode = FocusNode();
  late TextEditingController editingController;
  String text = '';

  @override
  void initState() {
    super.initState();
    text = widget.text;
    textFieldNode.addListener(() {
      if (!textFieldNode.hasFocus) {
        widget.onSubmit?.call(text);
      } else {
        widget.onFocus?.call();
      }
    });

    editingController = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    textFieldNode.dispose();
    super.dispose();
  }

  void onChanged(String value) {
    setState(() {
      text = value;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: TextField(
        focusNode: textFieldNode,
        onChanged: onChanged,
        onSubmitted: widget.onSubmit,
        controller: editingController,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        enabled: widget.onChanged != null,
        style: widget.textStyle,
        decoration: InputDecoration(
            labelText: widget.placeholder,
            errorText:
                widget.subText?.isEmptyOrSpace ?? true ? null : widget.subText,
            errorStyle: widget.subTextStyle),
      ),
    );
  }
}
