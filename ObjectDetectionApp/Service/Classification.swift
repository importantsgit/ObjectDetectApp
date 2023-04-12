//
//  Classification.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/11.
//

import Foundation

class Classification {
    var queue = [dogStatus?](repeatElement(dogStatus.none, count: 5))
    var idx = 0
    var maxCount = 3
    var result: dogStatus = .none
    var count:Int {
        return self.queue.count
    }
    
    private func enqueue(item: dogStatus) {
        queue.append(item)
    }
    
    @discardableResult
    private func dequeue() -> dogStatus? {
        guard count > idx,
              let item = queue[0] else {return dogStatus.none}
        queue[idx] = dogStatus.none
        idx += 1
        if idx > 0 {
            queue.removeFirst()
            idx = 0
        }
        return item
    }
    
    func enqueueDogStatus(status: dogStatus) {
        enqueue(item: status)
        dequeue()
    }
    
    func findStatus() -> dogStatus {
        for i in dogStatus.allCases {
            if queue.filter({$0 == i}).count > maxCount {
                if result != i {
                    result = i
                    return i
                }
            }
        }
        return .none
    }
    
    func matchingPose(status: String?) -> dogStatus {
        var dogStatus: dogStatus = .none
        switch status {
        case "sit":
            dogStatus = .sit
        case "lie":
            dogStatus = .lie
        case "stand":
            dogStatus = .stand
        default:
            return dogStatus
        }
        return dogStatus
    }
}
