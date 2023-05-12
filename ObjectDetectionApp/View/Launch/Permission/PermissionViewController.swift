//
//  PermissionViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/04.
//

import UIKit
import AVFoundation

class PermissionViewController: OBViewController {
    
    var logoView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    var titleLabel = CreateLabel()
        .setupFont(OBFont.header)
        .setupText(PermissionString.permissionInfo)
        .setupTextColor(OBColor.titleColor.title1)
        .build()
    
    var descLabel: UILabel = CreateLabel()
        .setupFont(OBFont.description.description1)
        .setupText(PermissionString.description())
        .setupTextColor(OBColor.decsriptionColor.decsription1)
        .setuplabelNumberOfLines(0)
        .build()
    
    var semiTitleLabel1: UILabel = CreateLabel()
        .setupFont(OBFont.title.title1)
        .setupText(PermissionString.requiredAccess)
        .setupTextColor(OBColor.accentColor)
        .build()
    
    var cameraTitleLabel: UILabel = CreateLabel()
        .setupFont(OBFont.title.title2)
        .setupText(PermissionString.getTitle(.camera))
        .setupTextColor(OBColor.titleColor.title1)
        .build()
    
    var cameraDescLabel: UILabel = CreateLabel()
        .setupFont(OBFont.description.description2)
        .setupText(PermissionString.description(.camera))
        .setupTextColor(OBColor.decsriptionColor.decsription1)
        .setuplabelNumberOfLines(0)
        .build()
    
    var callTitleLabel: UILabel = CreateLabel()
        .setupFont(OBFont.title.title2)
        .setupText(PermissionString.getTitle(.call))
        .setupTextColor(OBColor.titleColor.title1)
        .build()
    
    var callDescLabel: UILabel = CreateLabel()
        .setupFont(OBFont.description.description2)
        .setupText(PermissionString.description(.call))
        .setupTextColor(OBColor.decsriptionColor.decsription1)
        .setuplabelNumberOfLines(0)
        .build()
    
    var semiTitleLabel2: UILabel = CreateLabel()
        .setupFont(OBFont.title.title1)
        .setupText(PermissionString.optionalAccess)
        .setupTextColor(.systemRed)
        .build()
    
    var locationTitleLabel: UILabel = CreateLabel()
        .setupFont(OBFont.title.title2)
        .setupText(PermissionString.getTitle(.loaction))
        .setupTextColor(OBColor.titleColor.title1)
        .build()
    
    var locationDescLabel: UILabel = CreateLabel()
        .setupFont(OBFont.description.description2)
        .setupText(PermissionString.description(.loaction))
        .setupTextColor(OBColor.decsriptionColor.decsription1)
        .setuplabelNumberOfLines(0)
        .build()
    
    var storageTitleLabel: UILabel = CreateLabel()
        .setupFont(OBFont.title.title2)
        .setupText(PermissionString.getTitle(.storage))
        .setupTextColor(OBColor.titleColor.title1)
        .build()
    
    var storageDescLabel: UILabel = CreateLabel()
        .setupFont(OBFont.description.description2)
        .setupText(PermissionString.description(.storage))
        .setupTextColor(OBColor.decsriptionColor.decsription1)
        .setuplabelNumberOfLines(0)
        .build()
    
    var bluetoothTitleLabel: UILabel = CreateLabel()
        .setupFont(OBFont.title.title2)
        .setupText(PermissionString.getTitle(.blueTooth))
        .setupTextColor(OBColor.titleColor.title1)
        .build()
    
    var bluetoothDescLabel: UILabel = CreateLabel()
        .setupFont(OBFont.description.description2)
        .setupText(PermissionString.description(.blueTooth))
        .setupTextColor(OBColor.decsriptionColor.decsription1)
        .setuplabelNumberOfLines(0)
        .build()
    
