//
//  SceneDelegate.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import UIKit
import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        
        self.setNavigationStyle()

        UserDefaultsWorker().setIsFirstSplash(isFirst: true)
        let navigationController = UINavigationController()
        let appVC = UIHostingController(rootView: AppView(store: .init(initialState: App.State(), reducer: App())))
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [appVC]

        window?.backgroundColor = .background
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func setNavigationStyle() {
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.background
        appearance.shadowColor = UIColor.background
        appearance.shadowImage = UIImage(named: "tab-shadow")?.withRenderingMode(.alwaysTemplate)
        appearance.backButtonAppearance = backButtonAppearance
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UINavigationBar.appearance().tintColor = .gray_800
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray_1200,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        
        let tabBarappearance = UITabBarAppearance()
        
        tabBarappearance.configureWithOpaqueBackground()

        tabBarappearance.shadowColor = UIColor.gray_300
        tabBarappearance.shadowImage = UIImage(named: "tab-shadow")?.withRenderingMode(.alwaysTemplate)
        tabBarappearance.backgroundColor = UIColor.background
        
        UITabBar.appearance().scrollEdgeAppearance = tabBarappearance
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
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
