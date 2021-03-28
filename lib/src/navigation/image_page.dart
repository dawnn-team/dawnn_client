import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
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
    var hwid = await _getId();
    var location = await _getLocation();
    var image64 = await _compressToBase64(File(imagePath));

    var body = jsonEncode({
      'image': {'image': image64, 'HWID': hwid, 'location': location.toString()}
    });

    var response;
    try {
      response = await _client.post(
          Uri(
            scheme: 'http',
            userInfo: '',
            host: '10.0.2.2',
            port: 2334,
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
              message:
                  'Post failed, check Internet connection and try again.'));
      return;
    }

    String message;
    Color color;

    // TODO Handle not being connected to internet.
    switch (response.statusCode) {
      case 400:
        message = 'Error code 400, bad request. Please report this error.';
        color = Colors.red;
        break;
      case 200:
        message = 'Success! Image has been posted.';
        color = Colors.green;
        break;
      default:
        message = 'Unexpected response code: ' + response.statusCode.toString();
        color = Colors.blueAccent;
    }

    showTopSnackBar(
        context, CustomSnackBar.info(message: message, backgroundColor: color));
  }

  Future<String> _compressToBase64(File file) async {
    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + "/temp.jpg";
    File result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        autoCorrectionAngle: true);
    final bytes = await result.readAsBytes();
    return base64Encode(bytes);
  }

  // TODO: Fix this
  /// Get the HWID of this device. Used as a parameter
  /// for the json http post request.
  Future<String> _getId() async {
    // var deviceInfo = DeviceInfoPlugin();
    // if (Theme.of(context).platform == TargetPlatform.iOS) {
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    //   return iosDeviceInfo.identifierForVendor;
    // } else {
    //   var androidDeviceInfo = await deviceInfo.androidInfo;
    //   return androidDeviceInfo.androidId;
    // }
    return 'null';
  }

  /// Get the latitude and longitude as a json string, in that exact order.
  Future<String> _getLocation() async {
    LocationData locationData = await _location.getLocation();
    // TODO Fix
    var locationJson = jsonEncode({
      'latitude': locationData.latitude,
      'longitude': locationData.longitude
    });

    return locationJson;
  }
}
