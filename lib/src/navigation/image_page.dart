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
        body: AspectRatio(
          aspectRatio: 1.21 / controller.value.aspectRatio,
          child: Image.file(File(imagePath)),
        ));

    /*
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          ElevatedButton(onPressed: _sendHTTPRequest, child: Text('sendData')),
          Expanded(child: Container()),
          ElevatedButton(onPressed: _getHTTPRequest, child: Text('getData')),
          Expanded(child: Container())
        ],
      ),*/
  }

  void _sendHTTPRequest() async {
    var hwid = await _getId();
    var location = await _getLocation();
    var body = jsonEncode({
      'image': {'image': 'image-value', 'HWID': hwid, 'location': location}
    });

    print(body);
    _client.post(
        Uri(
            scheme: 'http',
            userInfo: '',
            host: '10.0.2.2',
            port: 2334,
            path: '/api/v1/image/'),
        body: body);
  }

  void _getHTTPRequest() async {}

  // TODO: Fix this
  Future<String> _getId() async {
    // var deviceInfo = DeviceInfoPlugin();
    // if (Theme.of(context).platform == TargetPlatform.iOS) {
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    //   return iosDeviceInfo.identifierForVendor;
    // } else {
    //   var androidDeviceInfo = await deviceInfo.androidInfo;
    //   return androidDeviceInfo.androidId;
    // }
    return null;
  }

  /// Get the latitude and longitude as a json string, in that exact order.
  Future<String> _getLocation() async {
    LocationData locationData = await _location.getLocation();
    var locationJson = jsonEncode({
      'latitude': locationData.latitude,
      'longitude': locationData.longitude
    });

    return locationJson;
  }
}
