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
            let rects = openCVWrapper.detectMotion([image1, image2, image3])
            if !rects.isEmpty {
                let objectBounds = rects.first!
                let image = cropRect(objectBounds.cgRectValue ,image: image3)
                return image
            }
        }
        return nil
    }
    
    public func getDetectValue()->[NSValue] {
        if queueCount == 3 {
            guard let image1 = imageQueue[0],
                  let image2 = imageQueue[1],
                  let image3 = imageQueue[2] else {CLog("images are not exist");return []}
            return openCVWrapper.detectMotion([image1, image2, image3])
        }
        return []
    }
    
    public func getDetectRect()->[CGRect] {
        if queueCount == 3 {
            guard let image1 = imageQueue[0],
                  let image2 = imageQueue[1],
                  let image3 = imageQueue[2] else {CLog("images are not exist");return []}
            let rects = openCVWrapper.detectMotion([image1, image2, image3]).map{$0.cgRectValue}
            
            var resultArrayList = rects
//            if (resultArrayList.count > 1) {
//                resultArrayList = OBUtils.shared.joinOverlapArea(areas: rects, width: image3.size.width, height: image3.size.height)
//            }
            return resultArrayList
        }
        return []
    }
    
    
    private func cropRect(_ boundingBox: CGRect, image: UIImage) -> UIImage {
        let imageRef = image.cgImage!.cropping(to: boundingBox)
        let newImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        return newImage
    }
    
}
