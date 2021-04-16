import 'dart:convert';
import 'dart:io';

import 'package:dawnn_client/src/util/client_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../network/objects/data.dart';
import '../network/objects/image.dart' as image;

/// This is a utility class concerning
/// server communication.
class NetworkUtils {
  /// Posts the image at [imagePath] to Dawnn server.
  static Future<int> postImage(BuildContext context, String imagePath) async {
    // FIXME This won't work correctly with captions - need to construct Image earlier.

    var data = Data(
        image.Image(await ClientUtils.compressToBase64(File(imagePath)),
            'Feature not yet implemented.', await ClientUtils.getLocation()),
        await ClientUtils.getHWID(context));
    var body = json.encode(data.toJson());

    var client = http.Client();

    http.Response response;
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
    return response.statusCode;
  }

  /// Get images as base64 strings in a list
  static Future<List<image.Image>> getImages() async {
    var client = http.Client();

    var parameters = await ClientUtils.getLocation();

    // Adding body to GET is bad practice..
    // But we write both back-end and front-end
    // How bad can it be.
    var response;
    try {
      response = await client.get(Uri(
          scheme: 'http',
          path: '/api/v1/image/',
          host: '10.0.2.2',
          port: 2423,
          queryParameters: parameters.toJson()));
    } catch (exception) {
      print(exception);
      return null;
    }

    List<image.Image> images = (json.decode(response.body) as List)
        .map((i) => image.Image.fromMap(i))
        .toList();

    client.close();
    return images;
  }
}
