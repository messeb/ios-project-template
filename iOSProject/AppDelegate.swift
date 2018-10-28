import UIKit
import Core
import Alamofire

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let viewController = UIViewController()
        viewController.view.backgroundColor = Core.backgroundColor

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
