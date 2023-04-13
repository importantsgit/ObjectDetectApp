//
//  Classification.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/11.
//

import Foundation



class Classification {
    var queue = Dictionary<DogName, [DogStatus]>()
    private var lastStatus: DogStatus = .none
    private var maxCount = 3
    
    init() {
        for name in DogName.allCases {
            self.queue.updateValue([DogStatus](repeating: .none, count: 5), forKey: name)
        }
    }
    
    // 딕셔너리 내 배열의 첫번째 요소 삭제후 요소 추가
    private func cleanUpQueue(name: DogName, status: DogStatus = .none) {
        queue[name]?.removeFirst()
        queue[name]?.append(status)
    }
    
    // 모든 종의 키에 접근해 cleanUpQueue() 적용
    public func chageDogStatus(name: DogName, status: DogStatus) {
        DogName.allCases.forEach{
            name == $0 ? cleanUpQueue(name: $0, status: status) : cleanUpQueue(name: $0)
        }
    }
    
    // 파라미터로 전달된 종을 키로 접근해 해당 배열에서 maxCount보다 많은 status를 반환
    public func findStatus(name: DogName) -> DogStatus {
        for i in DogStatus.allCases {
            if let count = queue[name]?.filter({$0 == i}).count,
                count > maxCount {
                if lastStatus != i {
                    lastStatus = i
                    return i
                }
            }
        }
        return .none
    }
}
