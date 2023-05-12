//
//  OBUtil.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//

import Foundation
import CryptoSwift

class OBUtils {
    
    static var shared = OBUtils()
    
    private init() {}
    
    func getUUID() -> String {
        let savedUUID = PreferenceDataUtils.getStringData(key: Consts.PrefKey.uuid.rawValue)
        if !savedUUID.isEmpty {
            return savedUUID
        }
        
        let uuid = UUID().uuidString
        let encrypt = encryptAes256ToHex(key: Consts.consts.AES_KEY, sourceString: uuid)
        PreferenceDataUtils.setStringData(val: encrypt, key: Consts.PrefKey.uuid.rawValue)
        
        return encrypt
    }
    
    func encryptAes256ToHex(key: String, sourceString: String) -> String {
        do {
            let encrypted: [UInt8] = try AES(key: key.bytes, blockMode: ECB(), padding: .pkcs5).encrypt(Array(sourceString.utf8))
            let encryptedData = Data(encrypted)
            let hexStr = encryptedData.toHexString()
            return hexStr
        } catch {
            print("[에러] 암호화 에러!! : \(sourceString)")
            return ""
        }
    }
    
    public func joinOverlapArea(areas: [CGRect], width: CGFloat, height: CGFloat) -> [CGRect] {
       
       var controlAreas: [CGRect] = []
       for area in areas {
           let rect = controlRange(rect: area, maxWidth: width, maxHeight: height)
           controlAreas.append(area)
       }
       
       var areaArray = controlAreas
       for i in 0..<controlAreas.count {
           let firstArea = controlAreas[i]
           if (areaArray.contains(firstArea) == false) {
               continue
           }
           
           areaArray = joinArea(standard: firstArea, areas: areaArray)
       }
       
       return areaArray
    }

    private func controlRange(rect: CGRect, maxWidth: CGFloat, maxHeight: CGFloat) -> CGRect {
       let controlRange = 155
       
       var controlLeft = rect.origin.x - CGFloat(controlRange)
       var controlTop = rect.origin.y - CGFloat(controlRange)
       var controlRight = rect.origin.x + rect.size.width + CGFloat(controlRange)
       var controlBottom = rect.origin.y + rect.size.height + CGFloat(controlRange)
       
       controlLeft = max(controlLeft, 0)
       controlTop = max(controlTop, 0)
       controlRight = min(controlRight, CGFloat(maxWidth))
       controlBottom = min(controlBottom, CGFloat(maxHeight))
       
       return CGRect(x: controlLeft, y: controlTop, width: controlRight - controlLeft, height: controlBottom - controlTop)
    }

    private func joinArea(standard: CGRect, areas: [CGRect]) -> [CGRect] {
       var areaArray = areas
       let standardIndex = areas.firstIndex(of: standard)
       
       var resultRect = standard
       
       for i in 0..<areas.count {
           var nextArea = areas[i]
           
           if (i == standardIndex) {
               continue
           }
           
           if ((nextArea.origin.x + nextArea.size.width) < standard.origin.x || nextArea.origin.x > (standard.origin.x + standard.size.width) ||
               (nextArea.origin.y + nextArea.size.height) < standard.origin.y || nextArea.origin.y > (standard.origin.y + standard.size.height)) {
               continue
           }
           
           let left = min(resultRect.origin.x, nextArea.origin.x)
           let top = min(resultRect.origin.y, nextArea.origin.y)
           let right = max(resultRect.origin.x + resultRect.size.width, nextArea.origin.x + nextArea.size.width)
           let bottom = max(resultRect.origin.y + resultRect.size.height, nextArea.origin.y + nextArea.size.height)
           
           resultRect = CGRect(x: left, y: top, width: right - left, height: bottom - top)
           
           areaArray.remove(at: i)
       }
       
       if let index = areaArray.firstIndex(of: standard) {
           areaArray[index] = resultRect
       }
       
       return removeSmallArea(areas: areaArray)
    }
    
    private func removeSmallArea(areas: [CGRect]) -> [CGRect] {
        var resultAreaArray: [CGRect] = []
        let removeArea = 50.0
        for area in areas {
          if area.size.width < removeArea || area.size.height < removeArea {
            continue
          }
          resultAreaArray.append(area)
        }
        return resultAreaArray
      }

}

class detectingObject {
    
}





