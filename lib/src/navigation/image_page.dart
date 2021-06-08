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
  final String _imagePath;
  final CameraController _controller;
  TextEditingController _textEditingController;
  String _caption = '';
  bool _default = true;

  _ImageScreenState(this._imagePath, this._controller);

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: 'Add caption');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image')),
      body: Align(
          alignment: Alignment.center,
          child: ListView(children: [
            Image.file(File(_imagePath)),
            CupertinoTextField(
                controller: _textEditingController,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                // TODO: Sanitize input here, and later on server?
                onSubmitted: (String string) => {_caption = string},
                onTap: _clearString),
            ElevatedButton(
                onPressed: () => _evaluateCaption(), child: Text('Post image'))
          ])),
    );
  }

  void _clearString() {
    if (_default) {
      _textEditingController.clear();
      _default = false;
    }
  }

  void _evaluateCaption() {
    if (_caption == '') {
      // TODO: Show alert
      print(
          'Are you sure about sending no caption? Captions can be useful by providing context '
          'or other relating information');
    }
    NetworkUtils.postImage(context, _imagePath, _caption);
  }
}
