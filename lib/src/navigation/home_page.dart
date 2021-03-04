import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dawn_client/src/navigation/place_holder.dart';
import 'package:dawn_client/src/navigation/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Set to 1 straight away to load 'home' page.

  final _barItems = [
    TabItem(icon: Icons.camera_alt, title: 'Photos'),
    TabItem(icon: Icons.map, title: 'Map'),
    TabItem(icon: Icons.settings, title: 'Settings'),
  ];

  final List<Widget> _children = [PlaceHolder(), PlaceHolder(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        items: _barItems,
        initialActiveIndex: 1,
        onTap: onTap,
      ),
    );
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
