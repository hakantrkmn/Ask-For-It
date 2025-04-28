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

        if Auth.auth().currentUser != nil {
            Task {
                guard let id = Auth.auth().currentUser?.uid else { return }
                do {
                    UserInfo.shared.user = try await NetworkService.shared.getUserInfo(with: id)
                    window.rootViewController = TabBarController()
                    handleDeepLink(connectionOptions: connectionOptions, window: window)
                } catch {
                    try Auth.auth().signOut()
                    window.rootViewController = createNav(vc: LoginVC())
                }
            }
        } else {
            window.rootViewController = createNav(vc: LoginVC())
        }
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func handleDeepLink(connectionOptions: UIScene.ConnectionOptions, window: UIWindow) {
        if let urlContext = connectionOptions.urlContexts.first {
            handleURL(url: urlContext.url, window: window)
        }
    }

    func handleURL(url: URL, window: UIWindow) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else {
            return
        }

        if host == "details", let queryItems = components.queryItems {
            for item in queryItems {
                if item.name == "id", let id = item.value {
                    // Detay sayfasına yönlendirin
                    navigateToDetailPage(withId: id, window: window)
                }
            }
        }
    }
    
    

    func navigateToDetailPage(withId id: String, window: UIWindow) {
        
        Task{
            do{
                print("456")
                var question = try await NetworkService.shared.getQuestion(with: id)
                if question.createdUserID == Auth.auth().currentUser?.uid || question.answeredUserID.contains(Auth.auth().currentUser?.uid ?? "")
                {
                    let detailVC = QuestionDetailVC()
                    detailVC.vm.questionID = id
                    if let tabBarController = window.rootViewController as? UITabBarController {
                        if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                            navigationController.pushViewController(detailVC, animated: true)
                        } else {
                            tabBarController.selectedViewController?.present(detailVC, animated: true, completion: nil)
                        }
                    } else if let navigationController = window.rootViewController as? UINavigationController {
                        navigationController.pushViewController(detailVC, animated: true)
                    } else {
                        window.rootViewController?.present(detailVC, animated: true, completion: nil)
                    }
                }
                else
                {
                    print("1234")
                    let detailVC = AnswerQuestionVC()
                    detailVC.vm.questionId = id
                    if let tabBarController = window.rootViewController as? UITabBarController {
                        if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                            navigationController.pushViewController(detailVC, animated: true)
                        } else {
                            tabBarController.selectedViewController?.present(detailVC, animated: true, completion: nil)
                        }
                    } else if let navigationController = window.rootViewController as? UINavigationController {
                        navigationController.pushViewController(detailVC, animated: true)
                    } else {
                        window.rootViewController?.present(detailVC, animated: true, completion: nil)
                    }
                }

            }
            catch
            {
                print("aksdnas")
                let detailVC = FeedVC()
                if let tabBarController = window.rootViewController as? UITabBarController {
                    if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                        navigationController.pushViewController(detailVC, animated: true)
                    } else {
                        tabBarController.selectedViewController?.present(detailVC, animated: true, completion: nil)
                    }
                } else if let navigationController = window.rootViewController as? UINavigationController {
                    navigationController.pushViewController(detailVC, animated: true)
                } else {
                    window.rootViewController?.present(detailVC, animated: true, completion: nil)
                }
            }
        }
        

        
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

