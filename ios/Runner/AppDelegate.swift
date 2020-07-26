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
    GMSServices.provideAPIKey("AIzaSyCHtOEkVOLwl-jjWHepGr9Y8LVEIyS96Rs")  // Add this line!
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

