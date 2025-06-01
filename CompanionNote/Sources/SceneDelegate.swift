//
//  SceneDelegate.swift
//  CompanionNote
//
//  Created by 김영훈 on 3/19/25.
//

import UIKit
import Features

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
    
        let firstViewController = UINavigationController(rootViewController: PrayRequestViewController())
        let secondViewController = SocialLoginViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "신앙 일기", image: UIImage(systemName: "map"), tag: 0)
        secondViewController.tabBarItem = UITabBarItem(title: "기도 제목", image: UIImage(systemName: "map"), tag: 1)
        setupTabBarController(with: [firstViewController, secondViewController])
    }
    
    // TabBarController 설정 함수
    private func setupTabBarController(with viewControllers: [UIViewController]) {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        
        tabBarController.tabBar.isTranslucent = false
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = UIColor.lightGray
            
            // 선택된 탭 색상
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "SelectedTabColor")
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "SelectedTabColor") ?? UIColor.black]
            
            // 선택되지 않은 탭 색상
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "UnselectedTabColor")
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "UnselectedTabColor") ?? UIColor.systemGray]
            
            appearance.backgroundColor = UIColor(named: "TabBarColor")
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBarController.delegate = self
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            navigationController.viewControllers = [navigationController.viewControllers.first].compactMap { $0 }
        }
    }
}
