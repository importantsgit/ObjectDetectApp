//
//  PermissionViewMargin.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/12.
//

import Foundation

enum PermissionViewMargin {
    static let titleLabelTopMargin: CGFloat = 56.0
    static let titleDescriptionTopMargin: CGFloat = 8.0
    
    enum Common {
        static let titleLeftMargin: CGFloat = 32.0
        static let subDescriptionLeftMargin: CGFloat = -16.0
        static let semiTitleBottomMargin: CGFloat = 24.0
        static let subTitleBottomMargin: CGFloat = 36.0
    }
    
    enum Section {
        static let SectionMargin: CGFloat = 48.0
    }
    
    enum LogoView {
        static let size: CGFloat = 64.0
        static let topMargin: CGFloat = 72.0
    }
    
    enum AccessButton {
        static let sideMargin: CGFloat = 24.0
        static let bottomMargin: CGFloat = 32.0
        static let height: CGFloat = 64.0
    }
}
