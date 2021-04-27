import 'package:dawnn_client/main.dart';
import 'package:dawnn_client/src/util/network_util.dart';

import '../network/objects/image.dart';

/// This class updates information
/// in the background, such as getting new alerts.
class BackGroundUpdater {


  /// Updates alerts on the map in Map Page
  static void updateMapAlerts() async {
    // TODO Fire this method on FCM receive.
    // Probably won't use FCM to sync while app is in use.

    List<Image> data = await NetworkUtils.requestImages();
    if (data == null || DawnnClient.mapPage == null) {
      // No new data or map hasn't been opened
      return;
    }

    // Access the marker map through DawnnClient
    // https://flutter.dev/docs/development/packages-and-plugins/background-processes
  }

  static void updateLocation() async {}
}
