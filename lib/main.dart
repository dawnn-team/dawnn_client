import 'package:dawn_client/navigation/home_page.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: HomePage(),
    );
  }
}
