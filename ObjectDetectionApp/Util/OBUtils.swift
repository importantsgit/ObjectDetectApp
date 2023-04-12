//
//  OBUtil.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//

import Foundation
import CryptoSwift

class OBUtils {
    
    static var obUtils = OBUtils()
    
    private init() {}
    
    func getUUID() -> String {
        let savedUUID = PreferenceDataUtils.getStringData(key: Consts.PrefKey.uuid.rawValue)
        if !savedUUID.isEmpty {
            return savedUUID
        }
        
        let uuid = UUID().uuidString
        let encrypt = OBUtils.obUtils.encryptAes256ToHex(key: Consts.consts.AES_KEY, sourceString: uuid)
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
    
    
}
