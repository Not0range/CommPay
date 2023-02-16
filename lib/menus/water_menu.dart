import 'package:com_pay/routes/scanner_poute.dart';
import 'package:com_pay/routes/water_routes/my_water_meters_route.dart';
import 'package:com_pay/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../routes/water_routes/search_water_meter_roote.dart';

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

  //TODO go to measurment page
  Future _goToScanner(BuildContext context) async {
    String? result = await Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const ScannerRoute()));
    debugPrint(result);
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
