import 'dart:convert';
import 'dart:typed_data';

import 'package:dawnn_client/src/network/objects/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final img.Image imgBase64;

  ImageViewer(this.imgBase64);

  @override
  State<StatefulWidget> createState() => _ImageViewerState(imgBase64);
}

class _ImageViewerState extends State<ImageViewer> {
  final img.Image image;

  _ImageViewerState(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posted image')),
      body: Align(
        alignment: Alignment.center,
        child: ListView(children: [
          Image.memory(Uint8List.fromList(base64.decode(image.base64))),
          // TODO: Make caption look better.
          Text(
            image.caption,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            overflow: TextOverflow.ellipsis,
          )
        ]),
      ),
    );
  }
}
