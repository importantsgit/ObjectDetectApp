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

        self.setupLayout()
        self.checkPremissions()
    }
}

extension LaunchViewController {
    
    private func setupLayout() {
        [titleLabel].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
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
