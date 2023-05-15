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
        .init(title: OnBoardingCellString.Description.motionString, animationName: "camera", buttonColor: .systemRed, buttonTitle: OnBoardingCellString.Button.nextButton),
        .init(title: OnBoardingCellString.Description.detectionString, animationName: "dog", buttonColor: .systemRed, buttonTitle: OnBoardingCellString.Button.startButton)
    ]
}
