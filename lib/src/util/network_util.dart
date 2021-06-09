import 'dart:convert';
import 'dart:io';

import 'package:dawnn_client/src/network/objects/user.dart';
import 'package:dawnn_client/src/util/client_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../network/objects/image.dart' as img;

/// Utility class concerning network related actions.
class NetworkUtils {
  /// Constructs an [img.Image] and posts it to the server.
  ///
  /// Using provided image at [imagePath] and user
  /// submitted [caption], this method constructs an [img.Image] along with a [User],
  /// which it then posts to the Dawnn server.
  static void postImage(
      BuildContext context, String imagePath, String caption) async {
    print('Building image and user.');

    User user =
        User(await ClientUtils.getLocation(), await ClientUtils.getHWID());

    var image = img.Image.emptyId(
        await ClientUtils.compressToBase64(File(imagePath)), caption, user);

    var body = json.encode(image.toJson());

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

  /// Request images near our location in a list.
  static Future<List<img.Image>> requestImages() async {
    print('Requesting images.');

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
    }

    List<img.Image> images = (json.decode(response.body) as List)
        .map((i) => img.Image.fromMap(i))
        .toList();

    client.close();

    print('Received images.');
    return images;
  }

  /// Send a client update to the server.
  ///
  /// Constructs a [User] and sends to server. Should only be used when requesting
  /// images for [MapsPage]. Currently deprecated because all server endpoints
  /// explicitly require a full user object, making this obsolete.
  @deprecated
  static Future<void> sendClientUpdate() async {
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
