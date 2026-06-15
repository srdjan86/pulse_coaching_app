import FirebaseCore
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    configureFirebaseIfNeeded()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  /// firebase_auth inspects every incoming URL via `FIRAuth.canHandleURL`.
  /// That call fatals if FirebaseApp is not configured — including Supabase
  /// auth deep links. Configure from GoogleService-Info when present, otherwise
  /// use a placeholder so non-Firebase backends can handle their own links.
  private func configureFirebaseIfNeeded() {
    guard FirebaseApp.app() == nil else { return }

    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
      let options = FirebaseOptions(contentsOfFile: path)
    {
      FirebaseApp.configure(options: options)
      return
    }

    let options = FirebaseOptions(
      googleAppID: "1:000000000000:ios:0000000000000000000000",
      gcmSenderID: "000000000000"
    )
    options.apiKey = "placeholder-not-used"
    options.projectID = "pulse-placeholder"
    FirebaseApp.configure(options: options)
  }
}
