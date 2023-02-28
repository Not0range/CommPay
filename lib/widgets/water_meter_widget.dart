import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../entities/water/water_meter.dart';

class WaterMeterWidget extends StatelessWidget {
  final WaterMeter meter;
  final VoidCallback? onFavorite;

  const WaterMeterWidget(this.meter, {super.key, this.onFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(meter.title),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('${AppLocalizations.of(context)!.liability}: '
              '${meter.responsible}'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('${AppLocalizations.of(context)!.objectId}: '
                    '${meter.id}'),
              ),
              InkWell(
                  onTap: onFavorite,
                  child:
                      Icon(meter.isFavorite ? Icons.star : Icons.star_border))
            ],
          ),
        ),
        const Divider(
          thickness: 2,
        )
      ]),
    );
  }
}
