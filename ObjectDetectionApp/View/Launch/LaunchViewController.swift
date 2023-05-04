//
//  LaunchViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//

import UIKit
import AVFoundation
import SnapKit

class LaunchViewController: OBViewController {
    
    var launchViewModel: LaunchViewModel?
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.text = "DetectionApp"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
    
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Consts.consts.IS_DEBUG {
            let tabbarVC = TabbarViewController()
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                DispatchQueue.main.async {
                    sceneDelegate.changeRootVC(tabbarVC, animated: true)
                }
            }
        } else {
            self.setupLayout()
            self.checkPremissions()
        }
    }
}

extension LaunchViewController {
    
    private func setupLayout() {
        [titleLabel].forEach{
            self.view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
    func callToModelForUIUpdate() {
        self.launchViewModel = LaunchViewModel()
        self.launchViewModel?.bindLaunchViewModelToController = {}
    }
    
    func checkPremissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            CLog("카메라권한허가확인")
            self.changingRootView(vc: OnBoardingViewController(), time: 3)
        default:
            CLog("카메라권한허가요청")
            self.changingRootView(vc: PermissionViewController(), time: 3)
        }
    }
}
