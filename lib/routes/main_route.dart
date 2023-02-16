import 'package:com_pay/menus/water_menu.dart';
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

  @override
  Widget build(BuildContext context) {
    var buttons = _tabButtons(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(buttons[selectedTab].label!),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.cloud_upload))
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
