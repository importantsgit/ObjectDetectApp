//
//  Streaming2View.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/12.
//

import UIKit
import SnapKit
import AVFoundation
import CoreML
import Vision

class StreamingView: UIView {
    var dogPoseModel = try! dogPose(configuration: MLModelConfiguration())
    var poseName = [String]()
    var dogClassModel = try! dogClass(configuration: MLModelConfiguration())
    var className = [String]()
    
    var motionDetection = MotionDetectionManager()
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var classification = Classification()
    
    var bufferSize: CGSize = .zero
    
    private var caputureSession = AVCaptureSession()
    
    private let streamingOutput = AVCaptureVideoDataOutput()
    
    private var streamingLayer: AVCaptureVideoPreviewLayer! = nil
    
    private let streamingDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    private var detectionOverlay: CALayer! = nil
    
    var timer: Timer?
        
    var pixelBuffer: CVPixelBuffer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCameraLiveView()
        poseName = dogPoseModel.model.modelDescription.classLabels as! [String]
        className = dogClassModel.model.modelDescription.classLabels as! [String]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StreamingView {
    
    //MARK: - setupLayout
    
    func setupLayer(){
        let rootLayer = self.layer
        streamingLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(streamingLayer)
        setupdetectionOverlay()
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(160)
            $0.top.left.equalToSuperview()
        }
        
        updateLayerGeometry()
    }
    
