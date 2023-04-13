//
//  Dog.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/11.
//

import Foundation

enum DogStatus:String, CaseIterable {
    case none
    case sit = "sit"
    case stand = "stand"
    case lie = "lie"
    
    static func findDogStatus(string: String) -> DogStatus {
        switch string {
        case "sit": return DogStatus.sit
        case "stand": return DogStatus.stand
        case "lie": return DogStatus.lie
        default: return DogStatus.none
        }
    }
}

enum DogName: String,CaseIterable {
    case beagle = "beagle"
    case bulldog = "bulldog"
    case chihuahua = "chihuahua"
    case goldenretriever = "goldenretriever"
    case jindo = "jindo"
    case maltese = "maltese"
    case pomeranian = "pomeranian"
    case poodle = "poodle"
    case shihtzu = "shihtzu"
    
    static func findDogName(string: String) -> DogName {
        switch string {
        case "beagle": return DogName.beagle
        case "bulldog": return DogName.bulldog
        case "chihuahua": return DogName.chihuahua
        case "goldenretriever": return DogName.goldenretriever
        case "jindo": return DogName.jindo
        case "maltese": return DogName.maltese
        case "pomeranian": return DogName.pomeranian
        case "poodle": return DogName.poodle
        default: return DogName.shihtzu
        }
    }
}

class Dog {
    var status: DogStatus
    var name: DogName
    
    init(dogStatus: DogStatus, dogName: DogName){
        self.name = dogName
        self.status = dogStatus
    }
    
    func find(str: String)->DogStatus{
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
