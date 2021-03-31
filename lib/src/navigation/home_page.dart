import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dawnn_client/src/navigation/camera_page.dart';
import 'package:dawnn_client/src/navigation/maps_page.dart';
import 'package:dawnn_client/src/navigation/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final camera;

  HomePage(this.camera);

  @override
  State<StatefulWidget> createState() => _HomePageState(camera);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(_camera)
      : _children = [CameraPage(_camera), MapPage(), SettingsPage()];

  // Set to 1 straight away to load 'home' page.
  int _currentIndex = 1;

  final _barItems = [
    TabItem(icon: Icons.camera_alt, title: 'Photos'),
    TabItem(icon: Icons.map, title: 'Map'),
    TabItem(icon: Icons.settings, title: 'Settings'),
  ];

  final List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        items: _barItems,
        initialActiveIndex: 1,
        onTap: onTap,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
