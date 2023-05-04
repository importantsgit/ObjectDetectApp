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

class MotionDetectionView: UIView {
    var motionDetection: MotionDetectionManager?
    
    private var caputureSession = AVCaptureSession()
    
    var bufferSize: CGSize = .zero

    private let streamingOutput = AVCaptureVideoDataOutput()
    
    private var streamingLayer: AVCaptureVideoPreviewLayer! = nil
    
    private let streamingDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    private var detectionOverlay: CALayer! = nil
    
    var timer: Timer?
        
    var pixelBuffer: CVPixelBuffer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCameraLiveView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCameraLiveView()
    }
}

extension MotionDetectionView {
    
    //MARK: - setupLayout
    func setupLayer(){
        let rootLayer = self.layer
        streamingLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(streamingLayer)
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
    
    func startTimer() {
        motionDetection = MotionDetectionManager()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5 , repeats: true, block: {[weak self] _ in
            guard let self = self else {return}

            if let motionDetection = self.motionDetection {
                let rects = motionDetection.getDetectValue()
                print("==")
                if !rects.isEmpty {
                    self.detectionOverlay.sublayers = nil
                    rects.forEach{
                        CLog("\($0.cgRectValue.width), \($0.cgRectValue.height)")
                        self.drawMotion($0.cgRectValue)
                    }
                    print("==")
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
    
    func tearDownAVCapture() {
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
    
    func drawMotion(_ rect: CGRect){
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        let shapeLayer = self.createRoundedRectLayerWithBounds(rect)
        detectionOverlay.addSublayer(shapeLayer)
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
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: scale))
        
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()
    }
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.borderColor = UIColor.systemRed.cgColor
        shapeLayer.borderWidth = 4
        shapeLayer.cornerRadius = 7
        
        return shapeLayer
    }
}

extension MotionDetectionView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}

        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let image = UIImage(ciImage: ciImage, scale: 1.0, orientation: .up)

        var width: CGFloat = bufferSize.width
        var height: CGFloat = bufferSize.height

        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let pixelBuffer = buffer(from: resizedImage)
        

            guard let motionDetection = motionDetection,
                  let pixelBuffer = pixelBuffer  else {return}
        
            motionDetection.inqueue(image: resizedImage)
            self.pixelBuffer = pixelBuffer
        
    }
}
