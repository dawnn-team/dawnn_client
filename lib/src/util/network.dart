import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dawnn_client/src/network/objects/user.dart';
import 'package:dawnn_client/src/util/client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../network/objects/image.dart' as img;

/// Utility class concerning network related actions.
class NetworkUtils {
  static const String _host = '10.0.2.2'; // dev.dawnn.org

  /// Constructs an [img.Image] and posts it to the server.
  ///
  /// Using provided image at [imagePath] and user
  /// submitted [caption], this method constructs an [img.Image] along with a [User],
  /// which it then posts to the Dawnn server.
  static Future<int> postImage(
      BuildContext context, String imagePath, String caption) async {
    print('Building image and user.');

    List<double> loc = await ClientUtils.getLocation();

    var image = img.Image.emptyId(
        await ClientUtils.compressToBase64(File(imagePath)),
        caption,
        await ClientUtils.getHWID(),
        loc[0],
        loc[1]);

    var body = json.encode(image.toJson());

    http.Response response;

    var client = http.Client();

    try {
      response = await client.post(
          Uri(
            scheme: 'http',
            userInfo: '',
            host: _host,
            port: 2423,
            path: '/api/v1/image/',
          ),
          body: body,
          headers: {'Content-type': 'application/json'});
    } catch (e) {
      // Probably timed out.
      print(e);
      return response == null ? -1 : response.statusCode;
    }

    client.close();

    print('Posted image.');
    return response.statusCode;
  }

  /// Request images near our location in a list.
  static Future<List<img.Image>> requestImages() async {
    // TODO Add caching logic to prevent needless http requests
    print('Requesting images.');

    var client = http.Client();

    List<double> loc = await ClientUtils.getLocation();
    var user = User(loc[0], loc[1], await ClientUtils.getHWID());

    // Use POST instead of GET with body.
    var response;
    try {
      response = await client.post(
          Uri(
            scheme: 'http',
            path: '/api/v1/image/request',
            host: _host,
            port: 2423,
          ),
          body: json.encode(user.toJson()),
          headers: {'Content-type': 'application/json'});
    } catch (exception) {
      print(exception);
    }
    client.close();

    // Not quite elegant, but we'll just step through the response
    // and parse the images mapped to 'content' keys.

    List list;
    List<img.Image> results = [];

    try {
      list = json.decode(response.body);
      for (LinkedHashMap<String, dynamic> item in list) {
        for (MapEntry<String, dynamic> content in item.entries) {
          print(content);
          if (content.key == 'content') {
            // Found the images
            // Parse time
            results.add(img.Image.fromMap(content.value));
          }
        }
      }
    } catch (exception) {
      // Failed parsing - architecture mismatch?
      print('Failed parsing server response - is this the latest app version?');
    }

    print('Received images.');
    return results;
  }
}
