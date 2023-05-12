//
//  OBFonts+Super.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/08.
//

import UIKit

enum OBFont {
    static let header = UIFont(name: "AppleSDGothicNeo-Bold", size: 24) ?? UIFont()
    
    enum button {
        static let title = UIFont(name: "AppleSDGothicNeo-Medium", size: 18) ?? UIFont()
        static let semiTitle = UIFont(name: "AppleSDGothicNeo-Medium", size: 16) ?? UIFont()
    }
    
    enum title {
        static let title1 = UIFont(name: "AppleSDGothicNeo-Bold", size: 16) ?? UIFont()
        static let title2 = UIFont(name: "AppleSDGothicNeo-Medium", size: 14) ?? UIFont()
    }
    
    enum description {
        static let description1 = UIFont(name: "AppleSDGothicNeo-Medium", size: 14) ?? UIFont()
        static let description2 = UIFont(name: "AppleSDGothicNeo-Medium", size: 12) ?? UIFont()
    }
    
    enum Popup {
        static let title = UIFont(name: "AppleSDGothicNeo-Bold", size: 20) ?? UIFont()
        static let description = UIFont(name: "AppleSDGothicNeo-Regular", size: 14) ?? UIFont()
    }
}

