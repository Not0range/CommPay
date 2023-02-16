import 'package:com_pay/utils.dart';
import 'package:flutter/material.dart';

const animationDuration = 200;

class TextInput extends StatefulWidget {
  final String text;
  final String placeholder;
  final void Function()? onFocus;
  final void Function(String value)? onChanged;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? subText;
  final TextStyle? subTextStyle;

  const TextInput(
      {super.key,
      this.text = '',
      required this.placeholder,
      this.onFocus,
      this.onChanged,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.subText,
      this.subTextStyle});

  @override
  State<StatefulWidget> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput>
    with SingleTickerProviderStateMixin {
  final FocusNode textFieldNode = FocusNode();
  late TextEditingController editingController;
  String text = '';
  bool top = false;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    text = widget.text;

    editingController = TextEditingController(text: widget.text);
    top = !text.isEmptyOrSpace;

    controller = AnimationController(
        value: text.isEmptyOrSpace ? 0 : 1,
        duration: const Duration(milliseconds: animationDuration),
        vsync: this);
    animation = Tween<double>(begin: 16, end: 10).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    textFieldNode.addListener(_animatePlaceholder);
  }

  @override
  void dispose() {
    textFieldNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _animatePlaceholder() {
    if (textFieldNode.hasFocus) {
      widget.onFocus?.call();
      controller.forward();
    } else {
      if (text.isEmpty) controller.reverse();
    }
    setState(() {
      top = textFieldNode.hasFocus || text.isNotEmpty;
    });
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: TextField(
                  focusNode: textFieldNode,
                  onChanged: onChanged,
                  controller: editingController,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  obscureText: widget.obscureText,
                  enabled: widget.onChanged != null,
                ),
              ),
              Text(
                widget.subText ?? '',
                style: widget.subTextStyle,
              )
            ],
          ),
          AnimatedPositioned(
            top: top ? 0 : 20,
            left: top ? 0 : 4,
            duration: const Duration(milliseconds: animationDuration),
            child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(textFieldNode),
                child: Text(
                  widget.placeholder,
                  style: TextStyle(fontSize: animation.value),
                )),
          ),
        ],
      ),
    );
  }
}
