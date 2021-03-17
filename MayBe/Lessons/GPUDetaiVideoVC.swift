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
    var countimer:DispatchSourceTimer?
    

    @IBOutlet weak var leftV: UIView!
    @IBOutlet weak var leftBotomL: UILabel!
    @IBOutlet weak var rightV: UIView!
    @IBOutlet weak var rightBottomL: UILabel!
    @IBOutlet weak var rightCenterL: UILabel!
    @IBOutlet weak var gpuImgView: GPUImageView!
    @IBOutlet weak var backImgV: UIImageView!
    @IBOutlet weak var backMaskUpI: UIImageView!
    @IBOutlet weak var backMaskDownI: UIImageView!
    
    @IBOutlet weak var voiceI: UIImageView!
    
    @IBOutlet weak var voiceBg: UIImageView!
    
    
    //模拟用户说话的timer
    var moniTimer:DispatchSourceTimer?

    
    
    
    lazy var inputBV:UIView = {
        let label = UIView()
        label.backgroundColor = .white
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    lazy var inputBL:UILabel = {
        let label = UILabel()
        label.font = .customName("Medium", size: 14)
        label.textColor = .colorWithHexStr("#FFB90F")
        label.textAlignment = .center
        label.text = "Click on the card to answer immediately"
        return label
    }()
    
    lazy var inputBI:UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "编组 8")
        return label
    }()
    
    
    
    var vStitle:VideoTitlesAniView = VideoTitlesAniView()
    
    lazy var centerCard:InputCard = {
        let v = InputCard(alignment: .left, font: .customName("SemiBold", size: 24))
        v.isHidden = true
        return v
    }()

    
    lazy var inputTitleImage:UIImageView = {
        let img = UIImageView();
        img.contentMode = .center
        img.isHidden = true
        return img;
        
    }()
    
    lazy var subTitle:UILabel = {
        let label = UILabel()
        label.font = .customName("SemiBoldItalic", size: 24)
        label.textColor = .colorWithHexStr("#131616")
        label.textAlignment = .center
        return label
    }()
    
    lazy var carView:CardView = {
        let carV = CardView(frame: CGRect(x: 24, y: 0, width: ScreenWidth - 48, height: 200))
        carV.isHidden = true
        return carV
    }()
    
    lazy var videoPreImg:UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        return img
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
    
    lazy var answerStateI:UIImageView = {
        let anI = UIImageView()
        anI.isUserInteractionEnabled = true
        anI.isHidden = true
        return anI
    }()
    
    lazy var centerStateI:UIImageView = {
        let anI = UIImageView()
        anI.isUserInteractionEnabled = true
        anI.isHidden = true
        anI.image = UIImage(named: "You can say")
        return anI
    }()
        
  
    var showStatus = false
    
    public var smodel:LsessonsBModel!
    var dataList:[GPUModel]?
    var audioPlayer:AVAudioPlayer?
    var currentModel:GPUModel?
    var uploader:StreamPost?
    var pcmRecoder:MbRecorder?
    
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
        navBar.leftButton.left = navBar.leftButton.left + 16
        navBar.leftButton.top = navBar.leftButton.top + 10

        creatUI()
        playerPlay()
        loadData()
        creatLogFile()
        
        
        
        voiceI.image = UIImage(named: "动效00")
        
        var imags = [UIImage]()
        for idx in 0...74 {
            
            let imageName = String(format: "动效%.2d.png", idx)
            let image = UIImage(named: imageName)!
            imags.append(image)
        }
        voiceI.animationImages = imags
        voiceI.animationDuration = 4.0
        voiceI.animationRepeatCount = 0
               
        
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
        
        
//        let name = url_course + "1" + "/dialogs"
        
        let name = "testViews"
        MBRequest(name, method: .get, bodyDict: nil, show: true, logError: true) { (result, code) in
            
            if code == 200{
                //请求成功
                guard let data = result?["data"] as? [String:Any] else{return }
                guard let models = [GPUModel].deserialize(from: data["lists"] as? NSArray) else {return}
                
//                guard let wlist = [AniTime].deserialize(from: data["waitList"] as? NSArray )  else { return}
//
//                guard let clist = [AniTime].deserialize(from: data["camerain"] as? NSArray )  else {return}
                                
//                self.waitList = wlist as? [AniTime]
//                self.camerainList = clist as? [AniTime]
                self.dataList = models as? [GPUModel]
                let model = self.dataList?.first
                self.playModel(model: model!)
            }
        }
        
    }
    
    
    //重新设置语音player
    func reinitAudioPlayer(data:String?){
        
        
//        guard let speechData = data else {
//            playModelFail()
//            return
//        }
        let base64Data = Data(base64Encoded: data ?? "")

        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        }catch{}
        
        do {
            self.audioPlayer = try AVAudioPlayer.init(data: base64Data!)
            self.audioPlayer?.delegate = self;
            self.audioPlayer?.prepareToPlay()
            
        } catch {
            //初始化失败
//            playModelFail()
        }
        
        
    }
    
    
    
    func setSubtitleL(text:String, color:UIColor = .colorWithHexStr("#131616"),strokenWidth:CGFloat = -3,strokeColor:UIColor = .white){
        
        let attaStr = NSMutableAttributedString(string: text)
        attaStr.yy_font = .customName("SemiBoldItalic", size: 24)
        attaStr.yy_maximumLineHeight = 24
        attaStr.yy_minimumLineHeight = 28
        attaStr.yy_strokeWidth = -3
        attaStr.yy_strokeColor = .white
        attaStr.yy_color = .colorWithHexStr("#131616")
        attaStr.yy_alignment = .center
        subTitle.attributedText = attaStr
    }
    
    func playModel(model:GPUModel?){
        
        guard let cmodel = model else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.playend = false
        self.currentModel = cmodel

        self.currentAni = cmodel.video?.first
        

        self.videoPlayer.playerManger?.play()
        self.seekTimeAndPlayer(time: self.currentAni?.begin)
        
        //语音
        //播放录音数据
        reinitAudioPlayer(data: cmodel.audio?.first?.speech)
        let audioBeginTime = cmodel.audio?.first?.pos ?? 0.0
        if cmodel.audio != nil{
            LXAsync.delay(audioBeginTime) {[weak self] in
                self?.audioPlayer?.play()
            }
        }
       
        if cmodel.query?.sub?.value?.count != 0{
            
            self.vStitle.isHidden = false
            self.subTitle.isHidden = false
            //显示字幕信息
            let strArray = (cmodel.query?.top?.value ?? "").split(separator: " ").compactMap { "\($0)"}
            
            let isAni:Bool = cmodel.query?.top?.tclass == QTClass.Unfold
            self.vStitle.configAnimation(subtitles: strArray, totalTime: self.audioPlayer?.duration ?? 0,isAni: isAni)
            if cmodel.query?.sub?.tclass == QSTClass.None {
                setSubtitleL(text: cmodel.query?.sub?.value ?? "")

            }else{
                
                setSubtitleL(text: cmodel.query?.sub?.value ?? "",color: .colorWithHexStr("#17E8CB"),strokeColor: .colorWithHexStr("#131616"))

            }
        }else{
            self.vStitle.isHidden = true
            self.subTitle.isHidden = true
        }
      
        if cmodel.input?.iclass?.rawValue.count == 0 {
            centerCard.isHidden = true
            self.voiceI.isHidden = true
            self.voiceBg.isHidden = true
            self.voiceI.stopAnimating()

        }else if cmodel.input?.iclass == IClass.General {
            centerCard.isHidden = false
            centerCard.contentStr = "Wo jiao Lily. Ni jiao shen me mingzi？"
            self.voiceI.isHidden = true
            self.voiceBg.isHidden = true
            self.voiceI.stopAnimating()

           
        }else{
            
            if cmodel.input?.title?.count == 0 {
//                voiceI.isHidden = false
            }else{
//                self.centerStateI.isHidden = false
//                LXAsync.delay(1) {
                    
                self.voiceI.isHidden = false
                self.voiceBg.isHidden = false
                self.voiceI.startAnimating()
                self.centerStateI.isHidden = true

//                }
                
                var count = 0
                
                let defaluts = ["Wo jiao","Lily. Ni","jiao shen me","mingzi？"]
                var strs:[String] = [String]()
                
                
                
                moniTimer = DispatchSource.makeTimerSource()

                moniTimer?.schedule(deadline: DispatchTime.now() + 1.5, repeating: 0.7)
                self.moniTimer?.setEventHandler(handler: { [self] in
                    DispatchQueue.main.sync {
                        // 回调 回到了主线程
                        centerCard.isHidden = false
                        strs.append(defaluts[count])
                        
                        centerCard.contentStr = strs.joined(separator: "")
                        
                        
                       
                        count += 1
                        if count > 3{
                            self.moniTimer?.cancel()
                        }
                    }
                })
                self.moniTimer?.resume()
                                
            }
           
          
           

//            if cmodel.input?.iclass == IClass.WrongAnswer || cmodel.input?.iclass == IClass.Congrats {
//                carView.anserReslutAni()
//            }else{
//                carView.answerResultI.isHidden = false
//                carView.clipsToBounds = false
//            }
        }

        backgroundAni(back: cmodel.background!)

        if cmodel.title?.tclass == TClass.unknown{
            //头部消失
            self.answerStateI.isHidden = true
//            self.gtextboderL.isHidden = true

//            carView.setNeedsUpdateConstraints()
//            carView.answerResultI.isHidden = true
//
//            UIView.animate(withDuration: 0.35) {
//                self.carView.snp.remakeConstraints { (make) in
//                    make.bottom.equalTo(self.carView.answerL.snp.bottom).offset(52)
//                    make.top.equalTo(self.view.snp.centerY)
//                    make.left.right.equalToSuperview().inset(24)
//                }
//                self.carView.superview?.layoutIfNeeded()
//            } completion: { (comple) in
//
//            }

        }else{
            //头部显示
            self.answerStateI.isHidden = false
            self.answerStateAnimation(title: cmodel.title!)
            var isAni:Bool = true
            if cmodel.title?.tclass == TClass.WrongAnswer || cmodel.title?.tclass == TClass.Congrats || cmodel.title?.tclass == TClass.WrongPronunciation{
                isAni = false
                //直接出现
            }

            
         
            if cmodel.input?.iclass == IClass.Congrats || cmodel.input?.iclass == IClass.SayCongrats {
                self.centerCard.resultI.image = UIImage(named: "路径 2")
                self.centerCard.resultI.isHidden = false
//                self.inputTitleImage.image = UIImage(named: "路径 2")
//                self.inputTitleImage.isHidden = false
               
            }else if cmodel.input?.iclass == IClass.WrongAnswer || cmodel.input?.iclass == IClass.SayWrong {
                //错误
                
                self.centerCard.resultI.image = UIImage(named: "形状结合")
                self.centerCard.resultI.isHidden = false
//                self.inputTitleImage.image = UIImage(named: "形状结合")
//                self.inputTitleImage.isHidden = false
               
            }else{
                
                return
            }

            self.centerCard.setNeedsUpdateConstraints()
//            self.inputTitleImage.setNeedsUpdateConstraints()
   

            UIView.animate(withDuration: 0.35) {
                self.centerCard.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
//                    make.width.equalTo(self.centerCard.contentL.snp.width).offset(32)
//                    make.left.right.lessThanOrEqualToSuperview().inset(20)

                    make.top.equalTo(self.answerStateI.snp.bottom).offset(80)
                    make.bottom.equalTo(self.centerCard.contentL.snp.bottom).offset(16)
                }
//                self.inputTitleImage.snp.remakeConstraints{ (make) in
//                    make.centerX.equalTo(self.inputTitle)
//                    make.centerY.equalTo(self.inputTitle).offset(50)
//
////                    make.center.equalToSuperview().offset(50)
//                    make.height.width.equalTo(121)
////
//                }
                self.centerCard.superview?.layoutIfNeeded()
//                self.inputTitleImage.superview?.layoutIfNeeded()
            } completion: { (comple) in

            }
            
         



        }

            
        
        return
        
      
        carView.maskBlock = { [weak self] in
            self?.inputBV.isHidden = true
        }
        
        if cmodel.input?.iclass?.rawValue.count == 0 {
            carView.endListenAnimation()
        }else if cmodel.input?.iclass == IClass.General {
            carView.endListen()
            carView.answerL.text = "bababa"
            carView.answerL.textColor = .colorWithHexStr("#131616");
        }else{
           
            carView.isHidden = false
            if cmodel.input?.iclass == IClass.Default {
                carView.startListenAnimation(placeholder: (cmodel.input?.placeholder)!,len: cmodel.input?.len ?? 0.0)
                carView.timerTL.text = cmodel.input?.content ?? ""
                inputBV.isHidden = false
            }else{
                carView.answerResultI.isHidden = false
            }
           

//            if cmodel.input?.iclass == IClass.WrongAnswer || cmodel.input?.iclass == IClass.Congrats {
//                carView.anserReslutAni()
//            }else{
//                carView.answerResultI.isHidden = false
//                carView.clipsToBounds = false
//            }
        }

        backgroundAni(back: cmodel.background!)

        if cmodel.title?.tclass == TClass.unknown{
            //头部消失
            self.answerStateI.isHidden = true
//            self.gtextboderL.isHidden = true

//            carView.setNeedsUpdateConstraints()
//            carView.answerResultI.isHidden = true
//
//            UIView.animate(withDuration: 0.35) {
//                self.carView.snp.remakeConstraints { (make) in
//                    make.bottom.equalTo(self.carView.answerL.snp.bottom).offset(52)
//                    make.top.equalTo(self.view.snp.centerY)
//                    make.left.right.equalToSuperview().inset(24)
//                }
//                self.carView.superview?.layoutIfNeeded()
//            } completion: { (comple) in
//
//            }

        }else{
            //头部显示
            self.answerStateI.isHidden = false
            self.answerStateAnimation(title: cmodel.title!)
            var isAni:Bool = true
            if cmodel.title?.tclass == TClass.WrongAnswer || cmodel.title?.tclass == TClass.Congrats || cmodel.title?.tclass == TClass.WrongPronunciation{
                isAni = false
                //直接出现
            }
//            gtextboderL.isHidden = false
//            gtextboderL.configAnimation(text: (cmodel.title?.sub?.value)!, totalTime: self.audioPlayer!.duration,isAni: isAni, normalColor: cmodel.title?.tclass?.getNormal() ?? UIColor.white ,borderColor: cmodel.title?.tclass?.getBorderColor() ?? UIColor.colorWithHexStr("#17E8CB"))
            
            carView.setNeedsUpdateConstraints()
            carView.answerResultI.isHidden = false
            carView.animationI.isHidden = true
            

            if cmodel.input?.iclass == IClass.Congrats || cmodel.input?.iclass == IClass.SayCongrats {
                carView.answerResultI.image = UIImage(named: "路径 2")
                carView.answerL.text = "bababa"
                carView.answerL.textColor = .colorWithHexStr("#131616");
            }else if cmodel.input?.iclass == IClass.WrongAnswer || cmodel.input?.iclass == IClass.SayWrong {
                //错误
                carView.answerResultI.image = UIImage(named: "形状结合")
                carView.answerL.text = "bababa"
                carView.answerL.textColor = .colorWithHexStr("#131616");
            }else{
                
                return
            }

            UIView.animate(withDuration: 0.35) {
                self.carView.snp.remakeConstraints { (make) in
//                    make.top.equalTo(self.view.snp.centerY)
                    make.left.right.equalToSuperview().inset(24)
                    make.top.equalTo(self.answerStateI.snp.bottom).offset(24)
                    make.height.equalTo(181)
                }
                self.carView.superview?.layoutIfNeeded()
            } completion: { (comple) in

            }



        }

        
        return
        
        

