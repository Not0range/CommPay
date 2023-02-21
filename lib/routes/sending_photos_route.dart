import 'package:com_pay/app_model.dart';
import 'package:com_pay/widgets/overlay_widget.dart';
import 'package:com_pay/widgets/photo_send_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/loading_indicator.dart';

class SendingPhotoRoute extends StatefulWidget {
  const SendingPhotoRoute({super.key});

  @override
  State<StatefulWidget> createState() => _SendingPhotoRoute();
}

class _SendingPhotoRoute extends State<SendingPhotoRoute> {
  bool loading = false;

  void _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  Future _sendData() async {
    if (loading) return;
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2)); //TODO sending data
    _clearQueue();
    _setLoading(false);
  }

  void _clearQueue() {
    Provider.of<AppModel>(context, listen: false).clear();
  }

  Future<bool> _willPop() async {
    if (loading) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var count =
        Provider.of<AppModel>(context, listen: false).photosToSend.length;
    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context)!.sendingPhotos)),
        body: OverlayWidget(
          overlay: loading
              ? Container(
                  color: Colors.black.withAlpha(150),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: const LoadingIndicator(),
                )
              : Container(),
          child: Consumer<AppModel>(builder: (ctx, model, child) {
            return ListView.builder(
              itemCount: model.photosToSend.length,
              itemBuilder: (context, index) {
                var item = model.photosToSend[index];
                return PhotoSendItem(
                    title: item.meter.title,
                    date: item.date,
                    photoCount: item.paths.length);
              },
            );
          }),
        ),
        floatingActionButton: count > 0
            ? FloatingActionButton(
                onPressed: _sendData, child: const Icon(Icons.upload))
            : null,
      ),
    );
  }
}
