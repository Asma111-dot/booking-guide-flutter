import UIKit
import GoogleMaps
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GMSServices.provideAPIKey("AIzaSyBCvjMY3_hJuvBtfjpDNPK5wzsmjmWA9Aw")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
