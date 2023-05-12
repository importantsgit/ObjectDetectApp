//
//  OnBoardSlide.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/04.
//

import UIKit

struct OnBoardSlide {
    let title: String
    let animationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static let collection: [OnBoardSlide] = [
        .init(title: OnBoardingString.Description.motionString, animationName: "camera", buttonColor: .systemRed, buttonTitle: OnBoardingString.Button.nextButton),
        .init(title: OnBoardingString.Description.detectionString, animationName: "dog", buttonColor: .systemRed, buttonTitle: OnBoardingString.Button.startButton)
    ]
}
