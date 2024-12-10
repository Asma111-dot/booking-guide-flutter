import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCdHPqc2qAyGgMvGXxHoXolVm-wt_lIJ8I")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
