

import UIKit
import AppTrackingTransparency

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let gluggaSvio = (scene as? UIWindowScene) else { return }
        let nyrGluggi = UIWindow(windowScene: gluggaSvio)
        let rotStjori = UINavigationController(rootViewController: HradaleikirStjornandi())
        nyrGluggi.rootViewController = rotStjori
        self.window = nyrGluggi
        nyrGluggi.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.vistaGagnaSamhengi()
    }


}
