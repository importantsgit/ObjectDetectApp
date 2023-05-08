//
//  SceneDelegate.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootController = LaunchViewController()
        window?.rootViewController = rootController
        window?.backgroundColor = .systemRed
        window?.makeKeyAndVisible()
    }

    func setupStatusBar() {
        let window = self.window
        let statusBarManager = window?.windowScene?.statusBarManager
        let barView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
        barView.backgroundColor = .systemRed
        window?.addSubview(barView)
    }
    
    func changeRootVC(_ vc: UIViewController, animated: Bool){
        guard let window = self.window else {return}
        window.rootViewController = vc
        
        if animated {
            UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil)
        }
    }

}

