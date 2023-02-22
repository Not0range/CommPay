import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const animationDuration = 200;

class DatePicker extends StatefulWidget {
  final String placeholder;
  final DateTime? minDate;
  final DateTime? date;
  final void Function(DateTime)? onChange;
  final TextStyle? textStyle;
  final String? subText;
  final TextStyle? subTextStyle;

  const DatePicker(
      {super.key,
      required this.placeholder,
      this.minDate,
      this.date,
      this.onChange,
      this.textStyle,
      this.subText,
      this.subTextStyle});

  @override
  State<StatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        value: widget.date != null ? 1 : 0,
        duration: const Duration(milliseconds: animationDuration),
        vsync: this);
    animation = Tween<double>(begin: 16, end: 12).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  Future _openDatePicker(BuildContext context) async {
    DateTime? d = await showDialog(
        context: context,
        builder: (ctx) => DatePickerDialog(
            initialDate: widget.date ?? DateTime.now(),
            firstDate:
                widget.minDate != null ? widget.minDate! : DateTime(1960),
            lastDate: DateTime(2100)));
    if (d == null) return;
    widget.onChange?.call(d);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: widget.onChange != null
                    ? () => _openDatePicker(context)
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: double.maxFinite,
                  child: Text(
                      widget.date != null
                          ? DateFormat('dd.MM.yy').format(widget.date!)
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .merge(widget.textStyle)),
                ),
              ),
              Text(
                widget.subText ?? '',
                style: widget.subTextStyle,
              )
            ],
          ),
          AnimatedPositioned(
            top: widget.date != null ? -25 : 0,
            duration: const Duration(milliseconds: animationDuration),
            child: TextButton(
              onPressed: widget.onChange != null
                  ? () => _openDatePicker(context)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(widget.placeholder,
                    style: widget.date == null
                        ? Theme.of(context).textTheme.titleMedium!
                        : TextStyle(
                            fontSize: animation.value,
                            color: widget.onChange != null
                                ? Theme.of(context).hintColor
                                : Theme.of(context).disabledColor,
                            fontWeight: FontWeight.normal)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
