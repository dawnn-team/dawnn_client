import 'package:dawn_client/src/navigation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

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
      theme: ThemeData(primaryColor: Color(int.parse(GlobalConfiguration().getValue("colorScheme").substring(1, 7), radix: 16) + 0xFF000000)), // thank you dart
      home: HomePage(),
    );
  }
}
