import 'package:camera/camera.dart';
import 'package:dawn_client/src/navigation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init(cacheProvider: SharePreferenceCache());
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(DawnClient(camera: firstCamera));
}

class DawnClient extends StatefulWidget {
  // This parameter is passed all the way through the app - is there a better way?
  final camera;

  const DawnClient({Key key, this.camera}) : super(key: key);

  @override
  _DawnClientState createState() => _DawnClientState(camera);
}

class _DawnClientState extends State<DawnClient> {
  final CameraDescription camera;

  _DawnClientState(this.camera);

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
