//
//  UILa.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/12.
//

import UIKit

extension UILabel{
    func lineHeight(to size: CGFloat) {
        let style = NSMutableParagraphStyle()
        let lineHeight = size
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        self.baselineAdjustment = .none
        
        self.attributedText = NSAttributedString(
            string: self.text ?? "",
            attributes: [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 2,
            ])
    }
}
