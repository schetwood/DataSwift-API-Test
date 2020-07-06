import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let rootNav = window?.rootViewController as? UINavigationController,
            let rootVC = rootNav.topViewController as? SearchViewController {
            rootVC.serviceFactory = BaseServiceFactory()
        }
    }
}

