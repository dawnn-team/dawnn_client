import 'package:dawn_client/src/navigation/home_page.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("settings");
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
      home: HomePage(),
    );
  }
}
