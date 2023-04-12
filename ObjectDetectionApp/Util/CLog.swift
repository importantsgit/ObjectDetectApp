//
//  CLog.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/11.
//

import Foundation
import os.log

public func CLog(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line){
    CLog(nil, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func CLog(_ message: String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    if Consts.consts.IS_DEBUG == false {
        return
    }
    
    let logPrefix = "GLog"
    let className = (fileName as NSString).lastPathComponent
    
    if #available(iOS 10.0, *) {
        if message == nil {
            NSLog("%@", "[\(logPrefix)] <\(className)> \(functionName)")
        } else {
            NSLog("%@", "[\(logPrefix)] \(className) <\(functionName)> [#\(lineNumber)] \(message ?? "")")
        }
    } else {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS : "
        print(formatter.string(from: Date()), terminator: "")
        if message == nil {
            print("[\(logPrefix)] <\(className)> \(functionName)")
        } else {
            print("[\(logPrefix)] <\(className)> \(functionName) [#\(lineNumber)] \(message ?? "")")
        }
    }
}
