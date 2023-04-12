//
//  Dog.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/11.
//

import Foundation

enum dogStatus:CaseIterable {
    case none
    case sit
    case stand
    case lie
}

enum dogName {
    case beagle
    case bulldog
    case chihuahua
    case goldenretriever
    case jindo
    case maltese
    case pomeranian
    case poodle
    case shihtzu
}

class Dog {
    var status: dogStatus
    var name: dogName
    
    init(dogStatus: dogStatus, dogName: dogName){
        self.name = dogName
        self.status = dogStatus
    }
    
    func find(str: String)->dogStatus{
        switch str {
        case "sit":
            return .sit
        case "stand":
            return .stand
        case "lie":
            return .lie
        default:
            return .none
        }
    }

}
