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
        label.text = "Streaming"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
    
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Consts.consts.IS_DEBUG == true {
            let tabbarVC = TabbarViewController()
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                DispatchQueue.main.async {
                    sceneDelegate.changeRootVC(tabbarVC, animated: true)
                }
            }
        } else {
            self.setupLayout()
            self.callToModelForUIUpdate()
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
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else {return}
                self.changeView()
                if !granted {
                    self.showPermissionsAlert()
                }
            }
        case .denied, .restricted:
            showPermissionsAlert()
        default:
            changeView()
        }
    }
    
    private func showPermissionsAlert() {
        showAlert(
            withTitle: "카메라 접근",
            message: "유저의 카메라를 사용하기 위해 설정에서 접근권한을 설정하셔야 합니다.")
    }
    
    func changeView() {
        let tabbarVC = TabbarViewController()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) {
                sceneDelegate.changeRootVC(tabbarVC, animated: true)
            }
        }
    }
}
