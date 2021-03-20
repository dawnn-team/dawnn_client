import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class ImageScreen extends StatelessWidget {
  final String imagePath;
  final CameraController controller;
  var _client = http.Client();

  // Initializing this in camera page and in maps page - inefficient.
  var _location = Location();

  ImageScreen({Key key, this.imagePath, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Image')),
        body: ListView(children: [
          AspectRatio(
            aspectRatio: 1.21 / controller.value.aspectRatio,
            child: Image.file(File(imagePath)),
          ),
          ElevatedButton(onPressed: _sendHTTPRequest, child: Text('Post')),
        ]));
  }

  /// Test method to send http request to localhost,
  /// to the port of Dawn server. Used for testing
  void _sendHTTPRequest() async {
    var hwid = await _getId();
    var location = await _getLocation();
    var body = jsonEncode({
      'image': {
        'image': 'image-value',
        'HWID': hwid,
        'location': location.toString()
      }
    });

    var response = await _client.post(
        Uri(
          scheme: 'http',
          userInfo: '',
          host: '10.0.2.2',
          port: 2334,
          path: '/api/v1/image/',
        ),
        body: body,
        headers: {'Content-type': 'application/json'});

    print(json.decode(response.body));
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
