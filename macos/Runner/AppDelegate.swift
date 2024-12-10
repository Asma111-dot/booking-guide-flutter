import Cocoa
import FlutterMacOS
import GoogleMaps

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override init() {
    GMSServices.provideAPIKey("AIzaSyCdHPqc2qAyGgMvGXxHoXolVm-wt_lIJ8I")
    super.init()
  }
}
