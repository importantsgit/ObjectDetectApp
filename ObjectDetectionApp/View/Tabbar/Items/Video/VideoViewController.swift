//
//  VideoViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//

import UIKit
import SnapKit
import PhotosUI

class VideoViewController: OBViewController {
    
    private lazy var picker: PHPickerViewController = {
        var pickerConfiguration = PHPickerConfiguration()
        pickerConfiguration.filter = .any(of: [.videos])
        pickerConfiguration.selectionLimit = 1
        pickerConfiguration.selection = .ordered
        
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.delegate = self
        
        return picker
    }()
    
    var titleView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemRed
        
        return uiView
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.text = "비디오"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private lazy var pickerButton: VideoButton = {
        let button = VideoButton()
        button.setupLayout(radius: 32.0, backColor: .blue)
        button.putImage(image: UIImage(systemName: "square.and.arrow.down") ?? UIImage(), backColor: .blue)
        
        button.addTarget(self, action: #selector(pickerButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var button: VideoButton = {
        var button = VideoButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setupLayout(radius: 32.0, backColor: .red)

        return button
    }()
    
    var containView = VideoView()
    
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
        [containView, titleView, button, pickerButton].forEach{
            self.view.addSubview($0)
        }
        

        
        button.snp.makeConstraints{
            $0.width.height.equalTo(64)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(32)
        }
        pickerButton.snp.makeConstraints{
            $0.width.height.equalTo(64)
            $0.left.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        titleView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
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
        
        if button.isSelected {
            button.isSelected = false
            containView.pause()
        } else {
            button.isSelected = true
            containView.play()
        }
    }
    
    @objc func pickerButtonTapped() {
        self.present(picker, animated: true, completion: nil)
    }
}


extension VideoViewController: PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        itemProvider?.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier){url, error in
            if let url = url {
                
                DispatchQueue.main.sync { [weak self] in
                    guard let self = self else {return}
                    self.picker.dismiss(animated: true)
                    self.containView.setURL(url: url)
                }
            }
        }
    }
}
