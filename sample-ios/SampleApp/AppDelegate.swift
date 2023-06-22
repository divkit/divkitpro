import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window:UIWindow?

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = MainViewController()
    window.rootViewController?.view.backgroundColor = .white
    if #available(iOS 13.0, *) {
      window.overrideUserInterfaceStyle = .light
    }
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
