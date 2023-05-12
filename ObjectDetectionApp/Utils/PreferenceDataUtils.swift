//
//  PreferenceDataUtils.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/10.
//

import Foundation

class PreferenceDataUtils {
    
    static public func setStringData(val: String, key: String) {
        UserDefaults.standard.set(val, forKey: key)
    }
    
    static public func getStringData(key: String, defaultValue: String = "") -> String {
        let saved = (UserDefaults.standard.value(forKey: key) as? String)
        return saved ?? defaultValue
    }
    
}
