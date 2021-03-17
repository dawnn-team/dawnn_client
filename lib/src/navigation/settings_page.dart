import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SettingsScreen(
        children: [
          ColorPickerSettingsTile(
            settingKey: 'key-color-picker',
            title: 'Color scheme',
            defaultValue: Colors.yellow,
            onChange: (value) {
              // TODO Change theme.
            },
          ),
          // This really shouldn't be worked on until the base features are finished.
        ],
      ),
    );
  }

  // Also read up on language support.
  void languageTapped(BuildContext context) {
    // Call up a menu to chose language
    // Probably a late game feature
    print('chose language');
    // GlobalConfiguration().updateValue(key, value)
  }
}
