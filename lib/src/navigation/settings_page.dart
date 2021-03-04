import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:global_configuration/global_configuration.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          titlePadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Do I need this?
          title: 'General',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: GlobalConfiguration().getValue("language"),
              leading: Icon(Icons.language),
              onPressed: languageTapped,
            )
          ],
        )
      ],
    );
  }

  // Also read up on language support.
  void languageTapped(BuildContext context) {
    // Call up a menu to chose language
    // Probably a late game feature
    print('chose language');
  }
}
