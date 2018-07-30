import Fabulous
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FabulousButton.appearance().backgroundColor = UIColor(red: 0.3098, green: 0.6235, blue: 0.2745, alpha: 1)
        FabulousButton.appearance().tintColor = UIColor(red: 0.6235, green: 0.9373, blue: 0.5882, alpha: 1)
        FabulousActionLabel.appearance().setBackgroundColor(to: UIColor(red: 0.3098, green: 0.6235, blue: 0.2745, alpha: 1))
        FabulousActionLabel.appearance().setTextColor(to: UIColor(red: 0.6235, green: 0.9373, blue: 0.5882, alpha: 1))
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.2039, green: 0.2471, blue: 0.2235, alpha: 1)

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: ViewController())
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleTextAttributes = [
                .foregroundColor: UIColor(red: 0.3098, green: 0.6235, blue: 0.2745, alpha: 1)
            ]
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

}


