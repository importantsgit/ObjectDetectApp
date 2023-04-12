//
//  UIButton.swift
//  LiveStreamingApp
//
//  Created by 이재훈 on 2023/04/06.
//  Copyright © 2023 Cudo. All rights reserved.
//

import UIKit

class VideoButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoButton {
    func setupLayout(radius: CGFloat, backColor: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4
        
        setupConfigurationUpdateHandler(backColor: backColor)
    }
    
    private func setupConfigurationUpdateHandler(backColor: UIColor) {
        self.configurationUpdateHandler = {btn in
            switch btn.state {
            case .selected:
                btn.backgroundColor = UIColor(red: 148.0/255.0, green: 148.0/255.0, blue: 148.0/255.0, alpha: 1)
            default:
                btn.backgroundColor = backColor
            }
        }
    }
    
    func putImage(image: UIImage, backColor: UIColor) {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = image
        buttonConfig.imagePadding = 4.0
        buttonConfig.imagePlacement = .all
        self.configuration = buttonConfig
        
        self.configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                btn.backgroundColor = UIColor(red: 148.0/255.0, green: 148.0/255.0, blue: 148.0/255.0, alpha: 1)
            default:
                btn.backgroundColor = backColor
            }
        }
    }
}
