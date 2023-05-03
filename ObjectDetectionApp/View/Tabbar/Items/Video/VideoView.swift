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
    
    var image1: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var image2: UIImageView = {
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
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resize
        
        setupLayout()
        

    }
    
    func setupLayout() {
        [imageView, image2].forEach{
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(160)
            $0.top.left.equalToSuperview().inset(16)
        }
        
        image2.snp.makeConstraints{
            $0.width.height.equalTo(160)
            $0.top.equalToSuperview()
            $0.left.equalTo(imageView.snp.right)
        }
    }
    
    //MARK: - setTimer
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: {[weak self] _ in
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
        self.playerLayer.player = nil
        self.player = nil
        let playerItem = AVPlayerItem(url: url)
        let otherPlayer = AVPlayer(playerItem: playerItem)
        self.player = otherPlayer
        self.playerLayer.player = player
        
        //FIXME: replaceCurrentItemWithPlayer 수정
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
            UIGraphicsBeginImageContext(CGSize(width: image.size.width , height: image.size.height))
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            self.motionDetection.inqueue(image: resizedImage)
        }
    }

    // 시간 관찰
    func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1.0, preferredTimescale: timeScale)
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .global(), using: { [weak self] time in
            guard let self = self else {return}
            self.getImage()
        })
    }
    
    // 이전에 등록된 시간 추가 혹은 시간 경계 관찰자를 취소
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
