import 'package:dawnn_client/src/util/network_util.dart';
import 'package:flutter/cupertino.dart';

/// This class updates information
/// in the background, such as getting new alerts.
class BackGroundUpdater {

  static List<Image> getImages() async {
    // TODO Handle getting updates while application
    // is in background or closed.

    String str = await NetworkUtils.getImage();
  }

}