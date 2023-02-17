import 'dart:math';

import 'package:com_pay/entities/measurment_water.dart';
import 'package:com_pay/entities/water_meter.dart';
import 'package:com_pay/widgets/water_meter_widget.dart';
import 'package:flutter/material.dart';

import '../../../widgets/date_picker.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/text_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//TODO current date color when same values

class WaterMeasurmentTab extends StatefulWidget {
  final WaterMeter meter;
  final void Function(MeasurmentWater? state)? onChecking;

  const WaterMeasurmentTab({super.key, required this.meter, this.onChecking});

  @override
  State<StatefulWidget> createState() => _WaterMeasurmentTabState();
}

class _WaterMeasurmentTabState extends State<WaterMeasurmentTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  bool loading = true;

  late DateTime last;
  int prevValue = 0;
  String lastValue = '';
  bool noConsumption = false;

  ErrorType lastValueError = ErrorType.none;

  @override
  void initState() {
    super.initState();
    last = widget.meter.lastMeasurment;

    controller = AnimationController(
        value: 1, duration: const Duration(milliseconds: 100), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    _getMeasurmentData();
  }

  Future _getMeasurmentData() async {
    await Future.delayed(const Duration(seconds: 2));
    var rand = Random();
    var p = rand.nextInt(300) + 200;
    var l = p + rand.nextInt(150);
    if (mounted) {
      setState(() {
        prevValue = p;
        lastValue = p.toString();
        loading = false;
        _checkValues();
      });
    }
  }

  void _setLastDate(DateTime value) {
    setState(() {
      last = value;
    });
  }

  void _setLastValue(String value) {
    setState(() {
      lastValue = value;
      _checkValues();
    });
  }

  void _setNoConsumption(bool value) {
    FocusScope.of(context).unfocus();
    if (value) {
      controller.reverse();
    } else {
      controller.forward();
    }
    setState(() {
      noConsumption = value;
      var v = int.tryParse(lastValue);
      _checkValues();
    });
  }

  void _checkValues() {
    var v = int.tryParse(lastValue);
    if (noConsumption) {
      lastValueError = ErrorType.none;
    } else {
      if (v == null) {
        lastValueError = ErrorType.wrongValue;
      } else if (v < prevValue) {
        lastValueError = ErrorType.leastValue;
      } else if (v == prevValue) {
        lastValueError = ErrorType.sameValues;
      } else {
        lastValueError = ErrorType.none;
      }
    }
    if (lastValueError == ErrorType.none) {
      var m = widget.meter;
      widget.onChecking?.call(MeasurmentWater(m.id, noConsumption, last,
          noConsumption ? prevValue : int.parse(lastValue)));
    } else {
      widget.onChecking?.call(null);
    }
  }

  String _getErrorText() {
    switch (lastValueError) {
      case ErrorType.none:
        return '';
      case ErrorType.leastValue:
        return AppLocalizations.of(context)!.leastValue;
      case ErrorType.sameValues:
        return AppLocalizations.of(context)!.sameValue;
      case ErrorType.wrongValue:
        return AppLocalizations.of(context)!.inputError;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: LoadingIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WaterMeterWidget(widget.meter),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  children: [
                    DatePicker(
                      placeholder: AppLocalizations.of(context)!.prevDate,
                      date: widget.meter.prevMeasurment,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextInput(
                        text: prevValue.toString(),
                        placeholder: AppLocalizations.of(context)!.prevValue,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    DatePicker(
                      placeholder: AppLocalizations.of(context)!.currentDate,
                      minDate: widget.meter.prevMeasurment,
                      date: last,
                      onChange: _setLastDate,
                    ),
                    SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextInput(
                            text: lastValue,
                            placeholder:
                                AppLocalizations.of(context)!.currentValue,
                            keyboardType: TextInputType.number,
                            onChanged: _setLastValue,
                            subText: _getErrorText(),
                            subTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      ),
                    ),
                    Row(
                      children: [
                        Switch(
                            value: noConsumption, onChanged: _setNoConsumption),
                        InkWell(
                            onTap: () => _setNoConsumption(!noConsumption),
                            child: Text(
                                AppLocalizations.of(context)!.noConsumption))
                      ],
                    )
                  ],
                ),
              )
            ],
          );
  }
}

enum ErrorType { none, sameValues, leastValue, wrongValue }
