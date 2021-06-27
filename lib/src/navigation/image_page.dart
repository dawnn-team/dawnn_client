import 'dart:io';

import 'package:dawnn_client/src/util/client_util.dart';
import 'package:dawnn_client/src/util/network_util.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Display the fresh user image, optionally add a caption.
///
/// On post calls [NetworkUtils.postImage].
class ImagePage extends StatefulWidget {
  final String _imagePath;

  ImagePage(this._imagePath);

  @override
  State<StatefulWidget> createState() => _ImagePageState(_imagePath);
}

class _ImagePageState extends State<ImagePage> {
  final String _imagePath;
  TextEditingController _textEditingController;
  String _caption = '';
  bool _default = true;
  bool _warned = false;

  _ImagePageState(this._imagePath);

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
            Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: CupertinoTextField(
                    controller: _textEditingController,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    // TODO: Sanitize input here, and later on server?
                    onSubmitted: (String string) => {_caption = string},
                    onTap: _clearString)),
            ElevatedButton(
                onPressed: () => _evaluateAndWarn(), child: Text('Post image'))
          ])),
    );
  }

  void _clearString() {
    if (_default) {
      _textEditingController.clear();
      _default = false;
    }
  }

  void _evaluateAndWarn() async {
    if (_caption == '' && !_warned) {
      context.showFlashDialog(
          content: Text(
              'Consider adding a caption - it can provide information not visible in the photo.'),
          borderColor: Color.fromRGBO(255, 0, 0, 100),
          borderWidth: 3);
      _warned = true;
      return;
    }

    int reply = await NetworkUtils.postImage(context, _imagePath, _caption);
    ClientUtils.displayResponse(context, reply,
        'Success! Image has been posted.', 'Post failed. No internet?');
  }
}
