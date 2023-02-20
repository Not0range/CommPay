import 'package:com_pay/api.dart';
import 'package:com_pay/app_model.dart';
import 'package:com_pay/entities/photo_send.dart';
import 'package:com_pay/entities/water/water_meter.dart';
import 'package:com_pay/routes/water_routes/water_tabs/water_measurment_tab.dart';
import 'package:com_pay/routes/water_routes/water_tabs/water_replacement_tab.dart';
import 'package:com_pay/routes/water_routes/water_tabs/water_verification_tab.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:com_pay/utils.dart';

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
      _addToQueue(photo);
      setState(() {});
    }
  }

  void _addToQueue(XFile file) {
    var provider = Provider.of<AppModel>(context, listen: false);
    PhotoSend? ps = provider.photosToSend.cast<PhotoSend?>().firstWhere(
        (item) => item!.meter.id == widget.meter.id,
        orElse: () => null);
    if (ps == null) {
      provider.add(PhotoSend(widget.meter, DateTime.now().today, [file.path]));
    } else {
      ps.paths.add(file.path);
    }
  }

  Future _save() async {
    FocusScope.of(context).unfocus();

    if (selectedTab == 0) {
      await addMeasurment(results[0]);
    } else if (selectedTab == 1) {
      await addVerification(results[1]);
    } else if (selectedTab == 2) {
      await addReplacement(results[2]);
    }
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
            keyString: widget.keyString,
            meter: widget.meter,
            onChecking: (c) => _setChecking(0, c));
      case 1:
        return WaterVerificationTab(
          keyString: widget.keyString,
          meter: widget.meter,
          onChecking: (c) => _setChecking(1, c),
        );
      case 2:
        return WaterReplacementTab(
          keyString: widget.keyString,
          meter: widget.meter,
          onChecking: (c) => _setChecking(2, c),
        );
    }
    return Container();
  }

  double _getScale(BuildContext context) {
    if (selectedTab != 0) {
      return results[selectedTab] != null ? 1 : 0;
    }

    return results[0] != null && getPhotoCount(context, widget.meter.id) > 0
        ? 1
        : 0;
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
          scale: _getScale(context),
          child: FloatingActionButton(
              onPressed: _save, child: const Icon(Icons.save))),
    );
  }
}
