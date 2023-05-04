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
        .init(title: "앱을 통해 사물의 움직임을 판별할 수 있습니다!\nOpenCV을 활용했어요", animationName: "camera", buttonColor: .systemRed, buttonTitle: "다음"),
        .init(title: "강아지 종이 궁금하다면 앱을 통해 알아보세요!\nYoloV8을 활용했어요", animationName: "dog", buttonColor: .systemRed, buttonTitle: "앱 사용하기")
    ]
}
