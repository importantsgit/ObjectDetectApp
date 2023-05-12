//
//  UIView.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/12.
//

import UIKit

extension UIView {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 2,
        y: CGFloat = 2,
        blur: CGFloat = 10
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = blur / 2.0
    }
}
