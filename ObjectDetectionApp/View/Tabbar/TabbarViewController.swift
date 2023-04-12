//
//  TabbarViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//
import UIKit

class TabbarViewController: UITabBarController {
    private lazy var streamController: UIViewController = {
        let viewController = StreamingViewController()
        let tabBarItem = UITabBarItem(title: "스트리밍", image: UIImage(systemName: "video"), tag: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    private lazy var videoController: UIViewController = {
        let viewController = VideoViewController()
        let tabBarItem = UITabBarItem(title: "동영상", image: UIImage(systemName: "photo"), tag: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [streamController, videoController]
        view.backgroundColor = .systemBackground
        self.view.backgroundColor = .systemRed
        tabBarLayout()
    }
}

extension TabbarViewController {
    func tabBarLayout() {
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = .systemRed
    }
}
