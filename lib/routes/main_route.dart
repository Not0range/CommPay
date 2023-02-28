import 'package:com_pay/menus/water_menu.dart';
import 'package:com_pay/routes/login_route.dart';
import 'package:com_pay/routes/sending_photos_route.dart';
import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/menu_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainRoute extends StatefulWidget {
  final String keyString;
  const MainRoute(this.keyString, {super.key});

  @override
  State<StatefulWidget> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  void _goToWatterSupply() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => WaterMenu(keyString: widget.keyString)));
  }

  void _goToPhotoSending() {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => const SendingPhotoRoute()));
  }

  Future _logout() async {
    showErrorDialog(context, AppLocalizations.of(context)!.logout,
        AppLocalizations.of(context)!.logoutQuestion, {
      AppLocalizations.of(context)!.yes: DialogResult.ok,
      AppLocalizations.of(context)!.no: DialogResult.cancel
    }).then((result) async {
      if (result == DialogResult.ok) {
        await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const LoginRoute()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mainMenu),
        leading: IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        actions: [
          IconButton(
              onPressed: _goToPhotoSending,
              icon: const Icon(Icons.cloud_upload))
        ],
      ),
      body: ListView(children: [
        MenuItem(
          onTap: _goToWatterSupply,
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
    );
  }
}
