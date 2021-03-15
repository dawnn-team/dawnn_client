import 'package:dawn_client/src/navigation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init(cacheProvider: SharePreferenceCache());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DawnClient());
}

class DawnClient extends StatefulWidget {

  @override
  _DawnClientState createState() => _DawnClientState();
}

class _DawnClientState extends State<DawnClient> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO Load this from config later.
      theme: ThemeData(primaryColor: Colors.red),
      home: HomePage(),
    );
  }
}
