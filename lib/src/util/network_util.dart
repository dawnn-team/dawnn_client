import 'dart:convert';
import 'dart:io';

import 'package:dawnn_client/src/util/client_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../network/objects/data.dart';

/// This is a utility class concerning
/// server communication.
class NetworkUtils {
  /// Posts the image at [imagePath] to Dawnn server.
  static void postImage(BuildContext context, String imagePath) async {
    // This is kind of a long method...
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
      showTopSnackBar(
          context, CustomSnackBar.error(message: 'Post failed. No internet?'));
      return;
    }

    client.close();

    String message;
    Color color;

    if (response.statusCode == 400) {
      message = 'Error code 400, bad request. Please report this error.';
      color = Colors.red;
    } else if (response.statusCode == 200) {
      message = 'Success! Image has been posted.';
      color = Colors.green;
    } else {
      message = 'Unexpected response code: ' + response.statusCode.toString();
      color = Colors.blueAccent;
    }

    showTopSnackBar(
        context, CustomSnackBar.info(message: message, backgroundColor: color));
  }

  /// Get images as base64 strings in a list
  static Future<String> getImages() async {
    // Implement after team discussion.
    // For now, use placeholder image.

    var client = http.Client();
    var response = await client.get(Uri(
      scheme: 'http',
      path: '/api/v1/image/',
      host: '10.0.2.2',
      port: 2423,
    ));

    // TODO Handle errors
    client.close();
    return response.body;
  }
}
