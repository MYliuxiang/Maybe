//
//  DiaiogueAniVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/12/16.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class DiaiogueAniVC: BaseViewController {
    
    @IBOutlet weak var voiceBtn: LxDragButton!
    lazy var videoPreImg:UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        return img
    }()
    
    @IBOutlet weak var voiceTipL: UILabel!
    var movie: GPUImageMovie!
    var filter: GPUImageChromaKeyBlendFilter!
    var sourcePicture: GPUImagePicture!
    var vStitle:VideoTitlesAniView = VideoTitlesAniView()
    
    lazy var myCard:DiaioCarView = {
        let v = DiaioCarView(type: .MyCard)
        return v
    }()
    
    lazy var liLyCard:DiaioCarView = {
        let v = DiaioCarView(type: .LiLYCard)
        return v
    }()
    
    lazy var centerCard:DiaCenterView = {
        let v = DiaCenterView(alignment: .left)
        v.isHidden = true
        return v
    }()

    
    lazy var videoPlayer:LxPlayer = {
        let player = LxPlayer(containerView: videoPreImg)
        player.player?.containerView.layer.backgroundColor = UIColor.white.cgColor
        return player
    }()
    
    lazy var temperatureImg:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "温度计_热")
        img.isHidden = true
        return img
        
    }()
    
    lazy var temperatureLab:UILabel = {
        let lab = UILabel()
        lab.font = .customName("Black", size: 48)
        lab.textColor = .colorWithHexStr("#0EABFF")
        lab.text = "12°"
        lab.isHidden = true
        return lab
        
    }()
    
    var uploader:StreamPost?
    var pcmRecoder:MbRecorder?
    var cancleItem:DispatchWorkItem?

    
    
    
    @IBOutlet weak var voiceStateI: UIImageView!
    @IBOutlet weak var frontI: JHAnimatedImageView!
    @IBOutlet weak var backI: UIImageView!
    
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var backTopI: JHAnimatedImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navBar.isHidden = true
        bottomView.isHidden = true
        
        navBar.wr_setBackgroundAlpha(0)
        bottomView.backgroundColor = .clear
       
        playerPlay()
        creatUI()
        
        vStitle.isHidden = false
                
        myCard.contentStr = "How's the weather today?"
        liLyCard.contentStr = "Jīntiān you dàyu, qìwēn shíwu dù."

       
    
        
    }
    
    func creatUI(){
        
        self.voiceBtn.layer.cornerRadius = 32
        self.voiceBtn.layer.masksToBounds = true
        
        view.addSubview(temperatureImg)
        view.addSubview(temperatureLab)
        temperatureImg.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.centerX).offset(65)
            make.bottom.equalTo(self.view.snp.centerY).offset(-130)
        }
        
        temperatureLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.temperatureImg.snp.right).offset(5)
            make.top.equalTo(self.temperatureImg.snp.top)
        }
        
        
        
        view.addSubview(vStitle)
        vStitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.centerY.equalTo(self.view.snp.centerY).offset(-76)

        }
        
        view.addSubview(centerCard)
        view.addSubview(liLyCard)
        view.addSubview(myCard)
        
        centerCard.snp.makeConstraints { (make) in
//            make.right.left.greaterThanOrEqualToSuperview().inset(20)
            make.centerY.equalTo(self.view.snp.centerY).offset(-76)
            make.left.equalToSuperview().offset(20)
            make.right.lessThanOrEqualToSuperview().offset(20)
//            make.centerX.equalToSuperview()
        }
        
        
        liLyCard.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.bottom.equalTo(self.voiceBtn.snp.top).offset(-70)

        }
        myCard.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(self.liLyCard.snp.top).offset(-36)

        }
        
        
        myCard.isHidden = true
        liLyCard.isHidden = true
        
        voiceTipL.shadowColor = UIColor.white
        voiceTipL.shadowOffset = CGSize(width: 1, height: 1)
        
                
        backI.image = UIImage(named: "下雨")
        backTopI.image = UIImage(named: "cloud003.png")
        frontI.image = UIImage(named: "rain003.png")
        backTopI.removeWhenFinished = false
        frontI.removeWhenFinished = false

        var imagpaths = [String]()
        for idx in 3...95 {
            
            let imageName = String(format: "cloud0%.2d.png", idx)
            let path = Bundle.main.path(forResource: imageName, ofType: nil)
            imagpaths.append(path!)

        }
        backTopI.animationImagePaths = imagpaths
        backTopI.animationDuration = 4.0
        backTopI.animationRepeatCount = 0
        
        var fimagPaths = [String]()
        for idx in 3...95 {
            let imageName = String(format: "rain0%.2d.png", idx)
            let path = Bundle.main.path(forResource: imageName, ofType: nil)

//            let image = UIImage(named: imageName)!
//            let image =  UIImage(contentsOfFile: path!)!
            fimagPaths.append(path ?? "")
        }
        frontI.animationImagePaths = fimagPaths
        frontI.animationDuration = 4.0
        frontI.animationRepeatCount = 0
        
                
        
    }
    
    
    /// 按下
    @IBAction func voiceTouchDown(_ sender: Any) {
        self.voiceTipL.isHidden = false
        self.voiceTipL.text = "Please speak"
        self.voiceStateI.isHidden = false
//        self.voiceStateI.image = UIImage(named: "555")
        swichImage(image: UIImage(named: "555")!)

        
        self.vStitle.isHidden = true
        self.centerCard.isHidden = true
        self.myCard.isHidden = true
        self.liLyCard.isHidden = true
        
        let suburl = "/skills"
        self.uploader = StreamPost(suburl,subUrl: suburl)
        self.uploader?.completion = {[weak self](result,created_on) in
            guard let self = self else { return }
            switch result {
            case .success(let dic):
                guard let data = dic["data"] as? [String:Any] else{return}
                let interimResults = data["interimResults"] as? Bool
                if interimResults ?? false {
                    //中间结果
                    guard let text = data["text"] as? String else{return}
                    print("----")
                    self.centerCard.isHidden = false
                    self.centerCard.contentStr = text
                    
                    return
                }
                
                //                            guard let models = [GPUModel].deserialize(from: data["lists"] as? NSArray) else {return}
                //                            self.cancleItem?.cancel()
                //                            self.dataList = models as? [GPUModel]
                //                            self.isWait = false
                self.centerCard.isHidden = true

                
                break
            case .failure(_):
                self.centerCard.isHidden = true
                self.cancleItem?.cancel()
                self.pcmRecoder?.stopRecored()
                self.navigationController?.popViewController(animated: true)
                break
            }
            
        }
        
        
                    LXAsync.asyncDelay(0.1) {
                        let timeStamp = Date().timeStamp
                        self.pcmRecoder = MbRecorder(timeStamp)
                        self.pcmRecoder?.startRecored()
                        var isfinshed = false
                        self.pcmRecoder?.callback = {[weak self](pcmData) in
                            guard let self = self else { return }
                            if !isfinshed{
                                if pcmData.count != 0{
                                    self.uploader?.uploadData(pcmData)
                                }else{
                                    self.uploader?.endUpload()
                                    isfinshed = true
                                }
                            }
                        }
        
                        self.uploader?.serverStop = { [weak self] in
                            self?.pcmRecoder?.stopRecored()
                        }
                    }
        
                   
        
    }
    
    
    ///结束录音
    @IBAction func voiceTouchUpInside(_ sender: Any) {
        endUIRecord()
        
        self.pcmRecoder?.stopRecored()
        self.uploader?.endUpload()
        

//        LXAsync.delay(1) {
//            self.vStitle.isHidden = false
////            self.vStitle.snp.remakeConstraints { (make) in
////                make.left.right.equalToSuperview().inset(40)
////                make.centerY.equalTo(self.view.snp.centerY).offset(-76)
////            }
//
//            self.vStitle.configAnimation(subtitles: ["Jīntiān","you","dàyu,","qìwēn","shíwu","dù."], totalTime: 3, isAni: true, backColor: .colorWithHexStr("#17E8CB"), defaultFont: .customName("Bold", size: 36), lineHeight: 56)
//            self.myCard.isHidden = false
//        }
//
//        LXAsync.delay(5) {
//
//
//            let pAni = CABasicAnimation(keyPath: "position")
//            pAni.duration = 0.4
//            pAni.fromValue = self.vStitle.layer.position
//            pAni.toValue = self.liLyCard.layer.position
//            pAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//
//            let bAni = CABasicAnimation(keyPath: "transform.scale.x")
//            bAni.duration = 0.4
////            bAni.fromValue = self.vStitle.layer.bounds
////            bAni.toValue = self.liLyCard.layer.bounds
//            bAni.fromValue = 1
//            bAni.toValue = 0.6
//            bAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//
//
//            let oAni = CABasicAnimation(keyPath: "opacity")
//            oAni.beginTime = 0.2
//            oAni.duration = 0.2
//            oAni.fromValue = 1.0
//            oAni.toValue = 0
//            oAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//
//            let aniGroup = CAAnimationGroup()
//            aniGroup.animations = [pAni,bAni,oAni]
//            aniGroup.delegate = self
//            aniGroup.duration = 0.4
//            aniGroup.isRemovedOnCompletion = false
//            aniGroup.fillMode = .forwards
//            self.vStitle.layer.add(aniGroup, forKey: "vStitle-Ani")
//
//            LXAsync.delay(0.3) {
//                let hAni = CATransition()
//                hAni.type = .fade
//                hAni.duration = 0.4
//                self.liLyCard.layer.add(hAni, forKey: "liLy-Ani")
//                self.liLyCard.isHidden = false
//            }
//
//
//        }
        
    }
    
    /// 取消录音
    @IBAction func voiceTouchUpOutside(_ sender: Any) {
        endUIRecord()
        self.uploader?.cancleLoad()
        self.pcmRecoder?.stopRecored()
       
    }
    
    
    /// 录音取消
    @IBAction func voiceTouchCancel(_ sender: Any) {
        endUIRecord()
        self.uploader?.cancleLoad()
        self.pcmRecoder?.stopRecored()
        
    }
    
    func endUIRecord() {
        self.voiceTipL.isHidden = true
        self.voiceStateI.isHidden = true
        self.centerCard.isHidden = true
    }
    
    /// 进入点击区域
    @IBAction func voiceTouchDragEnter(_ sender: Any) {
        self.voiceTipL.isHidden = false
        self.voiceTipL.text = "Release to send, swipe up to cancel"
        self.voiceStateI.isHidden = false
        swichImage(image: UIImage(named: "555")!)

      
    }
    
    
    /// 离开点击区域
    @IBAction func voiceTouchDragExit(_ sender: Any) {
        
        self.voiceTipL.isHidden = false
        self.voiceTipL.text = "Release to cancel"
        self.voiceStateI.isHidden = false
//        self.voiceStateI.image = UIImage(named: "录音_红色效果")
        
        swichImage(image: UIImage(named: "录音_红色效果")!)
                
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPlayer.playerManger?.play()
        backTopI.startJHAnimating()
        frontI.startJHAnimating()
    }
    
    
    func swichImage(image:UIImage){
        
        
        let anim = CATransition()
        anim.duration = 0.35
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.type = .fade
        
        voiceStateI.layer.add(anim, forKey: "a")
        self.voiceStateI.image = image
               

    }
    
    
    
    
    func playerPlay(){
       
        self.videoView.fillMode = GPUImageFillModeType.init(kGPUImageFillModePreserveAspectRatioAndFill.rawValue)

        let videoPath = Bundle.main.path(forResource: "lily@level1_weather_rain_001(1).mp4", ofType: nil)
        let url = URL(fileURLWithPath: videoPath!)
                
        videoPlayer.playerManger?.assetURL = url
        videoPlayer.playerManger?.prepareToPlay()
//        videoPlayer.playerManger?.reloadPlayer()
        
       
      let playerItem = videoPlayer.playerManger?.playerItem

      let  filter = GPUImageChromaKeyBlendFilter()
        filter.thresholdSensitivity = 0.4
        filter.smoothing = 0.1
        filter.setColorToReplaceRed(0, green: 1, blue: 0)

        movie = GPUImageMovie(playerItem: playerItem)
        movie.playAtActualSpeed = true
        movie.addTarget(filter)
        movie.startProcessing()

        let backgroundImage = UIImage(named: "transparent.png")
        sourcePicture = GPUImagePicture(image: backgroundImage, smoothlyScaleOutput: true)!
        sourcePicture.addTarget(filter)
        sourcePicture.processImage()
        filter.addTarget(self.videoView)

        //设置时间回调的间隔
        videoPlayer.playerManger?.timeRefreshInterval = 0.001
        
        videoPlayer.playerManger?.playerPlayTimeChanged = {[weak self](asset, currentTime, duration) in
            
          
        }
        //播放完成回调
        videoPlayer.playerManger?.playerDidToEnd = {(asset) in
            self.videoPlayer.playerManger?.reloadPlayer()
        }
        
    }
  
    
    @IBAction func dismissAC(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreAC(_ sender: Any) {
        let diaioListView = DiaioListView()
        diaioListView.pushBlock = { type in
            if type == 0 {
                self.navigationController?.pushViewController(BaseViewController(), animated: true)
            }else{
                
                let vc = DisplayModeVC(diaioListView.disPlayLab.text ?? "")
                vc.displayModeBlock = { mode in
                    diaioListView.disPlayLab.text = mode
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }
        diaioListView.present(in: view)
        
    }
    @IBAction func pushDiaioList(_ sender: Any) {
        
       
       

    }
    
    deinit {
        self.videoPlayer.playerManger?.stop()
        print("DetailVideoVC销毁了")
        movie.endProcessing()
    }
    
}


extension DiaiogueAniVC:CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
//        self.vStitle.layer.opacity = 1
        if flag {
            self.vStitle.isHidden = true
//            self.vStitle.layer.bounds = self.vStitle.layer.bounds
            self.vStitle.layer.position = self.vStitle.layer.position
            self.vStitle.layer.removeAllAnimations()

        }
    }
    
}


