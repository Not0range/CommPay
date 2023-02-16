import 'dart:math';

import 'package:com_pay/entities/water_meter.dart';
import 'package:flutter/material.dart';

import '../../widgets/date_picker.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/text_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaterMeasurmentTab extends StatefulWidget {
  final WaterMeter meter;
  final void Function(bool state)? onChecking;

  const WaterMeasurmentTab({super.key, required this.meter, this.onChecking});

  @override
  State<StatefulWidget> createState() => _WaterMeasurmentTabState();
}

class _WaterMeasurmentTabState extends State<WaterMeasurmentTab> {
  bool loading = true;

  late DateTime last;
  int prevValue = 0;
  String lastValue = '';

  bool lastValueError = false;

  @override
  void initState() {
    super.initState();
    last = widget.meter.lastMeasurment;

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
        lastValue = l.toString();
        loading = false;
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
      var v = int.tryParse(lastValue);
      lastValueError = v == null || v <= prevValue;
      _checkValues();
    });
  }

  void _checkValues() {
    widget.onChecking?.call(!lastValueError);
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(widget.meter.title),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child:
                            Text('${AppLocalizations.of(context)!.liability}: '
                                '${widget.meter.liability}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child:
                            Text('${AppLocalizations.of(context)!.objectId}: '
                                '${widget.meter.id}'),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  children: [
                    DatePicker(
                      placeholder: AppLocalizations.of(context)!.prevDate,
                      date: widget.meter.prevMeasurment,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextInput(
                          text: lastValue,
                          placeholder:
                              AppLocalizations.of(context)!.currentValue,
                          keyboardType: TextInputType.number,
                          onChanged: _setLastValue,
                          subText: lastValueError
                              ? AppLocalizations.of(context)!.inputError
                              : '',
                          subTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    )
                  ],
                ),
              )
            ],
          );
  }
}
