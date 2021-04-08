import 'dart:convert';
import 'dart:io';

import 'package:dawnn_client/src/util/client_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../network/objects/data.dart';

/// This is a utility class concerning
/// server communication.
class NetworkUtils {
  /// Posts the image at [imagePath] to Dawnn server.
  static void postImage(BuildContext context, String imagePath) async {
    // This is kind of a long method...
    var data = Data(await _compressToBase64(File(imagePath)),
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

  /// Compress an image to 95% of its original quality,
  /// correct angle, and convert the image [file] to the base64
  /// format.
  static Future<String> _compressToBase64(File file) async {
    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + "/temp.jpg";
    File result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        autoCorrectionAngle: true);
    final bytes = await result.readAsBytes();
    return base64Encode(bytes);
  }

  /// Decode a base64 image [source] to a file.
  /// To be used whenever we implement
  /// getting images from dawn server.
  static File _fromBase64(String source) {
    var bytes = base64.decode(source);
    var file = File("newImage.jpg");
    file.writeAsBytesSync(bytes);
    return file;
  }

  // TODO How to elegantly get image from server?
  static Future<Image> getImage() async {
    // Implement after team discussion.
    // For now, use placeholder image.

    //      https://picsum.photos/200

    var client = http.Client();
    var response = await client.get(Uri(
      scheme: 'https',
      userInfo: '',
      path: '/200',
      host: 'picsum.photos',
    ));

    client.close();
  }
}
