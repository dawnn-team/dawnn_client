import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dawnn_client/src/network/objects/location.dart' as loc;
import 'package:device_info/device_info.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class concerning client related actions.
class ClientUtils {
  static var _location = Location();

  /// Get the current location as a Location object.
  ///
  /// Asynchronously stores the data using [_saveLocation]
  static Future<loc.Location> getLocation() async {
    LocationData locationData = await _location.getLocation();
    var location = loc.Location(locationData.latitude, locationData.longitude);

    // Don't wait for saving/updating location to complete.
    _saveLocation(location);
    return location;
  }

  /// Save the location to settings asynchronously.
  @deprecated
  static void _saveLocation(loc.Location location) async {
    // This is deprecated because a solution using this would require passing
    // singleton instance of SharedPreferences through constructors.
    var prefs = await SharedPreferences.getInstance();

    // Impossible values so we know this data is invalid.
    var lat = prefs.getDouble('location_lat') ?? -200.0;
    var long = prefs.getDouble('location_long') ?? -200.0;

    var savedLocation = loc.Location(lat, long);

    // Data is invalid - let's save new data.
    if (savedLocation.longitude == -200 || savedLocation.latitude == -200) {
      prefs.setDouble('location_lat', location.latitude);
      prefs.setDouble('location_long', location.longitude);
    }
  }

  /// Get the HWID of this device.
  ///
  /// Used as a parameter for the json http post request.
  /// Throws [UnsupportedError] if the platform is not supported.
  static Future<String> getHWID() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return sha256
          .convert(iosDeviceInfo.identifierForVendor.codeUnits)
          .toString();
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return sha256.convert(androidDeviceInfo.androidId.codeUnits).toString();
    } else {
      // This shouldn't be possible, but we'll handle it anyway.
      return throw UnsupportedError('This platform is not supported!');
    }
  }

  /// Compress an image to 95%, correct angle, clean metadata, and convert
  /// to base64.
  ///
  /// Compresses an image at [file] to 95% of its original quality,
  /// corrects the rotation angle, removes EXIF metadata, and converts
  /// the image to base64. Performs the above operations on a temporary
  /// image file, then reads the image back as base64.
  static Future<String> compressToBase64(File file) async {
    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + "/temp.jpg";
    File result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        autoCorrectionAngle: true);
    final bytes = await result.readAsBytes();
    return base64Encode(bytes);
  }

  /// Display information to a user about an http response.
  ///
  /// Based on the provided [responseCode], this will show
  /// either [successText] or [failText].
  /// [failText] is predetermined for status code 400.
  /// To cause a failure disregarding [responseCode],
  /// [responseCode] should be -1.
  static void displayResponse(BuildContext context, int responseCode,
      String successText, String failText) {
    String message;

    if (responseCode == -1) {
      context.showFlashBar(
          content: Text(failText),
          icon: Icon(Icons.error),
          enableVerticalDrag: true,
          persistent: false,
          duration: Duration(seconds: 3),
          indicatorColor: Colors.amber,
      );
      return;
    }

    if (responseCode == 400) {
      message = 'Error code 400, bad request. Please report this error.';
    } else if (responseCode == 200) {
      message = successText;
    } else {
      message = 'Unexpected response code: ' + responseCode.toString();
    }

    context.showFlashBar(
        content: Text(message),
        icon: Icon(Icons.check_circle_rounded),
        enableVerticalDrag: true,
        persistent: false,
        duration: Duration(seconds: 3),
        indicatorColor: Colors.green);
  }
}
