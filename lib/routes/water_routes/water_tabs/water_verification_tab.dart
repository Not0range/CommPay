import 'package:com_pay/entities/verification_water.dart';
import 'package:com_pay/entities/water_meter.dart';
import 'package:flutter/material.dart';

import '../../../widgets/date_picker.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/row_switch.dart';
import '../../../widgets/water_meter_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:com_pay/api.dart' as api;

class WaterVerificationTab extends StatefulWidget {
  final WaterMeter meter;
  final String keyString;

  final void Function(VerificationWater? state)? onChecking;

  const WaterVerificationTab(
      {super.key,
      required this.meter,
      required this.keyString,
      this.onChecking});

  @override
  State<StatefulWidget> createState() => _WaterVerificationTabState();
}

class _WaterVerificationTabState extends State<WaterVerificationTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  bool loading = true;

  bool unmount = false;
  DateTime? unmountDate;
  DateTime? installDate;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    _getVerificationData();
  }

  Future _getVerificationData() async {
    var v = await api.getVerification(widget.keyString, widget.meter);
    if (mounted) {
      setState(() {
        unmount = v.verification;
        unmountDate = v.fromDate;
        installDate = v.toDate;

        if (unmount) controller.value = 1;
        loading = false;
        _checkValues();
      });
    }
  }

  void _setUnmount(bool value) {
    if (value) {
      controller.forward();
    } else {
      controller.reverse();
    }
    setState(() {
      unmount = value;
    });
    _checkValues();
  }

  void _setUnmountDate(DateTime value) {
    setState(() {
      unmountDate = value;
      if (installDate != null && value.isAfter(installDate!)) {
        installDate = value;
      }
      _checkValues();
    });
  }

  void _setInstallDate(DateTime value) {
    setState(() {
      installDate = value;
      _checkValues();
    });
  }

  void _checkValues() {
    if (!unmount || unmountDate != null && installDate != null) {
      var m = widget.meter;
      widget.onChecking?.call(VerificationWater(m.id, unmount,
          fromDate: unmountDate, toDate: installDate));
    } else {
      widget.onChecking?.call(null);
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
                      SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1,
                        child: Column(
                          children: [
                            DatePicker(
                              placeholder:
                                  AppLocalizations.of(context)!.unmountingDate,
                              date: unmountDate,
                              onChange: _setUnmountDate,
                            ),
                            DatePicker(
                              placeholder:
                                  AppLocalizations.of(context)!.mountingDate,
                              date: installDate,
                              minDate: unmountDate,
                              onChange:
                                  unmountDate != null ? _setInstallDate : null,
                            ),
                          ],
                        ),
                      ),
                      RowSwitch(
                        state: unmount,
                        onChanged: _setUnmount,
                        text: AppLocalizations.of(context)!.unmount,
                      ),
                    ],
                  ),
                )
              ]);
  }
}
