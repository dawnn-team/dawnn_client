import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // iOS Maps API Key
    // TODO Load this from dawn_server
    GMSServices.provideAPIKey("""
    """)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
