import 'package:dawnn_client/src/util/network_util.dart';
import 'package:flutter/cupertino.dart';

/// This class updates information
/// in the background, such as getting new alerts.
class BackGroundUpdater {
  // Do we really need a new class for this?
  // Might move this elsewhere later.

  /// Updates alerts on the map in Map Page
  static Future<List<Image>> updateMapAlerts() async {
    List<Image> data = await NetworkUtils.getImages();
    if (data == null) {
      // We don't have a BuildContext, since this should be a background
      // compatible task. How to handle errors, if we can't let the user know about it?
    }
  }
}
