import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // iOS Maps API Key
    GMSServices.provideAPIKey("""
    """)

    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
