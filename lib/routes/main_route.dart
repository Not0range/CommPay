import 'package:com_pay/menus/water_menu.dart';
import 'package:com_pay/routes/login_route.dart';
import 'package:com_pay/routes/sending_photos_route.dart';
import 'package:com_pay/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainRoute extends StatefulWidget {
  final String keyString;
  const MainRoute(this.keyString, {super.key});

  @override
  State<StatefulWidget> createState() => _MainRouteState();
}

//TODO 3 pages
class _MainRouteState extends State<MainRoute> {
  int selectedTab = 0;

  List<BottomNavigationBarItem> _tabButtons(BuildContext context) {
    return [
      BottomNavigationBarItem(
          icon: const Icon(Icons.water_drop),
          label: AppLocalizations.of(context)!.watterSupply),
      BottomNavigationBarItem(
          icon: const Icon(Icons.lightbulb),
          label: AppLocalizations.of(context)!.electricity),
      BottomNavigationBarItem(
          icon: const Icon(Icons.gas_meter),
          label: AppLocalizations.of(context)!.gas),
      BottomNavigationBarItem(
          icon: const Icon(Icons.recycling),
          label: AppLocalizations.of(context)!.recycling)
    ];
  }

  void _tabTap(int i) {
    setState(() {
      selectedTab = i;
    });
  }

  Widget _tab(int index) {
    if (index == 0) {
      return WaterMenu(
        keyString: widget.keyString,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text(AppLocalizations.of(context)!.notImplemnted))
      ],
    );
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
    var buttons = _tabButtons(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(buttons[selectedTab].label!),
        leading: IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        actions: [
          IconButton(
              onPressed: _goToPhotoSending,
              icon: const Icon(Icons.cloud_upload))
        ],
      ),
      body: _tab(selectedTab),
      bottomNavigationBar: BottomNavigationBar(
          items: buttons,
          currentIndex: selectedTab,
          onTap: _tabTap,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey),
    );
  }
}