//        if self.currentModel?.chatBox?.mode == "input" {
//            carView.cofigwithBox(box: (self.currentModel?.chatBox)!,totalTime: 0.0)
//
//            carView.startListenAnimation()
//            self.currentModel = nil
//            //开始播放等待动做
//            //播放视频
//            isWait = true
//            self.currentWait = self.waitList?.first
//
//            let logStr = "id:\(self.currentWait?.id ?? ""),begin：\(self.currentWait?.offset ?? ""),end:\(self.currentWait?.endset ?? "") \n"
//            self.write(data: logStr.data(using: .utf8)!)
//
//            self.seekTimeAndPlayer(time: self.currentWait?.offset)
//
//            let suburl = url_course + "1" + "/dialogs"
//            self.uploader = StreamPost(suburl,subUrl: suburl)
//            self.uploader?.completion = {[weak self](result,created_on) in
//                guard let self = self else { return }
//                switch result {
//                case .success(let dic):
//                    guard let data = dic["data"] as? [String:Any] else{return}
//                    let interimResults = data["interimResults"] as? Bool
//                    if interimResults ?? false {
//                        //中间结果
//                        guard let text = data["text"] as? String else{return}
//                        guard let errIdx = data["errIdx"] as? [Int] else {return}
//    //                    self.answerIngView.showAnser(anser: text,arrIdx: errIdx)
//
//                        self.carView.answerStr = text
//
//                        return
//                    }
//
//                    guard let models = [GPUModel].deserialize(from: data["lists"] as? NSArray) else {return}
//                    self.cancleItem?.cancel()
//                    self.dataList = models as? [GPUModel]
//                    self.isWait = false
//
//
//                    break
//                case .failure(_):
//                    self.cancleItem?.cancel()
//                    self.isWait = false
//                    self.pcmRecoder?.stopRecored()
//                    self.navigationController?.popViewController(animated: true)
//                    break
//                }
//
//            }
//
//
//            LXAsync.asyncDelay(0.1) {
//                let timeStamp = Date().timeStamp
//                self.pcmRecoder = MbRecorder(timeStamp)
//                self.pcmRecoder?.startRecored()
//                var isfinshed = false
//                self.pcmRecoder?.callback = {[weak self](pcmData) in
//                    guard let self = self else { return }
//                    if !isfinshed{
//                        if pcmData.count != 0{
//                            self.uploader?.uploadData(pcmData)
//                        }else{
//                            self.uploader?.endUpload()
//                            isfinshed = true
//                        }
//                    }
//                }
//
//                self.uploader?.serverStop = { [weak self] in
//                    self?.pcmRecoder?.stopRecored()
//                }
//            }
//
//            self.cancleItem =  LXAsync.asyncDelay(10.0) { [weak self] in
//                self?.pcmRecoder?.stopRecored()
//                self?.uploader?.endUpload()
//            }
//
//        }else{
//
//            //判断是否是teching动画
//            if cmodel.animation?.split == 6{
//                if let anis = cmodel.animation?.teachingAni {
//                    self.currentAni = anis.first
//                    self.currentTeach = anis.first
//                    let logStr = "id:\(self.currentAni?.id ?? ""),begin：\(self.currentAni?.begin ?? ""),end:\(self.currentAni?.end ?? "") \n"
//                    self.write(data: logStr.data(using: .utf8)!)
//                    self.seekTimeAndPlayer(time: self.currentTeach?.begin)
//                }
//
//            }else{
//                self.currentAni = cmodel.animation
//                let logStr = "id:\(self.currentAni?.id ?? ""),begin：\(self.currentAni?.begin ?? ""),end:\(self.currentAni?.end ?? "") \n"
//                self.write(data: logStr.data(using: .utf8)!)
//                self.seekTimeAndPlayer(time: cmodel.animation?.begin)
//
//            }
//
//
//            let timeInterval = TimeInterval(self.currentAni?.begin?.conversionMillisecond() ?? 0.0)
//            print("====动画开始时间\(timeInterval)")
//
//            //播放录音数据
//            guard let speechData = cmodel.speech,speechData.count != 0 else {
//                playModelFail()
//                return
//            }
//            let base64Data = Data(base64Encoded: speechData)
//            let timeStamp = Date().timeStamp
//    //        let fileName = "/\(timeStamp).mp3"
//    //        let url = FileHelper.getTemp(file: fileName)
//    //        do {
//    //            try base64Data?.write(to: url)
//    //        } catch{}
//    //
//            do {
//                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//                try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
//            }catch{}
//
//            do {
//
//                self.audioPlayer = try AVAudioPlayer.init(data: base64Data!)
//                self.audioPlayer?.delegate = self;
//                self.audioPlayer?.prepareToPlay()
//                self.audioPlayer?.play()
//
//                carView.cofigwithBox(box: (self.currentModel?.chatBox)!,totalTime: self.audioPlayer!.duration)
//                gtextboderL.isHidden = false
//                gtextboderL.configAnimation(text:(self.currentModel?.chatBox?.zh)! , totalTime: self.audioPlayer!.duration)
//
//                if cmodel.promptBox?.mode?.count == 0{
//                    if cmodel.chatBox?.en?.count != 0{
//                        carView.startAnimation()
//                    }
//                }else{
//
//                    self.answerStateAnimation(proptBox: cmodel.promptBox!)
//                }
//
//
//            } catch {
//                //初始化失败
//                playModelFail()
//            }
//        }
        
                        
    }
    
    
    
    /// 播放下一条animation：1没有语音数据，2，语音播放完成
    /// - Parameter model:
