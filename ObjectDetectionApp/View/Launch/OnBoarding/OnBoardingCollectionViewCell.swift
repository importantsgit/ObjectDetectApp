//
//  onBoardingCollectionViewCell.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/04.
//

import UIKit
import Lottie
import SnapKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    var actionButtonTap: (()-> Void)?
    
    var animationView: LottieAnimationView = {
        var uiView = LottieAnimationView(frame: .zero)
        uiView.contentMode = .scaleAspectFit
        uiView.loopMode = .loop
        return uiView
    }()
    
    private var label = CreateLabel()
        .setupTextColor(UIColor(hex: "#2C2C2C"))
        .setupFont(UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16))
        .setuplabelNumberOfLines(0)
        .setupLineHeight(32)
        .build()
    
    lazy private var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("지금 사용하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(moveVC), for: .touchUpInside)
        button.backgroundColor = .systemPurple
        button.applyShadow()
        button.layer.cornerRadius = 24
        return button
    }()
    
    func setup(with slide: OnBoardSlide){
        label.text = slide.title
        nextButton.setTitle(slide.buttonTitle, for: .normal)
        nextButton.backgroundColor = slide.buttonColor
        let animation = LottieAnimation.named(slide.animationName)
        animationView.animation = animation
        
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
        setupLayout()

    }
    
}

extension OnBoardingCollectionViewCell {
    private func setupLayout() {
        [animationView, label, nextButton].forEach{
            addSubview($0)
        }
        
        animationView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.width.equalTo(340)
            $0.height.equalTo(animationView.snp.width)
        }
        
        label.snp.makeConstraints{
            $0.top.equalTo(animationView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(140)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    
    @objc func moveVC() {
        actionButtonTap?()
    }
    

}

extension UILabel{

}
