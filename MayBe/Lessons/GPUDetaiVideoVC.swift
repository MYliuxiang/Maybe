//
//  GPUDetaiVideoVC.swift
//  MayBe
//
//  Created by liuxiang on 2021/1/25.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit

class GPUDetaiVideoVC: BaseViewController {

    
   
    var movie: GPUImageMovie!
    var filter: GPUImageChromaKeyBlendFilter!
    var sourcePicture: GPUImagePicture!
    var player = AVPlayer()
  
    @IBOutlet weak var gpuImgView: GPUImageView!
    
    @IBOutlet weak var backImgV: UIImageView!
    
    
    lazy var carView:CardView = {
        let carV = CardView(frame: CGRect(x: 24, y: 0, width: ScreenWidth - 48, height: 100))
        carV.isHidden = true
        return carV
    }()
    
    
    lazy var videoPreImg:UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var answerStateI:UIImageView = {
        let anI = UIImageView(frame: CGRect(x: (ScreenWidth - 226 ) / 2, y: (ScreenHeight - 44 ) / 2, width: 226, height: 44))
        anI.isUserInteractionEnabled = true
        anI.backgroundColor = .red
        anI.isHidden = true
        return anI
    }()
    
   
    
    lazy var videoPlayer:LxPlayer = {
        let player = LxPlayer(containerView: videoPreImg)
        player.player?.containerView.layer.backgroundColor = UIColor.white.cgColor
        return player
    }()
    
    lazy var gtextboderL:GTextBoderProgress = {
        let gl = GTextBoderProgress()
        gl.isHidden = true
        return gl
    }()
        
  
    var showStatus = false
    
    public var smodel:LsessonsBModel!
    var dataList:[GPUModel]?
    var audioPlayer:AVAudioPlayer?
    var currentModel:GPUModel?
    var uploader:StreamPost?
    var pcmRecoder:MbRecorder?
    var vStitle:VideoTitlesAniView = VideoTitlesAniView()
    
