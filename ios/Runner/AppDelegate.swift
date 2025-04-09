import UIKit
import Flutter
// Uncomment the following line if you plan to use Firebase in your app
// import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Uncomment below if using Firebase for services like analytics, messaging, etc.
    // FirebaseApp.configure()

    // Print a custom log message to indicate that the "By Day" app is launching
    print("Launching By Day App...")

    // Register Flutter plugins generated in the project
    GeneratedPluginRegistrant.register(with: self)
    
    // Call the superclass implementation which handles essential Flutter setup
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
