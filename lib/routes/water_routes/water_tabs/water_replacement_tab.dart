import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/water_meter_widget.dart';
import 'package:flutter/material.dart';

import '../../../entities/water_meter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/date_picker.dart';
import '../../../widgets/text_input.dart';

class WaterReplacementTab extends StatefulWidget {
  final WaterMeter meter;
  final void Function(dynamic state)? onChecking;

  const WaterReplacementTab({super.key, required this.meter, this.onChecking});

  @override
  State<StatefulWidget> createState() => _WaterReplacementTab();
}

class _WaterReplacementTab extends State<WaterReplacementTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  bool replace = false;
  DateTime? replacementDate;
  String serial = '';
  String value = '';
  ErrorType serialError = ErrorType.emptyValue;
  ErrorType valueError = ErrorType.emptyValue;

  @override
  void initState() {
    super.initState();
    replacementDate = DateTime.now();

    controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _setReplace(bool value) {
    if (value) {
      controller.forward();
    } else {
      controller.reverse();
    }
    setState(() {
      replace = value;
    });
  }

  void _setSerial(String value) {
    setState(() {
      serial = value;
      if (serial.isEmptyOrSpace) {
        serialError = ErrorType.emptyValue;
      } else if (int.tryParse(serial) == null) {
        serialError = ErrorType.wrongValue;
      } else {
        serialError = ErrorType.none;
      }
      _checkValues();
    });
  }

  void _setValue(String value) {
    setState(() {
      this.value = value;
      if (value.isEmptyOrSpace) {
        valueError = ErrorType.emptyValue;
      } else if (int.tryParse(value) == null) {
        valueError = ErrorType.wrongValue;
      } else {
        valueError = ErrorType.none;
      }
      _checkValues();
    });
  }

  void _setReplacementDate(DateTime value) {
    setState(() {
      replacementDate = value;
      _checkValues();
    });
  }

  void _checkValues() {
    if (valueError == ErrorType.none &&
        serialError == ErrorType.none &&
        replacementDate != null) {
      var m = widget.meter;
      widget.onChecking?.call(true);
    } else {
      widget.onChecking?.call(null);
    }
  }

  String _getErrorText(ErrorType type) {
    switch (type) {
      case ErrorType.none:
        return '';
      case ErrorType.wrongValue:
        return AppLocalizations.of(context)!.inputError;
      case ErrorType.emptyValue:
        return AppLocalizations.of(context)!.emptyError;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WaterMeterWidget(widget.meter),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Column(
              children: [
                SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextInput(
                          text: serial,
                          placeholder: AppLocalizations.of(context)!.prevValue,
                          keyboardType: TextInputType.number,
                          onChanged: _setSerial,
                          subText: _getErrorText(serialError),
                          subTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                      DatePicker(
                        placeholder: AppLocalizations.of(context)!.mountingDate,
                        date: replacementDate,
                        onChange: _setReplacementDate,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextInput(
                          text: value,
                          placeholder: AppLocalizations.of(context)!.prevValue,
                          keyboardType: TextInputType.number,
                          onChanged: _setValue,
                          subText: _getErrorText(valueError),
                          subTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Switch(value: replace, onChanged: _setReplace),
                    InkWell(
                      onTap: () => _setReplace(!replace),
                      child: Text(AppLocalizations.of(context)!.unmount),
                    )
                  ],
                )
              ],
            ),
          )
        ]);
  }
}

enum ErrorType { none, wrongValue, emptyValue }
