import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dawnn_client/src/network/objects/location.dart' as loc;
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';

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

  /// Compress an image to 95% of its original quality,
  /// correct angle, and convert the image [file] to the base64
  /// format.
  static Future<String> compressToBase64(File file) async {
    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + "/temp.jpg";
    File result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        autoCorrectionAngle: true);
    final bytes = await result.readAsBytes();
    return base64Encode(bytes);
  }

  /// Decode a base64 image [source] to a file.
  /// To be used whenever we implement
  /// getting images from dawn server.
  static File fromBase64(String source) {
    var bytes = base64.decode(source);
    var file = File("newImage.jpg");
    file.writeAsBytesSync(bytes);
    return file;
  }
}
