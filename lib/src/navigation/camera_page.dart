import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class CameraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  var _client = http.Client();

  // Initializing this in camera page and in maps page - inefficient.
  var _location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Page'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          ElevatedButton(onPressed: _sendHTTPRequest, child: Text('sendData')),
          Expanded(child: Container()),
          ElevatedButton(onPressed: _getHTTPRequest, child: Text('getData')),
          Expanded(child: Container())
        ],
      ),
    );
  }

  void _sendHTTPRequest() async {
    var hwid = await _getId();
    var location = await _getLocation();
    var body = jsonEncode({
      'image': {
        'image': 'image-value',
        'HWID': hwid,
        // 'location' : location
      }
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

  /// Get the latitude and longitude as a json string, in that specific order.
  Future<String> _getLocation() async {
    LocationData locationData = await _location.getLocation();
    var gonk = jsonEncode({
      'latitude': locationData.latitude,
      'longitude': locationData.longitude
    });

    return gonk;
  }

  void _getHTTPRequest() async {}

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }
}
