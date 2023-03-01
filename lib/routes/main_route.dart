import 'package:com_pay/menus/water_menu.dart';
import 'package:com_pay/routes/login_route.dart';
import 'package:com_pay/routes/sending_photos_route.dart';
import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/menu_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainRoute extends StatelessWidget {
  final String keyString;
  const MainRoute(this.keyString, {super.key});

  void _goToWatterSupply(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => WaterMenu(keyString: keyString)));
  }

  void _goToPhotoSending(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => const SendingPhotoRoute()));
  }

  Future _logout(BuildContext context) async {
    showErrorDialog(context, AppLocalizations.of(context)!.close,
        AppLocalizations.of(context)!.exitQuestion, {
      AppLocalizations.of(context)!.yes: DialogResult.ok,
      AppLocalizations.of(context)!.no: DialogResult.cancel
    }).then((result) async {
      if (result == DialogResult.ok) {
        await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const LoginRoute()));
      }
    });
  }

  Future<bool> _willPop(BuildContext context) async {
    var result = await showErrorDialog(
        context,
        AppLocalizations.of(context)!.close,
        AppLocalizations.of(context)!.exitQuestion, {
      AppLocalizations.of(context)!.yes: DialogResult.ok,
      AppLocalizations.of(context)!.no: DialogResult.cancel
    });
    if (result == DialogResult.ok) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _willPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.mainMenu),
          leading: IconButton(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout)),
          actions: [
            IconButton(
                onPressed: () => _goToPhotoSending(context),
                icon: const Icon(Icons.cloud_upload))
          ],
        ),
        body: ListView(children: [
          MenuItem(
            onTap: () => _goToWatterSupply(context),
            icon: Icons.water_drop,
            text: AppLocalizations.of(context)!.waterSupply,
          ),
          MenuItem(
            backgroundColor: Theme.of(context).dividerColor,
            onTap: () {},
            icon: Icons.lightbulb,
            text: AppLocalizations.of(context)!.electricity,
          ),
          MenuItem(
            onTap: () {},
            icon: Icons.gas_meter,
            text: AppLocalizations.of(context)!.gas,
          ),
          MenuItem(
            backgroundColor: Theme.of(context).dividerColor,
            onTap: () {},
            icon: Icons.recycling,
            text: AppLocalizations.of(context)!.recycling,
          ),
        ]),
      ),
    );
  }
}