    var waitList:[AniTime]? {
        didSet{
            
        }
    }
    
    
    var camerainList:[AniTime]?
    var currentWait:AniTime?
    var currentTeach:VAnimation?
    var currentAni:VAnimation?
    var cancleItem:DispatchWorkItem?
    var isWait = false //是否是等待动画
    var voiceEnd = false //循环动画接结尾动画语音是否结束
    var currentteachEndAni:VAnimation?
    var playend:Bool = false  //设置播放时间才做动画是否结束处理
    var logPath:URL?
    
    

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        creatUI()
        playerPlay()
        loadData()
        creatLogFile()
    }
    
    //打印日志
    func creatLogFile(){
        FileHelper.createFolder(name: "MayBeLog", baseUrl: FileHelper.getDocument())
        FileHelper.removeFolder(fileUrl: FileHelper.getDocument().appendingPathComponent("MayBeLog"))
        let timeStamp = Date().timeStamp
        self.logPath =  FileHelper.createFile(name: "\(timeStamp).txt", fileBaseUrl: FileHelper.getDocument().appendingPathComponent("MayBeLog"))
    }
    
    func write(data:Data){
        
        guard let logUrl = self.logPath else {
            return
        }
        do {
            let writeHan = try FileHandle(forWritingTo: logUrl)
            writeHan.seekToEndOfFile()
            writeHan.write(data)
            if #available(iOS 13.0, *) {
                try writeHan.close()
            } else {
                // Fallback on earlier versions
            }
        } catch (let erroe) {
            print(erroe)
        }
    }
    
    /// 请求数据
    func loadData(){
        
        
        let name = url_course + "1" + "/dialogs"
        
//        let name = "testViews"
        
        MBRequest(name, method: .get, bodyDict: nil, show: true, logError: true) { (result, code) in
            
            if code == 200{
                //请求成功
                guard let data = result?["data"] as? [String:Any] else{return }
                guard let models = [GPUModel].deserialize(from: data["lists"] as? NSArray) else {return}
                
                guard let wlist = [AniTime].deserialize(from: data["waitList"] as? NSArray )  else { return}
                
                guard let clist = [AniTime].deserialize(from: data["camerain"] as? NSArray )  else {return}
                                
                self.waitList = wlist as? [AniTime]
                self.camerainList = clist as? [AniTime]
                self.dataList = models as? [GPUModel]
                let model = self.dataList?.first
                self.playModel(model: model!)
//              self.videoPlayer.playerManger?.play()
            }
        }
        
    }
    
    func playModel(model:GPUModel?){
        
        
        guard let cmodel = model else {
            return
        }
        self.currentModel = cmodel
        self.answerStateI.isHidden = true

        if self.currentModel?.chatBox?.mode == "input" {
            carView.cofigwithBox(box: (self.currentModel?.chatBox)!,totalTime: 0.0)

            carView.startListenAnimation()
            self.currentModel = nil
            //开始播放等待动做
            //播放视频
            isWait = true
            self.currentWait = self.waitList?.first
            
            let logStr = "id:\(self.currentWait?.id ?? ""),begin：\(self.currentWait?.offset ?? ""),end:\(self.currentWait?.endset ?? "") \n"
            self.write(data: logStr.data(using: .utf8)!)
            
            self.seekTimeAndPlayer(time: self.currentWait?.offset)

            let suburl = url_course + "1" + "/dialogs"
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
                        guard let errIdx = data["errIdx"] as? [Int] else {return}
    //                    self.answerIngView.showAnser(anser: text,arrIdx: errIdx)
                        
                        self.carView.answerStr = text
                        
                        return
                    }
                    
                    guard let models = [GPUModel].deserialize(from: data["lists"] as? NSArray) else {return}
                    self.cancleItem?.cancel()
                    self.dataList = models as? [GPUModel]
                    self.isWait = false
                   

                    break
                case .failure(_):
                    self.cancleItem?.cancel()
                    self.isWait = false
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
            
            self.cancleItem =  LXAsync.asyncDelay(10.0) { [weak self] in
                self?.pcmRecoder?.stopRecored()
                self?.uploader?.endUpload()
            }
            
        }else{
            
            //判断是否是teching动画
            if cmodel.animation?.split == 6{
                if let anis = cmodel.animation?.teachingAni {
                    self.currentAni = anis.first
                    self.currentTeach = anis.first
                    let logStr = "id:\(self.currentAni?.id ?? ""),begin：\(self.currentAni?.begin ?? ""),end:\(self.currentAni?.end ?? "") \n"
                    self.write(data: logStr.data(using: .utf8)!)
                    self.seekTimeAndPlayer(time: self.currentTeach?.begin)
                }
               
            }else{
                self.currentAni = cmodel.animation
                let logStr = "id:\(self.currentAni?.id ?? ""),begin：\(self.currentAni?.begin ?? ""),end:\(self.currentAni?.end ?? "") \n"
                self.write(data: logStr.data(using: .utf8)!)
                self.seekTimeAndPlayer(time: cmodel.animation?.begin)

            }
            
            
            let timeInterval = TimeInterval(self.currentAni?.begin?.conversionMillisecond() ?? 0.0)
            print("====动画开始时间\(timeInterval)")
            
            //播放录音数据
            guard let speechData = cmodel.speech,speechData.count != 0 else {
                playModelFail()
                return
            }
            let base64Data = Data(base64Encoded: speechData)
            let timeStamp = Date().timeStamp
    //        let fileName = "/\(timeStamp).mp3"
    //        let url = FileHelper.getTemp(file: fileName)
    //        do {
    //            try base64Data?.write(to: url)
    //        } catch{}
    //
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            }catch{}
            
            do {
                            
                self.audioPlayer = try AVAudioPlayer.init(data: base64Data!)
                self.audioPlayer?.delegate = self;
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.play()
                
                carView.cofigwithBox(box: (self.currentModel?.chatBox)!,totalTime: self.audioPlayer!.duration)
                gtextboderL.isHidden = false
                gtextboderL.configAnimation(text:(self.currentModel?.chatBox?.zh)! , totalTime: self.audioPlayer!.duration)

                if cmodel.promptBox?.mode?.count == 0{
                    if cmodel.chatBox?.en?.count != 0{
                        carView.startAnimation()
                    }
                }else{
                    
                    self.answerStateAnimation(proptBox: cmodel.promptBox!)
                }
                
                
            } catch {
                //初始化失败
                playModelFail()
            }
        }
        
                
       
        
    }
    
    
    
    /// 播放下一天animation：1没有语音数据，2，语音播放完成
    /// - Parameter model:
    func playModelFail(){
        
        if self.currentModel?.end == true {
            navigationController?.popViewController(animated: true)
        }
        self.dataList?.remove(at: 0)
        guard let model = self.dataList?.first else {
//            self.playNextLoad()
            return
        }
        self.playModel(model: model);
    }
    
    func playNext(){
        
        if self.currentModel?.end == true {
            navigationController?.popViewController(animated: true)
            return
        }
        self.videoPlayer.playerManger?.pause()
        self.dataList?.remove(at: 0)
        guard let model = self.dataList?.first else {
            //上传语音数据
//            self.playNextLoad()
            return
        }
        self.playModel(model: model);
    }
    
   
  
    @objc func cancleRecored(){
        if self.audioPlayer != nil {
            self.audioPlayer?.stop()
        }
    }
    
    
   
  
    func playerPlay(){
        
        self.gpuImgView.fillMode = GPUImageFillModeType.init(kGPUImageFillModePreserveAspectRatioAndFill.rawValue)

        let videoPath = Bundle.main.path(forResource: "lily@level1_lesson1_animation.mp4", ofType: nil)
        let url = URL(fileURLWithPath: videoPath!)
                
        videoPlayer.playerManger?.assetURL = url
        videoPlayer.playerManger?.prepareToPlay()
        
       
//      let playerItem = videoPlayer.playerManger?.playerItem
//
//      let  filter = GPUImageChromaKeyBlendFilter()
//        filter.thresholdSensitivity = 0.4
//        filter.smoothing = 0.1
//        filter.setColorToReplaceRed(0, green: 1, blue: 0)
//
//        movie = GPUImageMovie(playerItem: playerItem)
//        movie.playAtActualSpeed = true
//        movie.addTarget(filter)
//        movie.startProcessing()
//
//        let backgroundImage = UIImage(named: "transparent.png")
//        sourcePicture = GPUImagePicture(image: backgroundImage, smoothlyScaleOutput: true)!
//        sourcePicture.addTarget(filter)
//        sourcePicture.processImage()
//        filter.addTarget(self.gpuImgView)
//
        //设置时间回调的间隔
        videoPlayer.playerManger?.timeRefreshInterval = 0.001
        
        videoPlayer.playerManger?.playerPlayTimeChanged = {[weak self](asset, currentTime, duration) in
            if self?.isWait ?? false {
                //播放的是等待动画
                print("等待--视频当前时间\(currentTime)")
                let time = TimeInterval(self?.currentWait?.endset?.conversionMillisecond() ?? 0.0)
                if currentTime >= time{
                    self?.videoPlayer.playerManger?.pause()

                    var index:Int = 0
                    if var cindex =  self?.waitList?.firstIndex(where: {
                        $0.endset == self?.currentWait?.endset
                    }) {
                        cindex += 1
                        if cindex >= (self?.waitList!.count)!{
                            cindex = 0
                        }
                        index = cindex
                    }else{
                        index = 0
                    }
                    self?.currentWait = self?.waitList?[index]
                    
                    let logStr = "id:\(self?.currentWait?.id ?? ""),begin：\(self?.currentWait?.offset ?? ""),end:\(self?.currentWait?.endset ?? "") \n"
                    self?.write(data: logStr.data(using: .utf8)!)
                    
                    self?.seekTimeAndPlayer(time: self?.currentWait?.offset)
                }
            }else{
                if ((self?.dataList) == nil) {
                  return
                }
                print("教学--当前时间\(currentTime)")
                if ((self?.currentModel) == nil) {
                    //需要重复播放等待动画
                    //判断去播放的是第一等待动画。
//                    if self?.currentWait == self?.camerainList?.last {
//                        let time = TimeInterval(self?.currentWait?.endset?.conversionMillisecond() ?? 0.0)
//                        if currentTime >= time{
                            self?.videoPlayer.playerManger?.pause()
                            self?.playModel(model: self?.dataList?.first)
//                        }
//                    }
                    let time = TimeInterval(self?.currentWait?.endset?.conversionMillisecond() ?? 0.0)
                    if currentTime >= time{
//                        self?.currentWait = self?.camerainList?.last
//                        self?.seekTimeAndPlayer(time: self!.currentWait?.offset)
                        self?.videoPlayer.playerManger?.pause()
                        self?.playModel(model: self?.dataList?.first)
                    }
                    
                }else{
                    //语音播放完毕
                    if self!.voiceEnd {
                        let time = TimeInterval((self?.currentAni?.end?.conversionMillisecond() ?? 0.0))
                        if self?.playend == false {
                            return
                        }
                        if currentTime >= time {
                            //不需要播放结束动画
                            self?.videoPlayer.playerManger?.pause()
                            self?.playend = false

                            print("当前时间\(currentTime) ====结束时间\(time)")
                            if self?.currentAni?.finishAni == nil {
                                self?.videoPlayer.playerManger?.pause()
                                self?.playNext()
                                self?.voiceEnd = false
                                
                                
                                
                            }else{
                                
                                let begin = self?.currentAni?.finishAni?.begin
                                self?.currentAni = self?.currentAni?.finishAni
                                
                                let logStr = "id:\(self?.currentAni?.id ?? ""),begin：\(self?.currentAni?.begin ?? ""),end:\(self?.currentAni?.end ?? "") \n"
                                self?.write(data: logStr.data(using: .utf8)!)

                                 self?.seekTimeAndPlayer(time: begin)

                            }
                        }
                                               
                    }else{
                       
                        if self?.currentAni?.nextAni == nil {

                        }else{

                            let time = TimeInterval(self?.currentAni?.end?.conversionMillisecond() ?? 0.0)
                            if self?.playend == false {
                                return
                            }
                            if currentTime >= time{
                                print("当前时间\(currentTime) ====结束时间\(time)")
                                self?.playend = false
                                self?.videoPlayer.playerManger?.pause()
                                let begin = self!.currentAni?.nextAni?.begin
                                self?.currentAni = self?.currentAni?.nextAni
                                let logStr = "id:\(self?.currentAni?.id ?? ""),begin：\(self?.currentAni?.begin ?? ""),end:\(self?.currentAni?.end ?? "") \n"
                                self?.write(data: logStr.data(using: .utf8)!)
                                self?.seekTimeAndPlayer(time: begin)
                            }
                        }
                    }
                }
            }
        }
        //播放完成回调
        videoPlayer.playerManger?.playerDidToEnd = {(asset) in
            
        }
        
    }
    
    
    /// 设置video时间
    /// - Parameter time: 时间
    private func seekTimeAndPlayer(time:String?) {
        let timeInterval = TimeInterval(time?.conversionMillisecond() ?? 0.0)
        self.videoPlayer.playerManger?.seek(toTime: timeInterval, completionHandler: { (completion) in
            if completion {
                self.videoPlayer.playerManger?.play()
                self.playend = true
            }
        })
    }

    /// 放大缩小动画
    /// - Parameter isScale: isScale 是否放大
    func playerScaleAnimition(isScale:Bool = true){
        //缩放动画
        let scaleAnimation: CABasicAnimation = CABasicAnimation()
        //transform.scale.x:更详细的指出值得改变
        scaleAnimation.keyPath = "transform.scale"
        if isScale {
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.25
        }else{
            scaleAnimation.fromValue = 1.25
            scaleAnimation.toValue = 1.0
        }
        scaleAnimation.duration = 0.3
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        self.gpuImgView.layer.add(scaleAnimation, forKey: "false")
    }
    
    func answerStateAnimation(proptBox:PromptBox){
                
        self.answerStateI.isHidden = false
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        let value1 = ScreenWidth / 2 + 25
        let value2 = ScreenWidth / 2 - 25
        let value3 = ScreenWidth / 2 + 25
        let value4 = ScreenWidth / 2 - 25
        let value5 = ScreenWidth / 2
        
        animation.values = [value1,value2,value3,value4,value5];
        //重复次数 默认为1
        animation.repeatCount=1;
        //设置是否原路返回默认为不
        animation.autoreverses = false;
        //设置移动速度，越小越快
        animation.duration = 1;
        animation.isRemovedOnCompletion = true;
        animation.fillMode = CAMediaTimingFillMode.forwards;
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut),CAMediaTimingFunction(name: .easeInEaseOut),CAMediaTimingFunction(name: .easeInEaseOut),CAMediaTimingFunction(name: .easeInEaseOut)]
        answerStateI.layer.add(animation, forKey: animation.keyPath)
                
        
        carView.setNeedsUpdateConstraints()
        carView.lineView.isHidden = false
        carView.animationI.isHidden = true
        
        carView.anserReslutAni()

        UIView.animate(withDuration: 0.35) {
            self.carView.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self.carView.answerL.snp.bottom).offset(52)
                make.top.equalTo(self.answerStateI.snp.bottom).offset(80)
                make.left.right.equalToSuperview().inset(24)
            }
            self.carView.superview?.layoutIfNeeded()
        } completion: { (comple) in
        
        }
        
        
        

    }
            
    func backgroundAni(){
        
        let anim = CABasicAnimation(keyPath: "backgroundColor")
        anim.duration = 0.35
        anim.fromValue = UIColor.yellow.cgColor
        anim.toValue = UIColor.red.cgColor
        anim.isRemovedOnCompletion = false
        anim.fillMode = CAMediaTimingFillMode.both
        backImgV.layer.add(anim, forKey: "backgroundColor")
        
        
    }
    
    
    /// 创建UI
    private func creatUI(){
        
               
        navBar.wr_setBackgroundAlpha(0)
        bottomView.backgroundColor = .clear
        //视频预览
        view.insertSubview(videoPreImg, at: 1)
        videoPreImg.frame = CGRect(x: 0, y: 0, width: ScreenWidth , height: ScreenHeight)
        
        view.addSubview(carView)
        carView.snp.makeConstraints { (make) in
            make.bottom.equalTo(carView.englishQL.snp.bottom).offset(17)
            make.top.equalTo(self.view.snp.centerY)
            make.left.right.equalToSuperview().inset(24)
        }
        
        view.addSubview(answerStateI)
                
        answerStateI.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(226)
        }
        answerStateI.backgroundColor = .red
        answerStateI.isHidden = false
        view.addSubview(gtextboderL)
        gtextboderL.snp.makeConstraints { (make) in
            make.top.equalTo(answerStateI.snp.bottom).offset(11)
            make.left.right.equalToSuperview().inset(24)
        }

            
        
        gpuImgView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.25, 1.25, 0)

        
