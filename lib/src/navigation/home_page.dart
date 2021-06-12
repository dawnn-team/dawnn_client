import 'package:dawnn_client/src/navigation/camera_page.dart';
import 'package:dawnn_client/src/navigation/maps_page.dart';
import 'package:dawnn_client/src/navigation/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

/// Home navigation page.
///
/// Responsible for navigating between [CameraPage], [MapPage], and [SettingsPage]
/// Uses an array in order to switch between pages.
class HomePage extends StatefulWidget {
  final _camera;

  HomePage(this._camera);

  @override
  State<StatefulWidget> createState() => _HomePageState(_camera);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(_camera)
      : _pages = [CameraPage(_camera), MapPage(), SettingsPage()];

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);

  List<Widget> _pages;

  List<PersistentBottomNavBarItem> _icons = [
    PersistentBottomNavBarItem(
        icon: Icon(Icons.camera_alt),
        title: 'Camera',
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey2),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.map),
        title: 'Map',
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey2),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: 'Settings',
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey2)
  ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _pages,
      items: _icons,
      controller: _controller,
      backgroundColor: Colors.red,
    );
  }
}
