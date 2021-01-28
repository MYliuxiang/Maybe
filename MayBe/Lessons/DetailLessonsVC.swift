//
//  DetailLessonsVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/7/9.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class DetailLessonsVC: BaseViewController {
    
    var dataList:[LessonsModel]?
    var player:AVAudioPlayer?
    var lrctimer: Timer?
    var currentModel:LessonsModel?
    var uploader:StreamPost?
    
    
    var afuplpader:LXPcmUploader?
    var pcmRecoder:MbRecorder?
    public var smodel:LsessonsBModel!
    
    
    @IBOutlet weak var ktvView: YYKtvView!
    
    @IBOutlet weak var animationL: UILabel!
    
    @IBOutlet weak var u3dContailI: UIImageView!
    
    
    
    var lines:[Line]! = [Line]()
    var labers:[UILabel]! = [UILabel]()
    var totalwidth:CGFloat! = 0
    var progerss:CGFloat! = 0
    
    var voice:Data?
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lrctimer!.invalidate()
        self.player = nil
        self.player?.delegate = nil
        self.pcmRecoder?.stopRecored()
        
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navBar.isHidden = true
        view.backgroundColor = .white
        
//        let uview = UnityGetGLView()
        
//        u3dContailI.addSubview(uview!)
//        uview?.snp.makeConstraints({ (make) in
//            make.edges.equalToSuperview()
//        })
        
        lrctimer = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(timeAC), userInfo: nil, repeats: true)
        lrctimer!.fire()
        
        
        
        //        requestRecordPermission()
        loadData();
        //        RunLoop.current.add(lrctimer!, forMode: .common)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancleRecored), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundAC), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
    }
    
    
    
    
    @objc func timeAC(){
        let list = TrcParser.trcPraser(trcStr: self.currentModel?.display?.trans ?? "")
        //        let list = TrcParser.trcPraser(trcStr: "[00:0.1]<190>明<190>天<190>可<190>能<190>会<190>下<190>雨<190>。<190>")
        let total:Float = Float(self.player?.duration ?? 0)
        let current:Float = Float(self.player?.currentTime ?? 0)
        var totalProgress:Float = 0
        for model in list {
            totalProgress += model.alltime!
        }
        
        var subPtime:Float = 0
        for model in list {
            if current > model.trctimeValue! {
                subPtime += ((current - model.trctimeValue!) > model.alltime! ? model.alltime:(current - model.trctimeValue!))!
            }
        }
        //        self.progerss = CGFloat(current / total)
        //        self.ktvView.progerss = self.progerss
        
        self.progerss = CGFloat(subPtime / totalProgress)
        self.ktvView.progerss = self.progerss
        
    }
    
    @IBAction func closeAC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func loadData(){
        let name = url_course + "1" + "/dialogs"
        MBRequest(name, method: .get, bodyDict: nil, show: true, logError: true) { (result, code) in
            if code == 200{
                //请求成功
                guard let data = result?["data"] as? [String:Any] else{
                    return
                }
                guard let models = [LessonsModel].deserialize(from: data["lists"] as? NSArray) else {
                    
                    return
                }
                self.dataList = models as? [LessonsModel]
                let model = self.dataList?.first
                
                let base64Data = Data(base64Encoded: (model?.speech)!)
                
                self.voice = base64Data
                self.playModel(model: model!)
            }
        }
        
    }
    
    func requestRecordPermission(){
        AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            if !allowed {
                let alert = UIAlertController(title: "您未打开麦克风权限", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "去设置", style: .default) { (alert) in
                    JumpHelper.jumpToSystemSeting()
                }
                let action1 = UIAlertAction(title: "取消", style: .cancel) { (alert) in
                }
                alert.addAction(action)
                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func playModel(model:LessonsModel?){
        
        guard let cmodel = model else {
            return
        }
        self.currentModel = cmodel
        
        if let animations = cmodel.animations{
            for animation in animations {
                
                let u3dModel = U3dAniModel()
                //                u3dModel.isSpeak = 0
                u3dModel.AniName = animation.aniName
                u3dModel.ModelName = animation.modeName
                
                let json = u3dModel.toJSONString()
                
                
                LXAsync.asyncDelay(Double(animation.t0!) / 1000.0) {
                    
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(animation.t0!) / 1000.0) {
//                    UnitySendMessage("iOSHolder", "PlayAniWithTransInfo","""
//{"modelConfig":
//                        {"ModelName":"\(animation.modeName ?? "")","AniName":"\(animation.aniName ?? "")","isSpeak":0},
//                    "LocalPos":{"x":0,"y":-3.95,"z":3.6579999923706056},
//                    "LocalRotation":{"x":0.0,"y":180.0,"z":0.0},
//                    "LocalScale":{"x":3.5,"y":3.5,"z":1.0}}
//""");
                }
            }
        }
        
        //显示文字display
        let list = TrcParser.trcPraser(trcStr: (self.currentModel?.display?.trans ?? ""))
        var text = ""
        for model in list {
            text += model.trc ?? ""
        }
        //        self.disPlayV.text = text
        //        self.ktvView.lrctext = self.currentModel?.display?.text
        //
        //        print("=======\(text)")
        
        self.ktvView.lrctext = text
        
        //        self.ktvView.lrctext = "Wǒ jiāo lǐ lì "
        
        //        self.progerss = 0
        //        self.ktvView.progerss = 0
        
        
        var aniStr:String! = "";
        for ani in cmodel.animations! {
            aniStr.append((ani.aniName ?? ""))
        }
        //        self.animationL.text = aniStr
        
        //显示content
        if let content = self.currentModel?.content{
            MBProgressHUD.showError(content, to: keywindow)
        }
        
        guard let speechData = cmodel.speech else {
            //初始化失败
            self.dataList?.remove(at: 0)
            guard let model = self.dataList?.first else {
                //                playNextLoad()
                
                LXAsync.delay(0.1) {
                    self.playNextLoad()
                }
                
              
                return
            }
            self.playModel(model: model);
            lrctimer!.fireDate = Date.distantFuture
            
            return
        }
        if speechData.count == 0{
            self.dataList?.remove(at: 0)
            guard let model = self.dataList?.first else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playNextLoad()
                    
                }
                return
            }
            self.playModel(model: model);
            return
        }
        
        let base64Data = Data(base64Encoded: speechData)
        let timeStamp = Date().timeStamp
        
        let fileName = "/\(timeStamp).mp3"
        let url = FileHelper.getTemp(file: fileName)
        
        
        do {
            try base64Data?.write(to: url)
        } catch {
            //写入失败
        }
        do {
            
            //            do {
            //                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            //                try AVAudioSession.sharedInstance().setActive(true)
            //
            //            } catch _ {
            //
            //            }
            
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
                
                //                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
                
                //                try AVAudioSession.sharedInstance().setActive(true)
                
            } catch _ {}
            
            
            
            //            self.player = nil
            self.player = try AVAudioPlayer.init(data: base64Data!)
            self.player?.delegate = self;
            self.player?.prepareToPlay()
            self.player?.play()
//            UnitySendMessage("iOSHolder","StartSpeakAni","lily");
            
            //            lrctimer!.fireDate = NSDate.init() as Date
            //            lrctimer!.fire()
            //继续
            //            lrctimer!.fireDate = NSDate.init() as Date
            //            lrctimer!.fireDate = Date.distantPast
            
        } catch {
            
            //初始化失败
            self.dataList?.remove(at: 0)
            guard let model = self.dataList?.first else {
                //                playNextLoad()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playNextLoad()
                    
                }
                return
            }
            self.playModel(model: model);
            //            lrctimer!.fireDate = Date.distantFuture
            
        }
        
    }
    
    //已经播放完所有的model动画
    func playNextLoad(){
        //服务器数据播放完成
        guard !(self.currentModel?.end ?? false) else {
            
            return
        }
        
        let suburl = url_course + "1" + "/dialogs"
        
        
        self.afuplpader = LXPcmUploader(suburl)
        self.afuplpader?.completion = {[weak self](result) in
            
        }
        
        //        self.uploader = StreamPost(suburl,subUrl: suburl)
        //        self.uploader?.completion = {[weak self](result,created_on) in
        //
        //            guard let self = self else { return }
        //            switch result {
        //            case .success(let dic):
        //
        //                guard let data = dic["data"] as? [String:Any] else{
        //                    return
        //                }
        //
        //                let interimResults = data["interimResults"] as? Bool
        //                if interimResults ?? false {
        //                    //中间结果
        //                    guard let text = data["text"] as? String else{
        //                        return
        //                    }
        //                    self.ktvView.lrctext = text
        //                    return
        //                }
        //
        //                guard let models = [LessonsModel].deserialize(from: data["lists"] as? NSArray) else {
        //
        //                    return
        //                }
        //
        //                self.dataList = models as? [LessonsModel]
        //                let model = self.dataList?.first
        //                self.playModel(model: model!)
        //
        //                break
        //            case .failure(_):
        //
        //                break
        //            }
        //
        //        }
        
        
        
        weak var weakSelf = self
        
        let queue = DispatchQueue.global()
        //        queue.async {
        do {
            //                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.none)
            //                try AVAudioSession.sharedInstance().setActive(true)
            
            
        } catch _ {
            
        }
        
//        let timeStamp = Date().timeStamp
        
        let timeStamp = "333"

        
        self.pcmRecoder = MbRecorder(timeStamp)
        self.pcmRecoder?.startRecored()
        var isfinshed = false
        
        self.pcmRecoder?.callback = {[weak self](pcmData) in
            guard let self = self else { return }
            if !isfinshed{
                if pcmData.count != 0{
                    self.afuplpader?.uploadData(pcmData)
                }else{
                    self.afuplpader?.endUpload()
                    isfinshed = true
                }
            }
        }
        
        //        }
        
        self.uploader?.serverStop = {
            weakSelf?.pcmRecoder?.stopRecored()
            
            do {
                //                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                //                try AVAudioSession.sharedInstance().setActive(true)
                
            } catch _ {
                
            }
            
            
        }
        
        //        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
        //            DispatchQueue.main.async {
        //                weakSelf?.pcmRecoder?.stopRecored()
        //                weakSelf?.afuplpader?.endUpload()
        //            }
        //        }
    }    
    deinit {
    }
    
    @objc func cancleRecored(){
        if self.player != nil {
            self.player?.stop()
//            UnitySendMessage("iOSHolder","StopSpeakAni","lily");
        }
    }
    
    @objc func willEnterForegroundAC(){
        if self.player != nil {
            self.player?.play()
//            UnitySendMessage("iOSHolder","StartSpeakAni","lily");
        }else{
            guard let model = self.dataList?.first else {
                //服务器数据播放完成
                return
            }
            self.playModel(model: model);
        }
    }
    
}

extension DetailLessonsVC:AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
//        UnitySendMessage("iOSHolder","StopSpeakAni","lily");
        self.dataList?.remove(at: 0)
        guard let model = self.dataList?.first else {
            //服务器数据播放完成
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playNextLoad()
                
            }
            
            return
        }
        self.playModel(model: model);
        //        lrctimer!.fireDate = Date.distantFuture
        
    }
    
}