//    func playModelFail(){
//
//        if self.currentModel?.end == true {
//            navigationController?.popViewController(animated: true)
//        }
//        self.dataList?.remove(at: 0)
//        guard let model = self.dataList?.first else {
////            self.playNextLoad()
//            return
//        }
//        self.playModel(model: model);
//    }
    
    
    func handleModelPlayEnd(){
        
        guard let cmodel = self.currentModel else {
            
            return
        }
        
        if cmodel.leftOption?.oClass?.count == 0,cmodel.rightOption?.oClass?.count == 0 {
            playNext()
            return
        }
    
        if cmodel.leftOption?.oClass?.count == 0 {
            
            UIView.animate(withDuration: 0.6) {
                self.leftV.isHidden = true
            }
            
        }else{
            
            UIView.animate(withDuration: 0.6) {
                self.leftV.isHidden = false
            }
            
            self.leftBotomL.text = cmodel.leftOption?.oClass ?? ""
                        
        }
       
        
        if cmodel.rightOption?.oClass?.count == 0 {
            
            UIView.animate(withDuration: 0.6) {
                self.rightV.isHidden = true
            }
           
            self.leftV.setNeedsUpdateConstraints()
            self.leftV.snp.removeConstraints()
            self.leftV.snp.remakeConstraints({ (make) in
                make.right.equalTo(self.view.snp.centerX).offset(-5)
            })
            self.view.layoutIfNeeded()
            self.leftV.centerX = ScreenWidth / 2.0
           
        }else{
            
            UIView.animate(withDuration: 0.6) {
                self.rightV.isHidden = false
            }
            
            self.leftV.right = ScreenWidth / 2.0 - 5
            
            self.leftV.setNeedsUpdateConstraints()
            self.leftV.snp.removeConstraints()
            self.leftV.snp.remakeConstraints({ (make) in
                make.right.equalTo(self.view.snp.centerX)
            })
            self.view.layoutIfNeeded()
            self.rightBottomL.text = cmodel.rightOption?.oClass ?? ""
            self.rightCenterL.text = "\(cmodel.rightOption?.len ?? 0)"

        }
        
        var count = 0
        let total = cmodel.rightOption?.len ?? 0
        countimer = DispatchSource.makeTimerSource()
        countimer?.schedule(deadline: DispatchTime.now(),repeating: 1)
        self.countimer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
                 // 回调 回到了主线程
                self.rightCenterL.text = "\(total - count)"
                count += 1
                if count > total{
                    self.countimer?.cancel()
                    self.leftV.isHidden = true
                    self.rightV.isHidden = true
                    self.playNext()
                    
                }
              }
        })
        self.countimer?.resume()
                
        
    }
    
    func playNext(){
        
        if self.currentModel?.end == true {
            navigationController?.popViewController(animated: true)
            return
        }
        self.videoPlayer.playerManger?.pause()
        
        if self.dataList?.count == 0 {
//            navigationController?.popViewController(animated: true)
            return
        }
        
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

        let videoPath = Bundle.main.path(forResource: "lily@level1_lesson1_animation_welldone无口型.mp4", ofType: nil)
        let url = URL(fileURLWithPath: videoPath!)
                
        videoPlayer.playerManger?.assetURL = url
        videoPlayer.playerManger?.prepareToPlay()
        
       
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
        filter.addTarget(self.gpuImgView)

        //设置时间回调的间隔
        videoPlayer.playerManger?.timeRefreshInterval = 0.0001
        
        videoPlayer.playerManger?.playerPlayTimeChanged = {[weak self](asset, currentTime, duration) in
        
            print("视频当前时间\(currentTime)")

            self?.handleVideoTime(currentTime: currentTime)
            
            return
            
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
    
    
    private func handleVideoTime(currentTime:TimeInterval){
        
        let time = TimeInterval(self.currentAni?.end?.conversionMillisecond() ?? 0.0)

        if self.playend == false {
            return
        }
        
        if currentTime >= time{

            self.videoPlayer.playerManger?.pause()
            
            if ((self.currentAni?.nextAni) != nil) {
                //播放下一个视频
                self.videoPlayer.playerManger?.pause()
                self.currentAni = self.currentAni?.nextAni
                self.seekTimeAndPlayer(time: self.currentAni?.begin)

                
            }else{
                self.videoPlayer.playerManger?.pause()
                self.playNext()
//                self.handleModelPlayEnd()
                
                
                
            }
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
    static var scale:Bool = true
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        GPUDetaiVideoVC.scale = !GPUDetaiVideoVC.scale
//
//        playerScaleAnimition(isScale:GPUDetaiVideoVC.scale)
//    }

    /// 放大缩小动画
    /// - Parameter isScale: isScale 是否放大
    func playerScaleAnimition(isScale:Bool = true){
        //缩放动画
        let scaleAnimation: CABasicAnimation = CABasicAnimation()
        //transform.scale.x:更详细的指出值得改变
        scaleAnimation.keyPath = "transform.scale"
        if isScale {
            //放大
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
    
    func answerStateAnimation(title:Title){
        
                
        self.answerStateI.isHidden = false
        self.answerStateI.image = title.tclass?.getTitleImage()
        
//        if title.tclass == TClass.WrongAnswer || title.tclass == TClass.Congrats || title.tclass == TClass.WrongPronunciation {
//            //左右摇摆动画
//            let animation = CAKeyframeAnimation(keyPath: "position.x")
//            let value1 = ScreenWidth / 2 + 25
//            let value2 = ScreenWidth / 2 - 25
//            let value3 = ScreenWidth / 2 + 25
//            let value4 = ScreenWidth / 2 - 25
//            let value5 = ScreenWidth / 2
//
//            animation.values = [value1,value2,value3,value4,value5];
//            //重复次数 默认为1
//            animation.repeatCount=1;
//            //设置是否原路返回默认为不
//            animation.autoreverses = false;
//            //设置移动速度，越小越快
//            animation.duration = 1;
//            animation.isRemovedOnCompletion = false;
//            animation.fillMode = CAMediaTimingFillMode.forwards;
//            animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut),CAMediaTimingFunction(name: .easeInEaseOut),CAMediaTimingFunction(name: .easeInEaseOut),CAMediaTimingFunction(name: .easeInEaseOut)]
//            answerStateI.layer.add(animation, forKey: animation.keyPath)
//        }
                    
//        carView.setNeedsUpdateConstraints()
//        carView.animationI.isHidden = true
//
//
//        UIView.animate(withDuration: 0.35) {
//            self.carView.snp.remakeConstraints { (make) in
//                make.bottom.equalTo(self.carView.answerL.snp.bottom).offset(52)
//                make.top.equalTo(self.gtextboderL.snp.bottom).offset(20)
//                make.left.right.equalToSuperview().inset(24)
//            }
//            self.carView.superview?.layoutIfNeeded()
//        } completion: { (comple) in
//
//        }
        
    }
            
    //处理背景
    func backgroundAni(back:Background){
       
        guard let color = back.bclass?.getBackColor() else {
            return
        }
        if backImgV.backgroundColor?.ex_hexString != color.ex_hexString {
            backImgV.backgroundColor = color
            let anim = CABasicAnimation(keyPath: "backgroundColor")
            anim.duration = 0.35
            anim.fromValue = backImgV.layer.backgroundColor
            anim.toValue = color.cgColor
            anim.isRemovedOnCompletion = false
            anim.fillMode = CAMediaTimingFillMode.both
            backImgV.layer.add(anim, forKey: "backgroundColor")
            
            if back.bclass == BClass.WrongAnswer {
                handleBackMask(isError: true)
            }else{
                handleBackMask(isError: false)

            }
            
        }
        
                
    }
    
    func handleBackMask(isError:Bool = false)  {
        if isError {
            backMaskUpI.image = UIImage(named: "红色上蒙层")
            backMaskDownI.image = UIImage(named: "红色下蒙层")
        }else{
            backMaskUpI.image = nil
            backMaskDownI.image = UIImage(named: "默认蒙层")
        }
    }
    
    @IBAction func leftTapAC(_ sender: Any) {
        
        
        
        UIView.animate(withDuration: 0.6) {
            self.leftV.isHidden = true
            self.rightV.isHidden = true
        }
       
        self.playModel(model: self.currentModel)
        self.countimer?.cancel()
        
        
    }
    
    @IBAction func rightTapAC(_ sender: Any) {
        
        UIView.animate(withDuration: 0.6) {
            self.leftV.isHidden = true
            self.rightV.isHidden = true
        }
       
        self.countimer?.cancel()
        self.playNext()

    }
    /// 创建UI
    private func creatUI(){
        
               
        navBar.wr_setBackgroundAlpha(0)
        bottomView.backgroundColor = .clear
        //视频预览
//        view.insertSubview(videoPreImg, at: 1)
//        videoPreImg.frame = CGRect(x: 0, y: 0, width: ScreenWidth , height: ScreenHeight)
        
        view.addSubview(carView)
        carView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            
            
            
            make.bottom.equalToSuperview().inset(YMKDvice.bottomOffset() + 130)
        }
        
        
        
       
                   
            
        gpuImgView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.40)
        gpuImgView.layer.transform = CATransform3DScale(gpuImgView.layer.transform, 1.25, 1.25, 0)
        gpuImgView.layer.transform = CATransform3DTranslate(gpuImgView.layer.transform, 0, -67, 0)
        
        handleBackMask()
        
        
        view.addSubview(vStitle)
        view.addSubview(subTitle)
        
        vStitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.centerY.equalTo(self.view.snp.centerY).offset(-96)
        }
        
        view.addSubview(answerStateI)
        answerStateI.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY).offset(-96)
            make.centerX.equalToSuperview()

        }
        
        view.addSubview(centerStateI)
        centerStateI.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY).offset(96)
            make.centerX.equalToSuperview()

        }
        
        
        
        
        
        
