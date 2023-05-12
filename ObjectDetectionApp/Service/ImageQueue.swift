//
//  ImageQueue.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/12.
//

import Foundation

class ImageQueue {
    private var queue = [UIImage?](repeating: nil, count: 3)
    
    private func deleteFirstImage(){
        self.queue.removeFirst()
    }
    
    public func input(image: UIImage) {
        deleteFirstImage()
        self.queue.append(image)
    }
    
    public func getImages()->[UIImage?]{
        self.queue
    }
}
