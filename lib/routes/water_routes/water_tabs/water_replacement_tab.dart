import 'package:com_pay/entities/water/replacement_water.dart';
import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/retry_widget.dart';
import 'package:com_pay/widgets/water_meter_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../entities/water/water_meter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/date_picker.dart';

import '../../../widgets/row_switch.dart';
import '../../../widgets/text_input.dart';
import 'package:com_pay/api.dart' as api;

class WaterReplacementTab extends StatefulWidget {
  final WaterMeter meter;
  final String keyString;

  final void Function(dynamic state)? onChecking;

  const WaterReplacementTab(
      {super.key,
      required this.keyString,
      required this.meter,
      this.onChecking});

  @override
  State<StatefulWidget> createState() => _WaterReplacementTab();
}

class _WaterReplacementTab extends State<WaterReplacementTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  bool loading = false;
  bool error = false;

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

    _getReplacementData();
  }

  Future _getReplacementData() async {
    setState(() {
      error = false;
      loading = true;
    });
    try {
      var r = await api.getReplacemets(widget.keyString, widget.meter);
      if (mounted) {
        setState(() {
          serial = r.serial ?? '';
          replacementDate = r.date;
          value = r.value?.toString() ?? '';
          replace = r.replacement;
          if (replace) controller.value = 1;

          loading = false;
          _checkValues();
        });
      }
    } on ClientException catch (_) {
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  void _setReplace(bool value) {
    if (value) {
      controller.forward();
    } else {
      controller.reverse();
    }
    setState(() {
      replace = value;
      serial = '';
      this.value = '';
      replacementDate = null;
    });
    _checkValues();
  }

  void _setSerial(String value) {
    setState(() {
      serial = value;

      _checkValues();
    });
  }

  void _setValue(String value) {
    setState(() {
      this.value = value;

      _checkValues();
    });
  }

  void _setReplacementDate(DateTime? value) {
    setState(() {
      replacementDate = value;
      _checkValues();
    });
  }

  void _checkValues() {
    if (serial.isEmptyOrSpace) {
      serialError = ErrorType.emptyValue;
    } else {
      serialError = ErrorType.none;
    }

    if (value.isEmptyOrSpace) {
      valueError = ErrorType.emptyValue;
    } else if (int.tryParse(value) == null) {
      valueError = ErrorType.wrongValue;
    } else {
      valueError = ErrorType.none;
    }
    if (!replace ||
        valueError == ErrorType.none &&
            serialError == ErrorType.none &&
            replacementDate != null) {
      var m = widget.meter;
      widget.onChecking?.call(ReplacementWater(m.id, replace,
          serial: serial, date: replacementDate, value: int.tryParse(value)));
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
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : error
            ? Center(
                child: RetryWidget(
                onPressed: _getReplacementData,
              ))
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      WaterMeterWidget(widget.meter),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 8),
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
                                      placeholder: AppLocalizations.of(context)!
                                          .serialNumber,
                                      onChanged: _setSerial,
                                      subText: _getErrorText(serialError),
                                      subTextStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  ),
                                  DatePicker(
                                    placeholder: AppLocalizations.of(context)!
                                        .replacementDate,
                                    date: replacementDate,
                                    onChange: _setReplacementDate,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: TextInput(
                                      text: value,
                                      placeholder: AppLocalizations.of(context)!
                                          .newMeterValue,
                                      keyboardType: TextInputType.number,
                                      onChanged: _setValue,
                                      subText: _getErrorText(valueError),
                                      subTextStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RowSwitch(
                              state: replace,
                              onChanged: _setReplace,
                              text: AppLocalizations.of(context)!.replaceMeter,
                            ),
                          ],
                        ),
                      )
                    ]),
              );
  }
}

enum ErrorType { none, wrongValue, emptyValue }
