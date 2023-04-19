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
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 4.0
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        
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
        
        [imageView].forEach{
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(160)
            $0.top.left.equalToSuperview().inset(16)
        }
    }
    
    //MARK: - setTimer
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.4, repeats: true, block: {[weak self] _ in
            guard let self = self else {return}

            if Consts.consts.IS_DEBUG {
                if Consts.consts.IS_MOTIONDETECT {
                    
//                    var arr = self.motionDetection.test()
//                    self.imageView.image = arr[0]
//                    self.imageView2.image = arr[1]
//                    self.imageView3.image = arr[2]
                    
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
            addPeriodicTimeObserver()
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
        stopRepeatTimer()
        removePeriodicTimeObserver()
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
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: times) { [weak self] _, cgImage, _, _, _ in
            guard let self = self,
                  let cgImage = cgImage else { return }
            let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
            UIGraphicsBeginImageContext(CGSize(width: image.size.width/2, height: image.size.height/2))
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width/2, height: image.size.height/2))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            self.motionDetection.inqueue(image: resizedImage)
        }
    }

    
    func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.8, preferredTimescale: timeScale)
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .global(), using: { [weak self] time in
            guard let self = self else {return}
            self.getImage()
        })
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
