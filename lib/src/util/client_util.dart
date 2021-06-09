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
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

/// Utility class concerning client related actions.
class ClientUtils {
  static var _location = Location();

  /// Get the current location as a Location object.
  static Future<loc.Location> getLocation() async {
    LocationData locationData = await _location.getLocation();
    return loc.Location(locationData.latitude, locationData.longitude);
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

  /// Decode a base64 image [source] to a file.
  ///
  /// Not currently used?
  @deprecated
  static Future<File> fromBase64(String source) async {
    var dir = await getTemporaryDirectory();
    var bytes = base64.decode(source);
    var file = File(dir.absolute.path + '/newImage.jpg');
    file.writeAsBytesSync(bytes);
    return file;
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
    Color color;

    if (responseCode == -1) {
      showTopSnackBar(context, CustomSnackBar.error(message: failText));
      return;
    }

    if (responseCode == 400) {
      message = 'Error code 400, bad request. Please report this error.';
      color = Colors.red;
    } else if (responseCode == 200) {
      message = successText;
      color = Colors.green;
    } else {
      message = 'Unexpected response code: ' + responseCode.toString();
      color = Colors.blueAccent;
    }

    showTopSnackBar(
        context, CustomSnackBar.info(message: message, backgroundColor: color));
  }
}
