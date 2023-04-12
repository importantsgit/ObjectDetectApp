//
//  VideoViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//

import UIKit
import SnapKit

class VideoViewController: OBViewController {
    
    var titleView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemRed
        
        return uiView
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        return label
    }()
    
    private lazy var button: VideoButton = {
        var button = VideoButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setupLayout(radius: 32.0, backColor: .red)

        return button
    }()
    
    var containView = StreamingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containView.setupLayer()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension VideoViewController {
    private func setupLayout() {
        [containView, titleView, button].forEach{
            self.view.addSubview($0)
        }
        
        containView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaInsets)
            $0.right.left.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints{
            $0.width.height.equalTo(64)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(32)
        }
        
        titleView.snp.makeConstraints{
            $0.centerX.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.height.equalTo(60)
            $0.left.right.equalToSuperview()
        }
        
        titleView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
    @objc func buttonTapped() {
        
        if button.isSelected {
            button.isSelected = false
            containView.stopCaptureSession()
        } else {
            button.isSelected = true
            containView.startCaptureSession()
        }
    }
}
