import 'package:com_pay/routes/scanner_poute.dart';
import 'package:com_pay/routes/water_routes/my_water_meters_route.dart';
import 'package:com_pay/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:com_pay/api.dart' as api;

import '../routes/water_routes/search_water_meter_route.dart';
import '../routes/water_routes/water_meter_route.dart';

class WaterMenu extends StatelessWidget {
  final String keyString;
  const WaterMenu({super.key, required this.keyString});

  void _goToMeters(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MyWaterMetersRoute(
                  keyString: keyString,
                )));
  }

  Future _goToScanner(BuildContext context) async {
    String? result = await Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const ScannerRoute()));
    if (result == null) return;
    api.searchWaterMeter(keyString, result).then((list) {
      if (list.isEmpty) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) =>
                  WaterMeterRoute(keyString: keyString, meter: list[0])));
    });
  }

  void _goToSearch(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SearchWaterMeterRoute(
                  keyString: keyString,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        MenuItem(
            icon: Icons.speed,
            text: AppLocalizations.of(context)!.myWaterMeters,
            onTap: () => _goToMeters(context)),
        MenuItem(
            icon: Icons.qr_code,
            text: AppLocalizations.of(context)!.searchWaterQr,
            onTap: () => _goToScanner(context)),
        MenuItem(
          icon: Icons.search,
          text: AppLocalizations.of(context)!.searchWaterCode,
          onTap: () => _goToSearch(context),
        )
      ],
    );
  }
}