//        self.answerStateI.isHidden = false
//        let springAnimation = CASpringAnimation(keyPath: "position.x")
//        springAnimation.damping = 5         //阻尼系数 0 ~ 10
//        springAnimation.mass    = 1         //弹簧末端的质量 大于 0 质量越大弹性就越大
//        springAnimation.initialVelocity = 50 //速度
//        springAnimation.stiffness = 100;      //弹簧刚度系数 0 到 100 系数越大力就越大
//        springAnimation.fromValue =  answerStateI.layer.position.x - 30 //起始的位置
//        springAnimation.toValue   =  answerStateI.layer.position.x//结束位置
//        springAnimation.duration  =  springAnimation.settlingDuration //结束时间
//        answerStateI.layer.add(springAnimation, forKey: springAnimation.keyPath)
        
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.audioPlayer = nil
        self.audioPlayer?.delegate = nil
        self.pcmRecoder?.stopRecored()
        
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForegroundAC(){
        if self.audioPlayer != nil {
            self.audioPlayer?.play()
        }else{
            guard let model = self.dataList?.first else {
                //服务器数据播放完成
                return
            }
            self.playModel(model: model);
        }
    }
            
    
    deinit {
        self.uploader?.cancleLoad()
        self.videoPlayer.playerManger?.stop()
        print("DetailVideoVC销毁了")
//        movie.endProcessing()
    }
    

}

extension GPUDetaiVideoVC:AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        voiceEnd = true
    }
    
}
