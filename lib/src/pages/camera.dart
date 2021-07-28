import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image.dart';

/// Page that displays a camera.
///
/// When users take the image, this pushes to [ImagePage].
class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  CameraPage(this.camera);

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  // Camera related
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool _cameraExists;

  @override
  void initState() {
    super.initState();
    _cameraExists = widget.camera != null;
    if (_cameraExists) {
      _controller = CameraController(widget.camera, ResolutionPreset.max);
      _initializeControllerFuture = _controller.initialize();
    } else {
      print('Not trying to initialize camera, none exists.');
      return;
    }
    _controller = CameraController(widget.camera, ResolutionPreset.max,
        enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    if (_cameraExists) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraExists) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Align(
                  alignment: Alignment.center,
                  child: CameraPreview(_controller));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),

        //MediaQuery.of(context).size

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () async {
            try {
              await _initializeControllerFuture;

              final image = await _controller.takePicture();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImagePage(
                            image.path,
                          )));
            } catch (exception) {
              print(exception);
            }
          },
        ));
  }
}
