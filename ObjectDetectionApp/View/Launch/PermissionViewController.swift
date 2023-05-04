//
//  PermissionViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/04.
//

import UIKit
import SnapKit
import AVFoundation

class PermissionViewController: OBViewController {
    
    var logoView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    var titleLabel = CreateLabel()
        .setupFont(UIFont(name: "AppleSDGothicNeo-Bold", size: 24))
        .setupText("권한 안내")
        .setupTextColor(UIColor(hex: "#1B1B1B"))
        .build()
    
    var descLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 14))
                .setupText("DetectionApp은 아래 권한을 필요로 합니다.\n서비스 사용 중 앱에서 요청 시 허용해주세요.")
                .setupTextColor(UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0))
                .setuplabelNumberOfLines(0)
                .build()
    }()
    
    var semiTitleLabel1: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Bold", size: 16))
                .setupText("필수 접근 권한")
                .setupTextColor(.systemRed)
                .build()
    }()
    
    var cameraTitleLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Medium", size: 14))
                .setupText("∙ 카메라")
                .setupTextColor(.black)
                .build()
    }()
    
    var cameraDescLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 12))
                .setupText("DetectionApp은 카메라 권한을 필요로 합니다.\n서비스 사용 중 앱에서 요청 시 허용해주세요.")
                .setupTextColor(UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0))
                .setuplabelNumberOfLines(0)
                .build()
    }()
    
    var callTitleLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 14))
                .setupText("∙ 전화")
                .setupTextColor(.black)
                .build()
    }()
    
    var callDescLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 12))
                .setupText("DetectionApp은 전화 권한을 필요로 합니다.\n서비스 사용 중 앱에서 요청 시 허용해주세요.")
                .setupTextColor(UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0))
                .setuplabelNumberOfLines(0)
                .build()
    }()
    
    var semiTitleLabel2: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Bold", size: 16))
                .setupText("선택 접근 권한")
                .setupTextColor(.systemRed)
                .build()
    }()
    
    var locationTitleLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 14))
                .setupText("∙ 위치")
                .setupTextColor(.black)
                .build()
    }()
    
    var locationDescLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 12))
                .setupText("DetectionApp은 위치 권한을 필요로 합니다.\n서비스 사용 중 앱에서 요청 시 허용해주세요.")
                .setupTextColor(UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0))
                .setuplabelNumberOfLines(0)
                .build()
    }()
    
    var storageTitleLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 14))
                .setupText("∙ 저장공간")
                .setupTextColor(.black)
                .build()
    }()
    
    var storageDescLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 12))
                .setupText("DetectionApp은 저장공간 권한을 필요로 합니다.\n서비스 사용 중 앱에서 요청 시 허용해주세요.")
                .setupTextColor(UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0))
                .setuplabelNumberOfLines(0)
                .build()
    }()
    
    var bluetoothTitleLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 14))
                .setupText("∙ 블루투스")
                .setupTextColor(.black)
                .build()
    }()
    
    var bluetoothDescLabel: UILabel = {
        return CreateLabel()
                .setupFont(UIFont(name: "AppleSDGothicNeo-Regular", size: 12))
                .setupText("DetectionApp은 블루투스 권한을 필요로 합니다.\n서비스 사용 중 앱에서 요청 시 허용해주세요.")
                .setupTextColor(UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0))
                .setuplabelNumberOfLines(0)
                .build()
    }()
    
    lazy var button: OBButton = {
        var button = OBButton()
        button.setConfigration("다음", UIFont(name: "AppleSDGothicNeo-Regular", size: 18))
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
        self.view.backgroundColor = .systemBackground
        
        [logoView ,titleLabel ,descLabel ,semiTitleLabel1 ,cameraTitleLabel,cameraDescLabel ,callTitleLabel ,callDescLabel ,semiTitleLabel2 ,locationTitleLabel ,locationDescLabel ,storageTitleLabel ,storageDescLabel ,bluetoothTitleLabel, bluetoothDescLabel, button].forEach{
            self.view.addSubview($0)
        }
        
        logoView.snp.makeConstraints{
            $0.width.equalTo(64.0)
            $0.height.equalTo(64.0)
            $0.top.equalToSuperview().inset(64)
            $0.left.equalToSuperview().inset(32)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(logoView.snp.bottom).offset(56)
            $0.left.equalTo(logoView)
        }
        
        descLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(logoView)
        }
        
        semiTitleLabel1.snp.makeConstraints{
            $0.top.equalTo(descLabel.snp.bottom).offset(32)
            $0.left.equalTo(logoView)
        }
        
        cameraTitleLabel.snp.makeConstraints{
            $0.top.equalTo(semiTitleLabel1.snp.bottom).offset(24)
            $0.left.equalTo(logoView)
        }
        
        cameraDescLabel.snp.makeConstraints{
            $0.centerY.equalTo(cameraTitleLabel)
            $0.left.equalTo(semiTitleLabel1.snp.right)
        }
        
        callTitleLabel.snp.makeConstraints{
            $0.top.equalTo(cameraTitleLabel.snp.bottom).offset(32)
            $0.left.equalTo(logoView)
        }
        
        callDescLabel.snp.makeConstraints{
            $0.centerY.equalTo(callTitleLabel)
            $0.left.equalTo(semiTitleLabel1.snp.right)
        }
        
        semiTitleLabel2.snp.makeConstraints{
            $0.top.equalTo(callTitleLabel.snp.bottom).offset(48)
            $0.left.equalTo(logoView)
        }
        
        locationTitleLabel.snp.makeConstraints{
            $0.top.equalTo(semiTitleLabel2.snp.bottom).offset(24)
            $0.left.equalTo(logoView)
        }
        
        locationDescLabel.snp.makeConstraints{
            $0.centerY.equalTo(locationTitleLabel)
            $0.left.equalTo(semiTitleLabel1.snp.right)
        }
        
        storageTitleLabel.snp.makeConstraints{
            $0.top.equalTo(locationTitleLabel.snp.bottom).offset(32)
            $0.left.equalTo(logoView)
        }
        
        storageDescLabel.snp.makeConstraints{
            $0.centerY.equalTo(storageTitleLabel)
            $0.left.equalTo(semiTitleLabel1.snp.right)
        }
        
        bluetoothTitleLabel.snp.makeConstraints{
            $0.top.equalTo(storageTitleLabel.snp.bottom).offset(48)
            $0.left.equalTo(logoView)
        }
        
        bluetoothDescLabel.snp.makeConstraints{
            $0.centerY.equalTo(bluetoothTitleLabel)
            $0.left.equalTo(semiTitleLabel1.snp.right)
        }
        
        let buttonHeight: CGFloat = 64
        
        button.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(32)
            $0.height.equalTo(buttonHeight)
        }
        
        //button.setBorder(buttonHeight/2)
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
        let alert = UIAlertController(title: "카메라 권한을 허용해야 합니다.", message: "앱 설정 페이지에서 수정 바랍니다.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "수정하기", style: .default) { _ in
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}
