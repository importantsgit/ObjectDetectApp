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
    
    var actionButtonTap: (() -> Void)?
    
    var animationView: LottieAnimationView = {
        var uiView = LottieAnimationView(frame: .zero)
        uiView.contentMode = .scaleAspectFit
        uiView.loopMode = .loop
        return uiView
    }()
    
    private var label = UILabel()
    
    lazy private var nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(moveVC), for: .touchUpInside)
        button.backgroundColor = .systemPurple
        button.applyShadow()
        button.layer.cornerRadius = 24
        return button
    }()
    
    func setup(with slide: OnBoardSlide){
        label = CreateLabel()
            .setupTextColor(OBColor.titleColor.title2)
            .setupFont(OBFont.title.title1)
            .setuplabelNumberOfLines(0)
            .setupLineHeight(24.0)
            .setupText(slide.title)
            .setuplabelAlignment(.center)
            .build()

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
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: OnBoardingCellMargin.NextButton.bottomMargin),
            nextButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: OnBoardingCellMargin.NextButton.sideMargin),
            nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -OnBoardingCellMargin.NextButton.sideMargin),
            nextButton.heightAnchor.constraint(equalToConstant: OnBoardingCellMargin.NextButton.height),
            
            label.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: OnBoardingCellMargin.Label.bottomMargin),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: OnBoardingCellMargin.AnimationView.bottomMargin),
            animationView.widthAnchor.constraint(equalToConstant: OnBoardingCellMargin.AnimationView.size),
            animationView.heightAnchor.constraint(equalToConstant: OnBoardingCellMargin.AnimationView.size)
        ])
    }
    
    @objc func moveVC() {
        actionButtonTap?()
    }
}
