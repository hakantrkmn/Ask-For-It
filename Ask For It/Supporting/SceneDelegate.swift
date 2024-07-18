//
//  SceneDelegate.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import FirebaseAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        
        if Auth.auth().currentUser != nil
        {
            Task{
                guard let id = Auth.auth().currentUser?.uid else {return}
                do
                {
                    print("trkmn")
                    UserInfo.shared.user = try await NetworkService.shared.getUserInfo(with: id)
                    dump(UserInfo.shared.user)
                    window.rootViewController = TabBarController()
                }
                catch
                {
                    print("hakan")
                    try  Auth.auth().signOut()
                    window.rootViewController = createNav(vc: LoginVC())
                }
            }
        }
        else
        {
            window.rootViewController = createNav(vc: LoginVC())
        }
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func createNav(vc : UIViewController) -> UINavigationController
    {
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}

