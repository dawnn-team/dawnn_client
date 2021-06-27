import 'package:camera/camera.dart';
import 'package:dawnn_client/src/navigation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init();
  WidgetsFlutterBinding.ensureInitialized();
  final List<CameraDescription> cameras = await availableCameras();
  final CameraDescription firstCamera = cameras.first;

  runApp(DawnnClient(camera: firstCamera));
}

class DawnnClient extends StatefulWidget {
  // This parameter is passed all the way through the app - is there a better way?
  final CameraDescription camera;

  const DawnnClient({Key key, this.camera}) : super(key: key);

  @override
  _DawnnClientState createState() => _DawnnClientState(camera);
}

class _DawnnClientState extends State<DawnnClient> {
  final CameraDescription _camera;

  _DawnnClientState(this._camera);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO Load primarySwatch from config.
      theme: ThemeData(
          primaryColor: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: HomePage(this._camera),
      debugShowCheckedModeBanner: false,
    );
  }
}
