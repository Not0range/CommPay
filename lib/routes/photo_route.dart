import 'dart:io';

import 'package:com_pay/entities/photo_send.dart';
import 'package:flutter/material.dart';

class PhotoRoute extends StatefulWidget {
  final PhotoSend photosToSend;
  final String title;

  const PhotoRoute(
      {super.key, required this.photosToSend, required this.title});

  @override
  State<StatefulWidget> createState() => _PhotoRouteState();
}

class _PhotoRouteState extends State<PhotoRoute> {
  Future _goToFullscreen(int index, String path) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
              body: InteractiveViewer(
                child: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Center(
                    child: Hero(
                      tag: 'img$index',
                      child: Image.file(File(path), fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
            )));
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
                  onTap: () => _goToFullscreen(index, photos[index]),
                  child: Hero(
                      tag: 'img$index', child: Image.file(File(photos[index]))),
                ),
              )),
    );
  }
}
