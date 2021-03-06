import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  var _client = http.Client();

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
          ElevatedButton(
            onPressed: sendHTTPRequest,
            child: Text('sendData'),
          ),
          Expanded(child: Container()),
          ElevatedButton(onPressed: getHTTPRequest, child: Text('getData')),
          Expanded(child: Container())
        ],
      ),
    );
  }

  void sendHTTPRequest() async {
    _client.post(
        Uri(
            scheme: 'http',
            userInfo: '',
            host: '10.0.2.2',
            port: 2334,
            path: '/api/v1/image/'),
        body: {'image': 'image-value', 'HWID': _getId().toString()});
  }

  void getHTTPRequest() async {}

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
