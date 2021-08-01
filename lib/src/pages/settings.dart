import 'package:dawnn_client/src/util/client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

/// A page for the user to edit the settings.
///
/// Currently desolate, but in the future there will be options regarding
/// security, among others.
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
          SwitchSettingsTile(
            title: 'Randomize location',
            settingKey: 'random-location',
            onChange: (bool newState) => {
              if (!kDebugMode && newState)
                {
                  ClientUtils.displayResponse(context, -1, '',
                      'This option is only available in debug mode!'),
                  _setOption('random-location', false)
                }
            },
          )
          // This really shouldn't be worked on until the base features are finished.
        ],
      ),
    );
  }

  /// Set a setting [key] to desired [on] state.
  void _setOption(String key, bool on) async {
    await Settings.setValue<bool>(key, on);
  }

  /// Brings up the menu related to language selection.
  void languageTapped() {
    // Call up a menu to chose language
    // Probably a late game feature
    print('chose language');
    // GlobalConfiguration().updateValue(key, value)
  }
}
