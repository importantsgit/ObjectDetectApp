//
//  MotionDetectionManager.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/18.
//

import Foundation
import Vision

class MotionDetectionManager {
    private var imageQueue: [UIImage?] = []
    private var openCVWrapper = OpenCVWrapper()

    private var queueCount:Int {
        return imageQueue.count
    }
    
    public func inqueue(image: UIImage) {
        imageQueue.append(image)
        if queueCount > 3 {
            imageQueue.removeFirst()
        }
    }
    
    public func test()->[UIImage]{
        return imageQueue.map{
            if let UIImage = $0 {
                return UIImage
            } else {
                return UIImage()
            }
        }
    }
    
    public func detectingImage()->UIImage? {
        if queueCount == 3 {
            guard let image1 = imageQueue[0],
                  let image2 = imageQueue[1],
                  let image3 = imageQueue[2] else {CLog("images are not exist");return nil}
            let rect = openCVWrapper.detectMotion([image1, image2, image3])
            if rect.width != 0.0 {
                let objectBounds = rect
                let image = cropRect(objectBounds ,image: image3)
                return image
            }
            print(rect)
        }
        return nil
    }
    
    private func cropRect(_ boundingBox: CGRect, image: UIImage) -> UIImage {
        let imageRef = image.cgImage!.cropping(to: boundingBox)
        let newImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        return newImage
    }
    
}
