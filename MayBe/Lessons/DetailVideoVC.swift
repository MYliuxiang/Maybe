//
//  DetailVideoVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/25.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class DetailVideoVC: BaseViewController {
    
    @IBOutlet weak var speakImg: UIImageView!
    
    lazy var videoPreImg:UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var aniNameL:UILabel = {
        let img = UILabel()
        img.font = .systemFont(ofSize: 16)
        img.textAlignment = .center
        img.textColor = .green
        return img
    }()
    
    lazy var videoPlayer:LxPlayer = {
        let player = LxPlayer(containerView: videoPreImg)
        player.player?.containerView.layer.backgroundColor = UIColor.white.cgColor
        return player
    }()
    lazy var answer:AnswerView = {
        let ans = AnswerView(frame: CGRect(x: 24, y: ScreenHeight, width: ScreenWidth - 48, height: 150))
        ans.alpha = 0
        return ans
    }()
    
    lazy var answerIngView:AnsweringView = {
        let ans = AnsweringView(frame: CGRect(x: 24, y: ScreenHeight, width: ScreenWidth - 48, height: 150))
        return ans
    }()
    
    lazy var finalAnswer:FinalAnswerView = {
        let ans = FinalAnswerView(frame: CGRect(x: 24, y: ScreenHeight, width: ScreenWidth - 48, height: 150))
        ans.alpha = 0
        return ans
    }()
    
    var showStatus = false
    
    public var smodel:LsessonsBModel!
    var dataList:[VideoAnimationModel]?
    var audioPlayer:AVAudioPlayer?
    var currentModel:VideoAnimationModel?
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
        MBRequest(name, method: .get, bodyDict: nil, show: true, logError: true) { (result, code) in
            
            if code == 200{
                //请求成功
                guard let data = result?["data"] as? [String:Any] else{return }
                guard let models = [VideoAnimationModel].deserialize(from: data["lists"] as? NSArray) else {return}
                
                guard let wlist = [AniTime].deserialize(from: data["waitList"] as? NSArray )  else { return}
                
                guard let clist = [AniTime].deserialize(from: data["camerain"] as? NSArray )  else {return}
                                
                self.waitList = wlist as? [AniTime]
                self.camerainList = clist as? [AniTime]
                self.dataList = models as? [VideoAnimationModel]
                let model = self.dataList?.first
                self.playModel(model: model!)
//                self.videoPlayer.playerManger?.play()
            }
        }
        
    }
    
    func playModel(model:VideoAnimationModel?){
        
        speakImg.stopAnimating()
        speakImg.isHidden = true
        
        guard let cmodel = model else {
            return
        }
        self.currentModel = cmodel
        //显示卡片
        if let actionCard = cmodel.actionCard{
            if actionCard.mode == "1" {
                answer.showAnswer(title: (cmodel.actionCard?.type ?? ""), subTitle: (cmodel.actionCard?.value ?? ""))
                answer.show()
                finalAnswer.dismiss()

                
            }else if actionCard.mode == "2"{
                answer.showAnswer(title: (cmodel.actionCard?.type ?? ""), subTitle: (cmodel.actionCard?.value ?? ""))
                answer.show()
//                finalAnswer.show()

            }else if actionCard.mode == "3"{
                answer.showAnswer(title: (cmodel.actionCard?.type ?? ""), subTitle: (cmodel.actionCard?.value ?? ""))
                answer.show()
                finalAnswer.dismiss()

            }else{
                answer.dismiss()
                finalAnswer.dismiss()

            }
        }
        
                
        //播放视频
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
        
        aniNameL.text = self.currentAni?.id
        
        let timeInterval = TimeInterval(self.currentAni?.begin?.conversionMillisecond() ?? 0.0)
        print("====动画开始时间\(timeInterval)")
        
        //播放录音数据
        guard let speechData = cmodel.speech,speechData.count != 0 else {
            playModelFail()
            return
        }
        let base64Data = Data(base64Encoded: speechData)
        let timeStamp = Date().timeStamp
        let fileName = "/\(timeStamp).mp3"
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
            
                
            //显示字幕信息
            let strArray = (cmodel.bodyText?.value ?? "").split(separator: " ").compactMap { "\($0)"}
            let beginTime = Double(cmodel.bodyText?.voiceBegin ?? 0) / 1000
            LXAsync.delay(beginTime) {
                var timeLenth:Double
                let voiceLen = Double(cmodel.bodyText?.voiceLen ?? 0) / 1000
                timeLenth = voiceLen == 0 ? self.audioPlayer!.duration : voiceLen
                if cmodel.bodyText?.model == "2" {
                    self.vStitle.anginAnimation(time: timeLenth)
                }else{
                    self.vStitle.configAnimation(subtitles: strArray, totalTime: timeLenth)
                }
            }
                       
            
        } catch {
            //初始化失败
            playModelFail()
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
            self.playNextLoad()
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
            self.playNextLoad()
            return
        }
        self.playModel(model: model);
    }
    
    //发送语音数据播放等待动画
    func playNextLoad(){
        
        speakImg.startAnimating()
        speakImg.isHidden = false
        self.currentModel = nil
        //开始播放等待动做
        //播放视频
        isWait = true
        self.currentWait = self.waitList?.first
        
        let logStr = "id:\(self.currentWait?.id ?? ""),begin：\(self.currentWait?.offset ?? ""),end:\(self.currentWait?.endset ?? "") \n"
        self.write(data: logStr.data(using: .utf8)!)
        
        self.seekTimeAndPlayer(time: self.currentWait?.offset)
        vStitle.configAnimation(subtitles: [], totalTime: 0.0)

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
                    self.answerIngView.showAnser(anser: text,arrIdx: errIdx)
                    return
                }
                
                guard let models = [VideoAnimationModel].deserialize(from: data["lists"] as? NSArray) else {return}
                if let str = self.answerIngView.fanswer, self.answerIngView.fanswer?.count != 0{
                    self.finalAnswer.configFinal(str, ferrIdx: self.answerIngView.ferrIdx)
                    self.finalAnswer.show()
                }
                self.cancleItem?.cancel()
                self.answerIngView.showAnser(anser: nil, arrIdx: [Int]())
                self.dataList = models as? [VideoAnimationModel]
                self.isWait = false
                break
            case .failure(_):
                self.cancleItem?.cancel()
                self.answer.dismiss()
                self.isWait = false
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
        
       
    }
    
  
    @objc func cancleRecored(){
        if self.audioPlayer != nil {
            self.audioPlayer?.stop()
        }
    }
        
  
    func playerPlay(){
        //获取播放路径
//        let videoPath = Bundle.main.path(forResource: "lily@level1_lesson1_animation.mp4", ofType: nil)
        
        let videoPath = Bundle.main.path(forResource: "测试课程1.mp4", ofType: nil)

        
        let url = URL(fileURLWithPath: videoPath!)
        videoPlayer.playerManger?.assetURL = url
        videoPlayer.playerManger?.prepareToPlay()
        //设置时间回调的间隔
        videoPlayer.playerManger?.timeRefreshInterval = 0.001
        videoPlayer.playerManger?.playerPlayTimeChanged = {[weak self](asset, currentTime, duration) in
            
            //设置显示界面进度
//            if ((self?.videoPlayer.player?.controlView.responds(to: #selector(ZFPlayerControlView.videoPlayer(_:currentTime:totalTime:)))) != nil) {
//                self?.videoPlayer.player?.controlView.videoPlayer?((self?.videoPlayer.player!)!, currentTime: currentTime, totalTime: duration)
//            }
            
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
                                
                                LLog("========")
                                
                                
                            }else{
                                
                                let begin = self?.currentAni?.finishAni?.begin
                                self?.currentAni = self?.currentAni?.finishAni
                                
                                let logStr = "id:\(self?.currentAni?.id ?? ""),begin：\(self?.currentAni?.begin ?? ""),end:\(self?.currentAni?.end ?? "") \n"
                                self?.write(data: logStr.data(using: .utf8)!)

                                 self?.seekTimeAndPlayer(time: begin)
                                self?.aniNameL.text = self?.currentAni?.id
                                print(self?.currentAni?.id)

                            }
                        }
                                               
                    }else{
                       
                        if self?.currentAni?.nextAni == nil {
//                            let time = TimeInterval(self?.currentAni?.end?.conversionMillisecond() ?? 0.0)
//                            if currentTime >= time{
//                                self?.videoPlayer.playerManger?.pause()
//                                self?.seekTimeAndPlayer(time: self!.currentAni?.begin)
//                            }
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
                                self?.aniNameL.text = self?.currentAni?.id
                                print(self?.currentAni?.id)
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
    
    /// 创建UI
    private func creatUI(){
        
        speakImg.isHidden = true
        var imags = [UIImage]()
        for idx in 0...167 {
            
            let imageName = String(format: "sound_00%.3d.png", idx)
            let image = UIImage(named: imageName)!
            speakImg.image = image
            imags.append(image)
        }
        speakImg.animationImages = imags
        speakImg.animationDuration = 6.0
        speakImg.animationRepeatCount = 0
        
        
        navBar.wr_setBackgroundAlpha(0)
        bottomView.backgroundColor = .clear
        //视频预览
        view.insertSubview(videoPreImg, at: 0)
        videoPreImg.frame = CGRect(x: 0, y: 0, width: ScreenWidth , height: ScreenHeight)
        //回答弹框
        
        view.addSubview(finalAnswer)
        finalAnswer.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view).offset(-114)
            make.width.equalTo(ScreenWidth - 48)
        }
        
        
        view.addSubview(answer)
        answer.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.finalAnswer.snp.top)
                .offset(-24)
            make.width.equalTo(ScreenWidth - 48)
        }
        
        view.insertSubview(answerIngView, belowSubview: speakImg)
        answerIngView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.answer.snp.bottom).offset(24)
            make.width.equalTo(ScreenWidth - 48)
            make.height.equalTo(200)
        }
        
            
              
        //字幕视图
        view.addSubview(vStitle)
        vStitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(self.view.snp.centerY).offset(-20)
        }
        
        
        view.addSubview(aniNameL)
        aniNameL.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(self.view.snp.centerY).offset(-200)
        }
        
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
        self.videoPlayer.player?.containerView.layer.add(scaleAnimation, forKey: "false")
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
    }
    

}

extension DetailVideoVC:AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        voiceEnd = true
    }
    
}
