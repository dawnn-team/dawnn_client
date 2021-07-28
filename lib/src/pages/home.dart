import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dawnn_client/src/pages/camera.dart';
import 'package:dawnn_client/src/pages/map.dart';
import 'package:dawnn_client/src/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Home navigation page.
///
/// Responsible for navigating between [CameraPage], [MapPage], and [SettingsPage]
/// Uses an array in order to switch between pages.
class HomePage extends StatefulWidget {
  final CameraDescription _camera;

  HomePage(this._camera);

  @override
  State<StatefulWidget> createState() =>
      _HomePageState(_camera, new StreamController.broadcast());
}

class _HomePageState extends State<HomePage> {
  final StreamController changeNotifier;

  int _selectedIndex = 1;
  List<Widget> _pages;

  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1);
  }

  _HomePageState(_camera, this.changeNotifier)
      : _pages = [
          CameraPage(_camera),
          MapPage(changeNotifier.stream),
          SettingsPage()
        ];

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  /// Handles the tapping of the navigation bar.
  ///
  /// If the index to switch is 1, (the index of [MapPage] in [_pages]),
  /// then we push a null event through a stream. [MapPage] listens to that
  /// and requests new images.
  void _onTapped(int index) {
    if (index == 1) {
      // User wants to update marker data
      changeNotifier.sink.add(null);
    }
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: pageController,
          children: _pages,
          // This is a little dirty, but it works.
          physics: NeverScrollableScrollPhysics()),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt), label: 'Camera'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          backgroundColor: Theme.of(context).primaryColor,
          onTap: _onTapped),
    );
  }
}
