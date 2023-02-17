import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../entities/water_meter.dart';

class WaterMeterWidget extends StatelessWidget {
  final WaterMeter meter;

  const WaterMeterWidget(this.meter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(meter.title),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('${AppLocalizations.of(context)!.liability}: '
              '${meter.liability}'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('${AppLocalizations.of(context)!.objectId}: '
              '${meter.id}'),
        )
      ]),
    );
  }
}
