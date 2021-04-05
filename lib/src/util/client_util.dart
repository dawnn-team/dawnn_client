import 'package:crypto/crypto.dart';
import 'package:dawnn_client/src/network/objects/location.dart' as loc;
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

/// This is a utility class concerning client related actions,
/// such as getting location or HWID.
class ClientUtils {
  static var _location = Location();

  /// Get the current location as a Location object.
  static Future<loc.Location> getLocation() async {
    LocationData locationData = await _location.getLocation();
    return loc.Location(locationData.latitude, locationData.longitude);
  }

  /// Get the HWID of this device. Used as a parameter
  /// for the json http post request.
  static Future<String> getHWID(BuildContext context) async {
    var deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return sha256
          .convert(iosDeviceInfo.identifierForVendor.codeUnits)
          .toString();
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return sha256.convert(androidDeviceInfo.androidId.codeUnits).toString();
    }
  }
}
