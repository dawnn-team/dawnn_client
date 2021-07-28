/// Updates information in the background.
///
/// Sends location updates to the server, allowing for accurate alerts.
/// Not yet implemented.
class BackGroundUpdater {

  // FIXME this is useless


  /// Updates the location of the user in the background.
  ///
  /// Used to provide relevant notification data to the server.
  static void updateLocationBackground() async {
    // Probably won't use FCM to sync while app is in use.
    // https://flutter.dev/docs/development/packages-and-plugins/background-processes
  }
}
