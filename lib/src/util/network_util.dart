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
  static void postImage(
      BuildContext context, String imagePath, String caption) async {
    print('Posting image.');

    User user =
        User(await ClientUtils.getLocation(), await ClientUtils.getHWID());

    var data = img.Image.emptyId(
        await ClientUtils.compressToBase64(File(imagePath)),
        caption,
        user); // uuid is empty because server assigns it, not us.

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
      ClientUtils.displayResponse(context, -1, '', 'Post failed. No internet?');
      return;
    }

    ClientUtils.displayResponse(
        context, response.statusCode, 'Success! Image has been posted.', '');

    // TODO Fix calling ClintUtils.displayResponse from NetworkUtils.

    client.close();

    print('Posted image.');
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
    var response = await client.post(
        Uri(
          scheme: 'http',
          path: '/api/v1/image/request',
          host: '10.0.2.2',
          port: 2423,
        ),
        body: json.encode(user.toJson()),
        headers: {'Content-type': 'application/json'});

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
