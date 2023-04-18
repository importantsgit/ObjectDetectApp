//
//  VideoView.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/12.
//

import UIKit
import AVFoundation
import SnapKit

class VideoView: UIView {
    
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    var av = AVPlayerItemVideoOutput()
    var timeObserverToken: Any?
    
    var motionDetection = MotionDetectionManager()
    
    var timer: Timer?
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoView {
    func setupLayer() {
        self.backgroundColor = .black
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.frame
        playerLayer.videoGravity = .resizeAspectFill
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(160)
            $0.top.left.equalToSuperview()
        }
    }
    
    //MARK: - setTimer
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5 , repeats: true, block: {[weak self] _ in
            guard let self = self else {return}

            if Consts.consts.IS_DEBUG {
                if Consts.consts.IS_MOTIONDETECT {
                    guard let image = self.motionDetection.detectingImage() else {return}
                    self.imageView.image = image
                }
            }
        })
    }
    
    func stopRepeatTimer(){
        guard let timer = timer else { return }
        if timer.isValid { timer.invalidate() }
    }
    
    //MARK: - setPlayer
    func isReady() -> Bool {
        return self.playerLayer.player?.currentItem?.status == .readyToPlay
    }
    
    func play() {
        if self.playerLayer.player?.isPlaying != nil {
            self.playerLayer.player?.play()
            startTimer()
        }
    }
    
    func pause() {
        if self.playerLayer.player?.isPlaying != nil {
            self.playerLayer.player?.pause()
            stopRepeatTimer()
        }
    }
    
    func setURL(url: URL) {
        playerLayer.player == nil ? setPlayItem(url: url) : changePlayItem(url: url)
    }
    
    func setPlayItem(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.playerLayer.player = self.player
        av = AVPlayerItemVideoOutput(outputSettings: playerLayer.pixelBufferAttributes)
    }
    
    func changePlayItem(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        let otherPlayer = AVPlayer(playerItem: playerItem)
        self.player = nil
        self.player = otherPlayer
        self.playerLayer.player = nil
        self.playerLayer.player = self.player
    }
    
    func getImage() {
        guard let player = player,
              let asset = player.currentItem?.asset else { return }
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let times = [NSValue(time: player.currentTime())]
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: times) { [weak self] _, CGImage, _, _, _ in
            if let self = self,
               let cgImage = CGImage {
                let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
                UIGraphicsBeginImageContext(CGSize(width: 720, height: 720))
                image.draw(in: CGRect(x: 0, y: 0, width: 720, height: 720))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                self.motionDetection.inqueue(image: resizedImage)
            }
        }
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