    lazy var accessButton: OBButton = {
        var button = OBButton()
        button.setConfigration("다음", OBFont.button.title)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

extension PermissionViewController {
    private func setupLayout() {
        self.view.backgroundColor = OBColor.backgroundColor
        
        [logoView ,titleLabel ,descLabel ,semiTitleLabel1 ,cameraTitleLabel,cameraDescLabel ,callTitleLabel ,callDescLabel ,semiTitleLabel2 ,locationTitleLabel ,locationDescLabel ,storageTitleLabel ,storageDescLabel ,bluetoothTitleLabel, bluetoothDescLabel, accessButton].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // all title left
        [logoView, titleLabel, descLabel, semiTitleLabel1, cameraTitleLabel, callTitleLabel, semiTitleLabel2, locationTitleLabel, storageTitleLabel, bluetoothTitleLabel].forEach {
            $0.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: PermissionViewMargin.Common.titleLeftMargin).isActive = true
        }
        
        // all subDescription left
        [cameraDescLabel, callDescLabel, locationDescLabel, storageDescLabel, bluetoothDescLabel].forEach {
            $0.leftAnchor.constraint(equalTo: semiTitleLabel1.rightAnchor, constant: PermissionViewMargin.Common.subDescriptionLeftMargin).isActive = true
        }
        
        // isActive를 한번에 하는 방법
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: PermissionViewMargin.LogoView.topMargin),
            logoView.widthAnchor.constraint(equalToConstant: PermissionViewMargin.LogoView.size),
            logoView.heightAnchor.constraint(equalToConstant: PermissionViewMargin.LogoView.size),
            
            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: PermissionViewMargin.titleLabelTopMargin),
            
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: PermissionViewMargin.titleDescriptionTopMargin),

            semiTitleLabel1.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: PermissionViewMargin.Section.SectionMargin),

            cameraTitleLabel.topAnchor.constraint(equalTo: semiTitleLabel1.bottomAnchor, constant: PermissionViewMargin.Common.semiTitleBottomMargin),

            cameraDescLabel.centerYAnchor.constraint(equalTo: cameraTitleLabel.centerYAnchor),

            callTitleLabel.topAnchor.constraint(equalTo: cameraTitleLabel.bottomAnchor, constant: PermissionViewMargin.Common.subTitleBottomMargin),

            callDescLabel.centerYAnchor.constraint(equalTo: callTitleLabel.centerYAnchor),
            
            semiTitleLabel2.topAnchor.constraint(equalTo: callTitleLabel.bottomAnchor, constant: PermissionViewMargin.Section.SectionMargin),

            locationTitleLabel.topAnchor.constraint(equalTo: semiTitleLabel2.bottomAnchor, constant: PermissionViewMargin.Common.semiTitleBottomMargin),
            
            locationDescLabel.centerYAnchor.constraint(equalTo: locationTitleLabel.centerYAnchor),
            
            storageTitleLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: PermissionViewMargin.Common.subTitleBottomMargin),
            
            storageDescLabel.centerYAnchor.constraint(equalTo: storageTitleLabel.centerYAnchor),
            
            bluetoothTitleLabel.topAnchor.constraint(equalTo: storageTitleLabel.bottomAnchor, constant: PermissionViewMargin.Common.subTitleBottomMargin),

            bluetoothDescLabel.centerYAnchor.constraint(equalTo: bluetoothTitleLabel.centerYAnchor),
            
            accessButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: PermissionViewMargin.AccessButton.sideMargin),
            accessButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -PermissionViewMargin.AccessButton.sideMargin),
            accessButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -PermissionViewMargin.AccessButton.bottomMargin),
            accessButton.heightAnchor.constraint(equalToConstant: PermissionViewMargin.AccessButton.height)
        ])
    }
    
    @objc func buttonTapped() {
        self.request()
    }
    
    func request() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if granted {
                    self.presentingView(vc: OnBoardingViewController())
                } else {
                    CLog("접근 권한 설정 바람")
                    self.setupAlert()
                }
            }
        }
    }
    
    func setupAlert(){
        let vc = PopupViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.setPopup(title: "카메라 접근권한 필요", description: "카메라 접근 권한이 필요합니다.\n앱 설정 페이지에서 수정 바랍니다.", buttonTitle: "권한허가하기", buttonType: .optional) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }

        self.present(vc, animated: true)
    }
}
