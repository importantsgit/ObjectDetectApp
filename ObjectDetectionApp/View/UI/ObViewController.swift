//
//  ObViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//

import UIKit

enum PopupType: Int {
    case text = 0
    case image = 1
    case textField = 2
}

protocol OBUICommonDelegate {
    func showPopupView(popupType: PopupType, title: String, descript: String, textfieldText: String, maxLength:Int, isVisibleCheck: Bool, buttons:[String], leftCompletion: (() -> Void)?, rightCompletion: ((String?) -> Void)?, checkedCompletion: ((Bool) -> Void)?)

}

extension OBUICommonDelegate {
    func showPopupView(popupType: PopupType, title: String, descript: String, textfieldText: String, maxLength:Int, isVisibleCheck: Bool, buttons:[String], leftCompletion: (() -> Void)?, rightCompletion: ((String?) -> Void)?, checkedCompletion: ((Bool) -> Void)?) {
        showPopupView(popupType: popupType, title: title, descript: descript, textfieldText: textfieldText, maxLength: maxLength, isVisibleCheck: isVisibleCheck, buttons: buttons, leftCompletion: leftCompletion, rightCompletion: rightCompletion, checkedCompletion: checkedCompletion)
    }
}

class OBViewController: UIViewController {
    
    public var delegate: OBUICommonDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension OBViewController {
    func setupStatusBar() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.setupStatusBar()
        }
    }
    
    func showAlert(withTitle title: String, message: String,_ buttonText: String = "OK") {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: buttonText, style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    func presentingView(vc: OBViewController) {
        let vc = vc
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func changingRootView(vc: OBViewController, time: Int) {
        let time = time
        
        let DelayTime = DispatchTimeInterval.seconds(time)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+DelayTime) {
                sceneDelegate.changeRootVC(vc, animated: true)
            }
        }
    }
}
