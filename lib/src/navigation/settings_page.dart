import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  // TODO Load configuration
  // (https://pub.dev/packages/global_configuration#preamble)
  var currentLanguage = 'English';
  // Also read up on language support.

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          titlePadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // FIXME Do I need this??
          title: 'General',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: currentLanguage,
              leading: Icon(Icons.language),
              onPressed: languageTapped,
            )
          ],
        )
      ],
    );
  }

  void languageTapped(BuildContext context) {
    // Call up a menu to chose language
    // Probably a late game feature
    print('language tapped');
  }
}
