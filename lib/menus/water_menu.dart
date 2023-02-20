import 'package:com_pay/routes/scanner_route.dart';
import 'package:com_pay/routes/water_routes/my_water_meters_route.dart';
import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/menu_item.dart';
import 'package:com_pay/widgets/overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:com_pay/api.dart' as api;

import '../routes/water_routes/search_water_meter_route.dart';
import '../routes/water_routes/water_meter_route.dart';
import '../widgets/loading_indicator.dart';

class WaterMenu extends StatefulWidget {
  final String keyString;
  const WaterMenu({super.key, required this.keyString});

  @override
  State<StatefulWidget> createState() => _WaterMenuState();
}

class _WaterMenuState extends State<WaterMenu> {
  bool loading = false;

  void _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  void _goToMeters(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MyWaterMetersRoute(
                  keyString: widget.keyString,
                )));
  }

  Future _goToScanner(BuildContext context) async {
    String? result = await Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const ScannerRoute()));
    if (result == null) return;
    await Future.delayed(Duration.zero);
    _setLoading(true);
    api.searchWaterMeter(widget.keyString, result).then((list) {
      if (!mounted) return;
      _setLoading(false);
      if (list.isEmpty) {
        showErrorDialog(
            context,
            AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.codeNotFount,
            {AppLocalizations.of(context)!.ok: DialogResult.ok});
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => WaterMeterRoute(
                  keyString: widget.keyString, meter: list[0])));
    });
  }

  void _goToSearch(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SearchWaterMeterRoute(
                  keyString: widget.keyString,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return OverlayWidget(
      overlay: loading
          ? Container(
              color: Colors.black.withAlpha(150),
              alignment: Alignment.center,
              width: double.maxFinite,
              height: double.maxFinite,
              child: const LoadingIndicator(),
            )
          : Container(),
      child: ListView(
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
      ),
    );
  }
}
