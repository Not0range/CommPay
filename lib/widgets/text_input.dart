import 'package:flutter/material.dart';

const animationDuration = 200;

class TextInput extends StatefulWidget {
  final String text;
  final String placeholder;
  final void Function(String value)? onSubmit;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;

  const TextInput(
      {super.key,
      this.text = '',
      required this.placeholder,
      this.onSubmit,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.obscureText = false});

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

    controller = AnimationController(
        duration: const Duration(milliseconds: animationDuration), vsync: this);
    animation = Tween<double>(begin: 16, end: 10).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    textFieldNode.addListener(_animatePlaceholder);
  }

  @override
  void dispose() {
    textFieldNode.removeListener(_animatePlaceholder);
    textFieldNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _animatePlaceholder() {
    if (textFieldNode.hasFocus) {
      controller.forward();
    } else {
      widget.onSubmit?.call(text);
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        children: [
          TextField(
            focusNode: textFieldNode,
            onChanged: onChanged,
            controller: editingController,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
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
          )
        ],
      ),
    );
  }
}
