//
//  ClassificationViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/04.
//

import UIKit
import SnapKit

class ClassificationViewController: OBViewController {
    
    var titleView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemRed
        
        return uiView
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.text = "강아지 분류"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private lazy var button: VideoButton = {
        var button = VideoButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setupLayout(radius: 32.0, backColor: .red)

        return button
    }()
    
    var containView = ClassificationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containView.setupLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("tearDownAVCapture")
        stop()
    }
}

extension ClassificationViewController {
    private func setupLayout() {
        [containView, titleView, button].forEach{
            self.view.addSubview($0)
        }
        
        button.snp.makeConstraints{
            $0.width.height.equalTo(64)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(32)
        }
        
        titleView.snp.makeConstraints{
            $0.centerX.equalToSuperview().inset(16)
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview()
        }
        
        containView.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom)
            $0.right.left.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        titleView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
    @objc func buttonTapped() {
        button.isSelected ? stop() : play()
    }
    
    func stop(){
        button.isSelected = false
        containView.stopCaptureSession()
        containView.stopRepeatTimer()
    }
    
    func play(){
        button.isSelected = true
        containView.startCaptureSession()
        containView.startTimer()
    }
}
