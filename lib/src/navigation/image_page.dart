import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ImageScreen extends StatefulWidget {
  final imagePath;
  final controller;

  ImageScreen(this.imagePath, this.controller);

  @override
  State<StatefulWidget> createState() =>
      _ImageScreenState(imagePath, controller);
}

class _ImageScreenState extends State<ImageScreen> {
  final String imagePath;
  final CameraController controller;
  var _client = http.Client();

  // Initializing this in camera page and in maps page - inefficient.
  var _location = Location();

  _ImageScreenState(this.imagePath, this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image')),
      body: Align(
          alignment: Alignment.center,
          child: ListView(children: [
            Image.file(File(imagePath)),
            ElevatedButton(
                onPressed: () => {_sendHTTPRequest(context)},
                child: Text('Post'))
          ])),
    );
  }

  /// Test method to send http request to localhost,
  /// to the port of Dawn server. Used for testing.
  void _sendHTTPRequest(BuildContext context) async {
    // This is kind of a long method...
    String hwid = await _getId(context);
    Map<double, double> location = await _getLocation();
    String image64 = await _compressToBase64(File(imagePath));

    var body = jsonEncode({
      'image': image64,
      'HWID': hwid,
      'latitude': location.entries.first.key,
      'longitude': location.entries.first.value
    });

    http.Response response;
    try {
      response = await _client.post(
          Uri(
            scheme: 'http',
            userInfo: '',
            host: '10.0.2.2',
            port: 2423,
            path: '/api/v1/image/',
          ),
          body: body,
          headers: {
            'Content-type': 'application/json'
          }).timeout(Duration(seconds: 10));
    } catch (e) {
      // Probably timed out.
      print(e);
      showTopSnackBar(
          context,
          CustomSnackBar.error(
              message: 'Post failed: request timed out. No internet?'));
      return;
    }

    String message;
    Color color;

    if (response.statusCode == 400) {
      message = 'Error code 400, bad request. Please report this error.';
      color = Colors.red;
    } else if (response.statusCode == 200) {
      message = 'Success! Image has been posted.';
      color = Colors.green;
    } else {
      message = 'Unexpected response code: ' + response.statusCode.toString();
      color = Colors.blueAccent;
    }

    showTopSnackBar(
        context, CustomSnackBar.info(message: message, backgroundColor: color));
  }

  /// Compress an image to 95% of its original quality,
  /// correct angle, and convert the image [file] to the base64
  /// format.
  Future<String> _compressToBase64(File file) async {
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
  File _fromBase64(String source) {
    var bytes = base64.decode(source);
    var file = File("newImage.jpg");
    file.writeAsBytesSync(bytes);
    return file;
  }

  // TODO Move methods to a util class

  /// Get the HWID of this device. Used as a parameter
  /// for the json http post request.
  Future<String> _getId(BuildContext context) async {
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

  /// Get the latitude mapped to a longitude
  Future<Map<double, double>> _getLocation() async {
    LocationData locationData = await _location.getLocation();
    return {locationData.latitude: locationData.longitude};
  }
}
