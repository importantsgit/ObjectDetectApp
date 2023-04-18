//
//  LaunchViewModel.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/11.
//

import Foundation


class LaunchViewModel: NSObject {
    private var user: User?
    
    var bindLaunchViewModelToController : (()->()) = {}
    
    override init() {
        super.init()
    }
}
