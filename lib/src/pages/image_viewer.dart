import 'dart:convert';
import 'dart:typed_data';

import 'package:dawnn_client/src/network/objects/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Views an [img.Image] with the caption and image displayed.
///
/// Created when constructing markers in [MapPage]. Converts [imgBase64]
/// to a full widget only when displayed, thus saving memory.
class ImageViewerPage extends StatefulWidget {
  final img.Image imgBase64;

  ImageViewerPage(this.imgBase64);

  @override
  State<StatefulWidget> createState() => _ImageViewerPageState(imgBase64);
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  final img.Image image;

  _ImageViewerPageState(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posted image')),
      body: Align(
        alignment: Alignment.center,
        child: ListView(children: [
          Image.memory(Uint8List.fromList(base64.decode(image.base64))),
          // TODO: Make caption look better.
          SelectableText(
            image.caption,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            // overflow: TextOverflow.visible,
          )
        ]),
      ),
    );
  }
}
