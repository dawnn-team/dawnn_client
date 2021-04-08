import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dawnn_client/src/util/network_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  final imagePath;
  final controller;

  ImageScreen(this.imagePath, this.controller);

  @override
  State<StatefulWidget> createState() =>
      _ImageScreenState(imagePath, controller);
}

class _ImageScreenState extends State<ImageScreen> {
  final String imagePath;
  final CameraController controller;

  _ImageScreenState(this.imagePath, this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image')),
      body: Align(
          alignment: Alignment.center,
          child: ListView(children: [
            Image.file(File(imagePath)),
            ElevatedButton(
                onPressed: () => NetworkUtils.postImage(context, imagePath),
                child: Text('Post'))
          ])),
    );
  }
}
