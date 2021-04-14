import 'dart:convert';
import 'dart:io';

import 'package:dawnn_client/src/util/client_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../network/objects/data.dart';

/// This is a utility class concerning
/// server communication.
class NetworkUtils {
  /// Posts the image at [imagePath] to Dawnn server.
  static Future<int> postImage(BuildContext context, String imagePath) async {
    var data = Data(await ClientUtils.compressToBase64(File(imagePath)),
        await ClientUtils.getHWID(context), await ClientUtils.getLocation());
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
    }

    ClientUtils.displayResponse(
        context, response.statusCode, 'Success! Image has been posted.', null);

    // TODO Fix calling ClintUtils.displayResponse from NetworkUtils.

    client.close();
    return response.statusCode;
  }

  /// Get images as base64 strings in a list
  static Future<List<Image>> getImages() async {
    // Implement after team discussion.
    // For now, use placeholder image.

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
      return null;
    }

    // TODO Parse Image list out of response.

    client.close();
    return response.body;
  }
}
