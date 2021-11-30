import 'package:camera/camera.dart';
import 'package:dawnn_client/src/background/notification_controller.dart';
import 'package:dawnn_client/src/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init();
  final List<CameraDescription> cameras = await availableCameras();
  final CameraDescription firstCamera =
      cameras.isNotEmpty ? cameras.first : null;

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (firstCamera == null) {
    print('No camera found; unsupported device or iOS simulator.');
  }
  runApp(DawnnClient(camera: firstCamera));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Used for testing
  await FirebaseMessaging.instance.subscribeToTopic('dev');
  print('Handling a background message: ${message.messageId}');
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

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // Firebase app has finished initializing, let's start listening
            // to messages.
            NotificationController.controller;
            return MaterialApp(
              // TODO Load primarySwatch from config.
              theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSwatch(primarySwatch: Colors.red),
                  primaryColor: Colors.red,
                  visualDensity: VisualDensity.adaptivePlatformDensity),
              home: HomePage(this._camera),
              debugShowCheckedModeBanner: false,
            );
          }
          print('Loading the app');
          return Center(child: CircularProgressIndicator());
        });
  }
}
