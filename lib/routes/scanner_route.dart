import 'package:com_pay/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScannerRoute extends StatefulWidget {
  const ScannerRoute({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerRouteState();
}

class _ScannerRouteState extends State<ScannerRoute> {
  MobileScannerController controller = MobileScannerController(
      torchEnabled: false, formats: [BarcodeFormat.qrCode]);
  bool _haveResult = false;

  @override
  void initState() {
    super.initState();
  }

  void close(String? result) {
    if (!mounted || _haveResult) return;
    Navigator.pop(context, result);
    _haveResult = true;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _getMask(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      return Row(children: [
        Expanded(child: Container()),
        Expanded(
            child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
              fit: StackFit.expand,
              children: List<Widget>.generate(4, _aimWidget)),
        )),
        Expanded(child: Container())
      ]);
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.black.withAlpha(150),
              )),
          Expanded(
            flex: 4,
            child: Row(children: [
              Expanded(child: Container()),
              Expanded(
                flex: 6,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                      fit: StackFit.expand,
                      children: List<Widget>.generate(4, _aimWidget)),
                ),
              ),
              Expanded(child: Container())
            ]),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.black.withAlpha(150),
              ))
        ],
      );
    }
  }

  Widget _aimWidget(int index) {
    var bs = BorderSide(color: Theme.of(context).primaryColor, width: 10);
    return RotatedBox(
      quarterTurns: index,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: bs, top: bs),
        ),
        width: 50,
        height: 50,
        transform: Matrix4.diagonal3Values(0.2, 0.2, 0.2),
      ),
    );
  }

  Future _openGalery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    controller.stop();
    if (photo != null) {
      controller.analyzeImage(photo.path).then((value) {
        if (!value) {
          showErrorDialog(
              context,
              AppLocalizations.of(context)!.error,
              AppLocalizations.of(context)!.qrNotFound,
              {AppLocalizations.of(context)!.ok: DialogResult.ok});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.aimToQr),
          actions: [
            IconButton(
                onPressed: controller.toggleTorch,
                icon: const Icon(Icons.lightbulb)),
            IconButton(
                onPressed: _openGalery, icon: const Icon(Icons.image_outlined))
          ],
        ),
        body: OrientationBuilder(
          builder: (ctx, orientation) {
            Widget mask = _getMask(orientation);

            return Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (detect) {
                    if (detect.barcodes.isNotEmpty) {
                      close(detect.barcodes[0].rawValue!);
                    }
                  },
                ),
                mask
              ],
            );
          },
        ));
  }
}
