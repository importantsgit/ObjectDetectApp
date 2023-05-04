//
//  TabbarViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//
import UIKit

class TabbarViewController: UITabBarController {
    private lazy var motionDetectionVC: UIViewController = {
        let viewController = MotionDetectionViewController()
        let tabBarItem = UITabBarItem(title: "움직임감지", image: UIImage(systemName: "video"), tag: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    private lazy var classificationVC: UIViewController = {
        let viewController = ClassificationViewController()
        let tabBarItem = UITabBarItem(title: "강아지분류", image: UIImage(systemName: "photo"), tag: 1)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [motionDetectionVC, classificationVC]
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
