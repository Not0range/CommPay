import 'package:com_pay/entities/verification_water.dart';
import 'package:com_pay/entities/water_meter.dart';
import 'package:flutter/material.dart';

import '../../../widgets/date_picker.dart';
import '../../../widgets/water_meter_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaterVerificationTab extends StatefulWidget {
  final WaterMeter meter;
  final void Function(VerificationWater? state)? onChecking; //TODO class object

  const WaterVerificationTab({super.key, required this.meter, this.onChecking});

  @override
  State<StatefulWidget> createState() => _WaterVerificationTabState();
}

class _WaterVerificationTabState extends State<WaterVerificationTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

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
  }

  void _setUnmountDate(DateTime value) {
    setState(() {
      unmountDate = value;
      if (installDate != null && !value.difference(installDate!).isNegative) {
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
    if (unmountDate != null && installDate != null) {
      var m = widget.meter;
      widget.onChecking
          ?.call(VerificationWater(m.id, unmountDate!, installDate!));
    } else {
      widget.onChecking?.call(null);
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
                      DatePicker(
                        placeholder:
                            AppLocalizations.of(context)!.unmountingDate,
                        date: unmountDate,
                        onChange: _setUnmountDate,
                      ),
                      DatePicker(
                        placeholder: AppLocalizations.of(context)!.mountingDate,
                        date: installDate,
                        minDate: unmountDate,
                        onChange: unmountDate != null ? _setInstallDate : null,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Switch(value: unmount, onChanged: _setUnmount),
                    InkWell(
                      onTap: () => _setUnmount(!unmount),
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