//        view.addSubview(gtextboderL)
//        gtextboderL.snp.makeConstraints { (make) in
//            make.top.equalTo(answerStateI.snp.bottom).offset(11)
//            make.left.right.equalToSuperview().inset(24)
//        }

        
        subTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(self.vStitle.snp.bottom).offset(16)
        }
        
        vStitle.isHidden = true
        subTitle.isHidden = true
        
        
        
        view.addSubview(centerCard)
        centerCard.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.lessThanOrEqualToSuperview().offset(20);
            make.top.equalTo(self.subTitle.snp.bottom).offset(40)
            make.bottom.equalTo(self.centerCard.contentL.snp.bottom).offset(16)
        }
        
       
        
        
        centerCard.addSubview(inputTitleImage)
        inputTitleImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(121)
        }
        
        
        self.rightV.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view.snp.centerX).offset(5)
        })
        
        
        
        inputBV.clipsToBounds = false
        view.addSubview(inputBV)
        inputBV.addSubview(inputBL)
        inputBV.addSubview(inputBI)
        
        inputBV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(YMKDvice.bottomOffset() + 62)           
        }
        
        inputBL.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(28)
            make.right.top.bottom.equalToSuperview().inset(9)
        }
        
        inputBI.snp.makeConstraints { (make) in
            make.width.equalTo(24)
            make.height.equalTo(32)
            make.left.equalToSuperview()
            make.bottom.equalTo(inputBL.snp.centerY).offset(5)
        }
        
        
      

                
        
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
        movie.endProcessing()
    }
    

}

extension GPUDetaiVideoVC:AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        voiceEnd = true
    }
    
}
