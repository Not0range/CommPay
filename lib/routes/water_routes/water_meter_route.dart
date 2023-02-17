import 'package:com_pay/entities/water_meter.dart';
import 'package:com_pay/routes/water_routes/water_tabs/water_measurment_tab.dart';
import 'package:com_pay/routes/water_routes/water_tabs/water_replacement_tab.dart';
import 'package:com_pay/routes/water_routes/water_tabs/water_verification_tab.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaterMeterRoute extends StatefulWidget {
  final String keyString;
  final WaterMeter meter;

  const WaterMeterRoute(
      {super.key, required this.keyString, required this.meter});

  @override
  State<StatefulWidget> createState() => _WaterMeterRouteState();
}

class _WaterMeterRouteState extends State<WaterMeterRoute>
    with SingleTickerProviderStateMixin {
  List<dynamic> results = List.generate(3, (_) => null);
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
  }

  Future _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      debugPrint('Photo!');
    }
  }

  Future _save() async {
    FocusScope.of(context).unfocus();
  }

  List<BottomNavigationBarItem> _tabButtons(BuildContext context) {
    return [
      BottomNavigationBarItem(
        label: AppLocalizations.of(context)!.measurment,
        icon: const Icon(Icons.thermostat),
      ),
      BottomNavigationBarItem(
        label: AppLocalizations.of(context)!.verification,
        icon: const Icon(Icons.checklist),
      ),
      BottomNavigationBarItem(
        label: AppLocalizations.of(context)!.replacement,
        icon: const Icon(Icons.repeat_outlined),
      ),
    ];
  }

  void _tabTap(int i) {
    setState(() {
      results[i] = null;
      selectedTab = i;
    });
  }

  void _setChecking(int i, dynamic value) {
    setState(() {
      results[i] = value;
    });
  }

  Widget _tabs(int i) {
    switch (i) {
      case 0:
        return WaterMeasurmentTab(
            meter: widget.meter, onChecking: (c) => _setChecking(0, c));
      case 1:
        return WaterVerificationTab(
          meter: widget.meter,
          onChecking: (c) => _setChecking(1, c),
        );
      case 2:
        return WaterReplacementTab(
          meter: widget.meter,
          onChecking: (c) => _setChecking(2, c),
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var buttons = _tabButtons(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(buttons[selectedTab].label ?? ''),
        actions: selectedTab == 0
            ? [
                IconButton(
                    onPressed: _takePhoto, icon: const Icon(Icons.camera_alt))
              ]
            : [],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _tabs(selectedTab),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _tabButtons(context),
        currentIndex: selectedTab,
        onTap: _tabTap,
      ),
      floatingActionButton: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: results[selectedTab] != null ? 1 : 0,
          child: FloatingActionButton(
              onPressed: _save, child: const Icon(Icons.save))),
    );
  }
}
