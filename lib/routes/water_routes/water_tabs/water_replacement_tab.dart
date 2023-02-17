import 'package:com_pay/widgets/water_meter_widget.dart';
import 'package:flutter/material.dart';

import '../../../entities/water_meter.dart';

class WaterReplacementTab extends StatefulWidget {
  final WaterMeter meter;
  final void Function(bool state)? onChecking;

  const WaterReplacementTab({super.key, required this.meter, this.onChecking});

  @override
  State<StatefulWidget> createState() => _WaterReplacementTab();
}

class _WaterReplacementTab extends State<WaterReplacementTab>
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

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [WaterMeterWidget(widget.meter)]);
  }
}
