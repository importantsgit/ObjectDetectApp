//
//  ModelManager.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/11.
//

import Foundation
import CoreML

class ModelManager {
    let mlModel = try! dogClass(configuration: MLModelConfiguration())
    let dogposeModel = try! dogPose(configuration: MLModelConfiguration())
}