    func setupdetectionOverlay() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.layer.addSublayer(detectionOverlay)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5 , repeats: true, block: {[weak self] _ in
            guard let self = self,
                  let pixelBuffer = self.pixelBuffer
            else {return}

            if Consts.consts.IS_DEBUG {
                if Consts.consts.IS_MOTIONDETECT {
                    guard let image = self.motionDetection.detectingImage() else {return}
                    self.imageView.image = image
                } else{
                    guard let output = try? self.dogClassModel.prediction(image: pixelBuffer, iouThreshold: 0.70, confidenceThreshold: 0.70) else {return}
                    if !output.confidenceShapedArray.isEmpty {
                        DispatchQueue.main.async(execute: {
                            self.drawVisionRequestResults(output, pixelBuffer)
                        })
                    } else {
                        DispatchQueue.main.async {
                            self.detectionOverlay.sublayers = nil
                        }
                    }
                }

            }
        })
    }
    
    func stopRepeatTimer(){
        guard let timer = timer else { return }
        if timer.isValid { timer.invalidate() }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            guard let self = self else {return}
            self.detectionOverlay.sublayers = nil
        })
    }
    
    
    //MARK: - setupCamera
    private func setupCameraLiveView() {
        var deviceInput: AVCaptureDeviceInput!
        let captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            CLog("장치가 연결되지 않았습니다 : \(error)")
        }
        
        caputureSession.beginConfiguration()
        caputureSession.sessionPreset = .hd1280x720
        
        guard caputureSession.canAddInput(deviceInput) else {
            CLog("세션에 input을 추가하지 못했습니다")
            caputureSession.commitConfiguration()
            return
        }
        
        caputureSession.addInput(deviceInput)
        
        if caputureSession.canAddOutput(streamingOutput) {
            caputureSession.addOutput(streamingOutput)
            
            streamingOutput.alwaysDiscardsLateVideoFrames = true
            
            streamingOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            streamingOutput.setSampleBufferDelegate(self, queue: streamingDataOutputQueue)
        } else {
            CLog("세션에 output을 추가하지 못했습니다.")
            caputureSession.commitConfiguration()
            return
        }
        
        let captureConnection = streamingOutput.connection(with: .video)
        
        captureConnection?.isEnabled = true
        
        do {
            try captureDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((captureDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            
            let currentFrameRate:Int32 = 7
            captureDevice!.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: currentFrameRate)
            captureDevice!.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: currentFrameRate)
            
            captureDevice!.unlockForConfiguration()
        } catch {
            CLog(error.localizedDescription)
        }
        
        caputureSession.commitConfiguration()
        streamingLayer = AVCaptureVideoPreviewLayer(session: caputureSession)
        streamingLayer.videoGravity = .resizeAspectFill
        streamingLayer.backgroundColor = UIColor.black.cgColor
    }
    
    func startCaptureSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {return}
            self.caputureSession.startRunning()
        }
    }
    
    func stopCaptureSession() {
        self.caputureSession.stopRunning()
        self.detectionOverlay.sublayers = nil
    }
    
    func tearDownAVCaputure() {
        streamingLayer.removeFromSuperlayer()
        streamingLayer.sublayers = nil
    }
    
    //MARK: - change image to CVPixelBuffer
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else { return nil }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: image.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
    }
    
    //MARK: - setupObjectDetect
    
    func cropRect(_ boundingBox: CGRect, image: UIImage) -> UIImage {
        let imageRef = image.cgImage!.cropping(to: boundingBox)
        let newImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        return newImage
    }
    
    func drawVisionRequestResults(_ objectObservation: dogClassOutput,_ image: CVPixelBuffer) {
        guard let detectionOverlay = self.detectionOverlay else {return}
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil
        
        for (idx, confidence) in objectObservation.confidenceShapedArray.enumerated() {
                
            let confidence = confidence
            let coordinate = objectObservation.coordinatesShapedArray[idx]
                
            let maxClassIndex = confidence.scalars.enumerated().max{ $0.element < $1.element }!.offset
            let firstName = className[maxClassIndex]

            let digit: Float = pow(10.0, 2.0)
            let classConfidence = round(confidence[scalarAt: maxClassIndex] * 100 * digit)/digit
            let initBox = coordinate.scalars.map{CGFloat($0)}
            // 왼쪽, 윗 모서리 x / y / 너비 / 높이
            let rect = CGRect(x: (initBox[0] - (initBox[2]/2.0)), y: (initBox[1] - (initBox[3]/2.0)), width: initBox[2], height: initBox[3])
            let objectBounds = VNImageRectForNormalizedRect(rect, Int(bufferSize.width), Int(bufferSize.height))
            print(objectBounds)

            if Consts.consts.IS_DEBUG {
                let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
                let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                                    identifier: firstName,
                                                                    confidence: classConfidence
                                                                )
                shapeLayer.addSublayer(textLayer)
                detectionOverlay.addSublayer(shapeLayer)
            }
            self.updateLayerGeometry()
            
            
        }

        CATransaction.commit()
    }
    
    func updateLayerGeometry() {
        let bounds = self.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        guard let detectionOverlay = detectionOverlay else {return}
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: scale))
        
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()
    }
    
    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: Float) -> CATextLayer {
        
        let textLayer = CATextLayer()
        
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence: %2.f", confidence))
        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
 
        
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: 28)
        textLayer.position = CGPoint(x: bounds.minX, y: bounds.midY)
        textLayer.shadowOpacity = 0.3
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = UIColor.systemRed.cgColor
        textLayer.backgroundColor = UIColor.systemRed.cgColor
        textLayer.contentsScale = 2.0
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 2.0).scaledBy(x: -1.0, y: -1.0))
        
        return textLayer
    }
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.borderColor = UIColor.systemRed.cgColor
        shapeLayer.borderWidth = 1
        shapeLayer.cornerRadius = 7
        
        return shapeLayer
    }
    
    public func exifOrientationFromDeviceOrientation() -> UIImage.Orientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: UIImage.Orientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .up
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .up
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .up
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}



extension StreamingView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}

        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let image = UIImage(ciImage: ciImage, scale: 1.0, orientation: .right) //exifOrientationFromDeviceOrientation())

        UIGraphicsBeginImageContext(CGSize(width: 720, height: 720))
        image.draw(in: CGRect(x: 0, y: 0, width: 720, height: 720))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        let pixelBuffer = buffer(from: resizedImage)
        
        motionDetection.inqueue(image: resizedImage)
        
        guard let pixelBuffer = pixelBuffer else {return}
        self.pixelBuffer = pixelBuffer
    }
}
