//
//  OBFonts+Super.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/08.
//

import Foundation

enum OBFont {
    static let header = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
    
    
    enum button {
        static let title = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        static let semiTitle = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
    }
    
    enum title {
        static let title1 = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        static let title2 = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
    }
    
    enum description {
        static let description1 = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        static let description2 = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
    }
    
    enum Popup {
        static let title = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        static let description = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    }
}

