import 'dart:io';

import 'package:com_pay/entities/photo_send.dart';
import 'package:com_pay/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../app_model.dart';

class PhotoRoute extends StatefulWidget {
  final PhotoSend photosToSend;
  final String title;

  const PhotoRoute(
      {super.key, required this.photosToSend, required this.title});

  @override
  State<StatefulWidget> createState() => _PhotoRouteState();
}

class _PhotoRouteState extends State<PhotoRoute> {
  Future _goToFullscreen(int index) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
              body: InteractiveViewer(
                child: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Center(
                    child: Hero(
                      tag: 'img$index',
                      child: Image.file(File(widget.photosToSend.paths[index]),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () => _removePhoto(index),
                  child: const Icon(Icons.delete_outline)),
            )));
  }

  Future _removePhoto(int index) async {
    showErrorDialog(context, AppLocalizations.of(context)!.delete,
        AppLocalizations.of(context)!.deleteQuestion, {
      AppLocalizations.of(context)!.yes: DialogResult.ok,
      AppLocalizations.of(context)!.no: DialogResult.cancel
    }).then((result) {
      if (result != DialogResult.ok) return;

      Navigator.pop(context);

      Provider.of<AppModel>(context, listen: false)
          .removePhotoAt(widget.photosToSend, index);
      if (widget.photosToSend.paths.isEmpty) Navigator.pop(context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var photos = widget.photosToSend.paths;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: photos.length,
          itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () => _goToFullscreen(index),
                  child: Hero(
                      tag: 'img$index', child: Image.file(File(photos[index]))),
                ),
              )),
    );
  }
}
