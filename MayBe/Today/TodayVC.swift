//
//  TodayVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/4.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class TodayVC: BaseViewController {

    
    @IBOutlet weak var videoImg: UIImageView!
    var frames:[UIImage] = [UIImage]()
    private var generator:AVAssetImageGenerator!
    var imageIndex:Int = 0
    
    lazy var videoPlayer:LxPlayer = {
        let player = LxPlayer(containerView: videoImg)
        player.player?.containerView.layer.backgroundColor = UIColor.white.cgColor
        return player
    }()

    
    func getAllFrames() -> [UIImage] {
        
//        let videoPath = Bundle.main.path(forResource: "lily@level1_weather_sun_001.mov", ofType: nil)
        let videoPath = Bundle.main.path(forResource: "output.m4v", ofType: nil)

        let url = URL(fileURLWithPath: videoPath!)
        let asset:AVAsset = AVAsset(url:url)
        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        generator = AVAssetImageGenerator(asset:asset)
        self.generator.appliesPreferredTrackTransform = true
        self.frames = []
        for index:Int in 0 ..< Int(duration) {
            self.getFrame(fromTime:Float64(index))
        }
        self.generator = nil
        return self.frames
    }

    private func getFrame(fromTime:Float64) {
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale:600)
        let image:CGImage
        do {
           try image = self.generator.copyCGImage(at:time, actualTime:nil)
        } catch let error{
            print(error)
           return
        }
        self.frames.append(UIImage(cgImage:image))
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let label = YYLabel()
        label.text = "wo shi zh"
        label.frame = CGRect(x: 20, y: 100, width: 200, height: 100)
//        label.yy

//        label.sizeThatFits(CGSize(width: 200,height: 100))
        label.backgroundColor = .red
        view.addSubview(label)
        
       let frames = getAllFrames()
       videoImg.image = frames.first
        playerPlay()
        videoPlayer.playerManger?.play()
            
    }
    
    func playerPlay(){
       

        let videoPath = Bundle.main.path(forResource: "output.m4v", ofType: nil)
        let url = URL(fileURLWithPath: videoPath!)
                
        videoPlayer.playerManger?.assetURL = url
        videoPlayer.playerManger?.prepareToPlay()
             

        //设置时间回调的间隔
        videoPlayer.playerManger?.timeRefreshInterval = 0.001
        
        videoPlayer.playerManger?.playerPlayTimeChanged = {[weak self](asset, currentTime, duration) in
            
          
        }
        //播放完成回调
        videoPlayer.playerManger?.playerDidToEnd = {(asset) in
            
        }
        
    }
    
   
    @IBAction func u3dSetVC(_ sender: Any) {
        
        guard self.frames.count != 0 else {
            return
        }
        if imageIndex < self.frames.count {
            self.videoImg.image = self.frames[imageIndex]
            imageIndex += 1
        }else{
            imageIndex = 0
        }
        
        
//        navigationController?.pushViewController(SetU3dVC(), animated: true)
    }
    
    @IBAction func uploadRecord(_ sender: Any) {
        navigationController?.pushViewController(UpVoiceVC(), animated: true)

    }
}

