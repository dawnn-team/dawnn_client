import 'package:camera/camera.dart';
import 'package:dawnn_client/src/navigation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init(cacheProvider: SharePreferenceCache());
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(DawnnClient(camera: firstCamera));
}

class DawnnClient extends StatefulWidget {
  // This parameter is passed all the way through the app - is there a better way?
  final camera;

  const DawnnClient({Key key, this.camera}) : super(key: key);

  @override
  _DawnnClientState createState() => _DawnnClientState(camera);
}

class _DawnnClientState extends State<DawnnClient> {
  final CameraDescription camera;

  _DawnnClientState(this.camera);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO Load primarySwatch from config.
      theme: ThemeData(
          primaryColor: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: HomePage(this.camera),
    );
  }
}
