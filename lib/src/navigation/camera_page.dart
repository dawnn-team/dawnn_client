import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_page.dart';

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

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.max);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
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
