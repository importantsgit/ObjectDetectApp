//
//  MotionDetectionManager.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/18.
//

import Foundation
import Vision

class MotionDetectionManager {
    private var imageQueue = ImageQueue()
    private var openCVWrapper = OpenCVWrapper()
    
    public func input(image: UIImage) {
        imageQueue.input(image: image)
    }

    public func detectingImage()->UIImage? {
        let images = imageQueue.getImages()
        guard let image1 = images[0],
              let image2 = images[1],
              let image3 = images[2] else {CLog("images are not exist");return nil}
        let rects = openCVWrapper.detectMotion([image1, image2, image3])
        if !rects.isEmpty {
            let objectBounds = rects.first!
            let image = cropRect(objectBounds.cgRectValue ,image: image3)
            return image
        }
        
        return nil
    }
    
    public func getDetectValue()->[NSValue] {
        let images = imageQueue.getImages()
        guard let image1 = images[0],
              let image2 = images[1],
              let image3 = images[2] else {CLog("images are not exist");return []}
        return openCVWrapper.detectMotion([image1, image2, image3])
    }
    
    public func getDetectRect()->[CGRect] {
        let images = imageQueue.getImages()
        guard let image1 = images[0],
              let image2 = images[1],
              let image3 = images[2] else {CLog("images are not exist");return []}
        let rects = openCVWrapper.detectMotion([image1, image2, image3]).map{$0.cgRectValue}
        return rects

    }
    
    
    private func cropRect(_ boundingBox: CGRect, image: UIImage) -> UIImage {
        let imageRef = image.cgImage!.cropping(to: boundingBox)
        let newImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        return newImage
    }
    
}
