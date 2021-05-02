import 'dart:convert';
import 'dart:io';

import 'package:dawnn_client/src/network/objects/user.dart';
import 'package:dawnn_client/src/util/client_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../network/objects/image.dart' as img;

/// This is a utility class concerning
/// server communication.
class NetworkUtils {
  /// Posts the image at [imagePath] to Dawnn server.
  static Future<int> postImage(BuildContext context, String imagePath) async {
    // FIXME This won't work correctly with captions - need to construct Image earlier.
    await sendClientUpdate();
    print('Posting image.');

    var data = img.Image(
        await ClientUtils.compressToBase64(File(imagePath)),
        'Feature not yet implemented.',
        await ClientUtils.getLocation(),
        await ClientUtils.getHWID(),
        ''); // uuid is empty because server assigns it, not us.

    var body = json.encode(data.toJson());

    http.Response response;

    var client = http.Client();

    try {
      response = await client.post(
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
      ClientUtils.displayResponse(
          context, -1, null, 'Post failed. No internet?');
      return null;
    }

    ClientUtils.displayResponse(
        context, response.statusCode, 'Success! Image has been posted.', null);

    // TODO Fix calling ClintUtils.displayResponse from NetworkUtils.

    client.close();

    print('Posted image.');
    // Return code is useless right now...
    return response.statusCode;
  }

  /// Get images near our location in a list. Calls sendLocationUpdate()
  /// In order to receive the data most relevant to our location.
  static Future<List<img.Image>> requestImages() async {
    print('Requesting images.');
    sendClientUpdate();
    var client = http.Client();

    var user =
        User(await ClientUtils.getLocation(), await ClientUtils.getHWID());

    // Use POST instead of GET with body.
    var response;
    try {
      response = await client.post(
          Uri(
            scheme: 'http',
            path: '/api/v1/image/request',
            host: '10.0.2.2',
            port: 2423,
          ),
          body: json.encode(user.toJson()),
          headers: {'Content-type': 'application/json'});
    } catch (exception) {
      print(exception);
      return null;
    }

    List<img.Image> images = (json.decode(response.body) as List)
        .map((i) => img.Image.fromMap(i))
        .toList();

    client.close();

    print('Received images.');
    return images;
  }

  /// Send a client update to the server.
  static Future<void> sendClientUpdate() async {
    // TODO Optimize update frequency.
    print('Sending client update.');
    var client = http.Client();

    var user =
        User(await ClientUtils.getLocation(), await ClientUtils.getHWID());

    client.post(
        Uri(
          scheme: 'http',
          userInfo: '',
          host: '10.0.2.2',
          port: 2423,
          path: '/api/v1/user/',
        ),
        body: json.encode(user),
        headers: {'Content-type': 'application/json'});

    print('Sent client update.');
    client.close();
  }
}
