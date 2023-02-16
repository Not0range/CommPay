import 'package:com_pay/entities/water_meter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WaterMeasurmentRoute extends StatefulWidget {
  final String keyString;
  final WaterMeter meter;
  const WaterMeasurmentRoute(
      {super.key, required this.keyString, required this.meter});

  @override
  State<StatefulWidget> createState() => _WaterMeasurmentRouteState();
}

class _WaterMeasurmentRouteState extends State<WaterMeasurmentRoute> {
  Future _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      print('Photo!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
            onPressed: _takePhoto, child: const Text('Take a photo')),
      ),
    );
  }
}
