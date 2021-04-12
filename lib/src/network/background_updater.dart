import 'package:dawnn_client/src/util/network_util.dart';
import 'package:flutter/cupertino.dart';

/// This class updates information
/// in the background, such as getting new alerts.
class BackGroundUpdater {
  
  // Do we really need a new class for this?
  // Might move this elsewhere later.

  /// Updates alerts on the map in Map Page
  static Future<List<Image>> updateMapAlerts() async {


    String str = await NetworkUtils.getImages();
  }

}