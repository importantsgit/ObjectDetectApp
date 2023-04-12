//
//  StreamingView.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/11.
//

import UIKit
import SnapKit
import AVFoundation
import CoreML
import Vision

class Streaming1View: UIView {
    var bufferSize: CGSize = .zero
    var resizedImage: UIImage?
    
    private var caputureSession = AVCaptureSession()
    
    private let streamingOutput = AVCaptureVideoDataOutput()
    
    private var streamingLayer: AVCaptureVideoPreviewLayer! = nil
    
    private let streamingDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    private var detectionOverlay: CALayer! = nil
    
    private var requests = [VNRequest]() {
        didSet {
            print(requests)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCameraLiveView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Streaming1View {
    
    func setupLayer(){
        let rootLayer = self.layer
        streamingLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(streamingLayer)
        setupVision()
        setupdetectionOverlay()
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
    
    @discardableResult
    func setupVision() -> NSError? {
        let error: NSError! = nil
        
        guard let objectDetectionModelURL = Bundle.main.url(forResource: "dogClass", withExtension: "mlmodelc") else {
            return NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey:"Model file is missing"])
        }
        do {
            let visionModel1 = try VNCoreMLModel(for: MLModel(contentsOf: objectDetectionModelURL))
            let dogposeModel = try dogPose(configuration: MLModelConfiguration())
            
            let objectRecognition = VNCoreMLRequest(model: visionModel1, completionHandler: { [weak self] (request, error) in
                guard let results = request.results,
                      let self = self,
                      let resizedImage = self.resizedImage else {
                    return
                }
                self.detectionOverlay.sublayers = nil
                for observation in results where observation is VNRecognizedObjectObservation {
                    guard let objectObservation = observation as? VNRecognizedObjectObservation,
                          objectObservation.confidence > 0.70 else {
                        continue
                    }
                    let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(self.bufferSize.width), Int(self.bufferSize.height))
                    CLog("\(objectObservation.boundingBox)")
                    var image = self.cropRect(objectBounds, image: resizedImage)
                    
                    if let pixelBuffer = self.buffer(from: image),
                       let output = try? dogposeModel.prediction(image: pixelBuffer) {
                        DispatchQueue.main.async(execute: {
                            self.drawVisionRequestResults1(objectObservation, output.classLabel)
                        })
                    }
                }
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            CLog("Model loading went wrong: \(error)")
        }
        return error
    }
    
    func cropRect(_ boundingBox: CGRect, image: UIImage) -> UIImage {
        let imageRef = image.cgImage!.cropping(to: boundingBox)
        let newImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        return newImage
    }
    
    func drawVisionRequestResults1(_ objectObservation: VNRecognizedObjectObservation,_ classLabel: String) {
        guard let detectionOverlay = detectionOverlay else {return}
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
         // remove all the old recognized objects
        let topLabelObservation = objectObservation.labels[0]
            
        
        let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
        
        let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            
        let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence,
                                                            classLabel: classLabel)
        shapeLayer.addSublayer(textLayer)
        detectionOverlay.addSublayer(shapeLayer)
        
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        guard let detectionOverlay = detectionOverlay else {return}
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation,
                  objectObservation.confidence > 0.70 else {
                continue
            }
            let topLabelObservation = objectObservation.labels[0]
            
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            
            let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence,
                                                            classLabel: "")
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
        }
        self.updateLayerGeometry()
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
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()
    }
    
    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence, classLabel: String) -> CATextLayer {
        
        let textLayer = CATextLayer()
        
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence: %2.f \(classLabel)", confidence))
        let largeFont = UIFont(name: "Helvetica", size: 12.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
 
        
        textLayer.bounds = CGRect(x: 0, y: 0, width: self.bounds.width/2, height: 28)
        textLayer.position = CGPoint(x: bounds.minX, y: bounds.midY)
        textLayer.shadowOpacity = 0.3
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = UIColor.systemRed.cgColor
        textLayer.backgroundColor = UIColor.systemRed.cgColor
        textLayer.contentsScale = 2.0
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 2.0).scaledBy(x: 1.0, y: -1.0))
        
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
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

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
    
    private func setupCameraLiveView() {
        var deviceInput: AVCaptureDeviceInput!
        let captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            CLog("장치가 연결되지 않았습니다 : \(error)")
        }
        
        caputureSession.beginConfiguration()
        caputureSession.sessionPreset = .vga640x480
        
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
            
            let currentFrameRate:Int32 = 4
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
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}

extension Streaming1View: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}

        let ciImge = CIImage(cvPixelBuffer: imageBuffer)
        let image = UIImage(ciImage: ciImge)

        UIGraphicsBeginImageContext(CGSize(width: 640, height: 640))
        image.draw(in: CGRect(x: 0, y: 0, width: 640, height: 640))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.resizedImage = resizedImage
        
        let imageRequsetHanlder = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequsetHanlder.perform(self.requests)
        } catch {
            CLog("\((error))")
        }
    }
}

