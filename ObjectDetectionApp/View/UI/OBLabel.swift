//
//  OBLabel.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/04.
//

import UIKit

class CreateLabel {
    private var label = UILabel()
    private var labelText: String = "텍스트"
    private var labelFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    private var labelTextColor: UIColor = .tertiaryLabel
    private var labelNumberOfLines:Int?

    @discardableResult
    public func setupText(_ text: String) -> CreateLabel {
        self.labelText = text
        return self
    }
    
    @discardableResult
    public func setupFont(_ font: UIFont?) -> CreateLabel {
        if let font = font { self.labelFont = font }
        return self
    }
    
    @discardableResult
    public func setupTextColor(_ color: UIColor) -> CreateLabel {
        self.labelTextColor = color
        return self
    }
    
    @discardableResult
    public func setuplabelNumberOfLines(_ num: Int) -> CreateLabel {
        self.labelNumberOfLines = num
        return self
    }
    
    @discardableResult
    public func setuplabelAlignment(_ alignment: NSTextAlignment) -> CreateLabel {
        self.label.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func setupLineHeight(_ lineHeight: CGFloat) -> CreateLabel {
        let style = NSMutableParagraphStyle()
        let lineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = .center
        label.baselineAdjustment = .none
        
        label.attributedText = NSAttributedString(
            string: label.text ?? "",
            attributes: [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - label.font.lineHeight) / 2,
            ])
        
        return self
    }
    
    public func build() -> UILabel {
        var num = 1
        if let labelNumberOfLines = labelNumberOfLines { num = labelNumberOfLines }
        label.text = labelText
        label.font = labelFont
        label.textColor = labelTextColor
        label.numberOfLines = num
        // autoLayout 적용 (폰트크기 저절로 조절)
        label.adjustsFontSizeToFitWidth = true

        return label
    }
}
