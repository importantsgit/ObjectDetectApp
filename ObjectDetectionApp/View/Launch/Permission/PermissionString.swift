//
//  PermissionString.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/12.
//

import Foundation

enum PermissionString {
    static let permissionInfo = "권한 안내"
    static let requiredAccess = "필수 접근 권한"
    static let optionalAccess = "선택 접근 권한"
    
    enum title:String {
        case Permission = "아래"
        case camera = "카메라"
        case call = "전화"
        case blueTooth = "블루투스"
        case loaction = "위치"
        case storage = "저장공간"
    }
    
    static func description(_ title: PermissionString.title = .Permission) -> String {
        return "DetectionApp은 \(title.rawValue)권한을 필요로 합니다.\n서비스 사용 중 앱에서 요청 시 허용해주세요."
    }
    
    static func getTitle(_ title: PermissionString.title = .Permission) -> String {
        return "∙ \(title.rawValue)"
    }
}
