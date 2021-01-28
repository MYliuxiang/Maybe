//
//  CourseDetailVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/15.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CourseDetailVC: BaseViewController {
    @IBOutlet weak var layout: JQCollectionViewAlignLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    var datas:[CoursewareModel] = [CoursewareModel]()
    public var model:CoursewareModel!
    var player:AVAudioPlayer?
    var myplayer:AVAudioPlayer?
    
    var status:Int = 0
    var uploader:StreamPost?
    var pcmRecoder:MbRecorder?
    var indexs:[Int] = [Int]()
    var selted:IndexPath?
    public var courseId:String?
    public var contentId:String?
    var recoderPath:String?
    lazy var lineView:CourseErrorLine = {
        let view = CourseErrorLine();
        return view
    }()
    
    var isRead:Bool = false
    
    @IBOutlet weak var tipLab: UILabel!
    @IBOutlet weak var palyerB: UIButton!
    
    @IBOutlet weak var myPlayerB: UIButton!
    @IBOutlet weak var recoerdB: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navBar.title = "Practice your pronunciation"
        
        navBar.titleLabelFont = .customName("Regular", size: 16)
        navBar.titleLabelColor = .colorWithHexStr("#051724")
        
        
        view.backgroundColor = .white
        
        palyerB.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview().offset(-70)
            make.bottom.equalToSuperview().offset(-YMKDvice.bottomOffset() - 40)
        }
        recoerdB.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.left.equalTo(ScreenWidth / 2.0 + 20)
            make.bottom.equalToSuperview().offset(-YMKDvice.bottomOffset() - 40)
        }
        
        myPlayerB.isHidden = true
        tipLab.isHidden = true
        
        
        
        loadVoice()
        
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(UINib.init(nibName: "CoursewareCell", bundle: nil), forCellWithReuseIdentifier: "CoursewareCellID")
        // 注册footView
        collectionView.register(UINib.init(nibName: "CoursewareFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CoursewareFooterViewID")
        collectionView.register(UINib.init(nibName: "CoursewareHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CoursewareHeaderViewID")
        collectionView.register(UINib.init(nibName: "CourseErrorFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CourseErrorFooterID")
        collectionView.register(UINib.init(nibName: "SmartFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SmartFooterViewID")
        
        //添加画线视图
        lineView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 200);
        lineView.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)
        lineView.backgroundColor = .clear
        collectionView.addSubview(lineView);
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        lineView.touchBlock = {[weak self] in
            self?.lineView.touchEnable = false
            self?.indexs = []
            self?.model.errors = nil
            self?.collectionView?.reloadData()
            self?.lineView.isDrawLine = false
            self?.myPlayerB.isEnabled = false
        }
        

    }
    
    @IBAction func palyerAC(_ sender: Any) {
        
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        } catch _ {}
        
        
        if self.player!.isPlaying {
            return
        }
        self.player?.play()
        self.recoerdB.isEnabled = false
        self.myPlayerB.isEnabled = false
        
        if status == 0{
            self.palyerB.setImage(UIImage(named: "原声大icon_播放中"), for: .normal)
        }else{
            self.palyerB.setImage(UIImage(named: "原声小icon_播放中"), for: .normal)
        }
        
    }
    
    @IBAction func recordAC(_ sender: Any) {
        
        self.recoerdB.setImage(UIImage(named: "录音icon"), for: .normal)
        self.recoerdB.isSelected = !self.recoerdB.isSelected
        if self.recoerdB.isSelected{
            self.tipLab.isHidden = false
        }
        
        if status == 0{
            self.recoerdB.snp.remakeConstraints{ (make) in
                make.width.height.equalTo(100)
                make.bottom.equalToSuperview().offset(-YMKDvice.bottomOffset() - 40)
                make.centerX.equalToSuperview()
            }
            self.palyerB.snp.remakeConstraints{ (make) in
                make.width.height.equalTo(52)
                make.right.equalTo(self.recoerdB.snp.left).offset(-36)
                make.centerY.equalTo(self.recoerdB)
            }
            self.myPlayerB.snp.remakeConstraints{ (make) in
                make.width.height.equalTo(52)
                make.left.equalTo(self.recoerdB.snp.right).offset(36)
                make.centerY.equalTo(self.recoerdB)
            }
            UIView.animate(withDuration: 0.35) {
                self.palyerB.isHidden = true
                self.view.layoutIfNeeded()
            }
            status = 1
            self.palyerB.setImage(UIImage(named: "播放原声icon(1)"), for: .normal)
            
        }
        if !self.recoerdB.isSelected && status == 1{
            
            self.palyerB.snp.remakeConstraints{ (make) in
                make.width.height.equalTo(52)
                make.right.equalTo(self.recoerdB.snp.left).offset(-36)
                make.centerY.equalTo(self.recoerdB)
            }
            self.myPlayerB.snp.remakeConstraints{ (make) in
                make.width.height.equalTo(52)
                make.left.equalTo(self.recoerdB.snp.right).offset(36)
                make.centerY.equalTo(self.recoerdB)
            }
            UIView.animate(withDuration: 0.35) {
                self.palyerB.isHidden = false
                self.myPlayerB.isHidden = false
                self.tipLab.isHidden = true
                self.view.layoutIfNeeded()
            }
            
        }
        
        if self.recoerdB.isSelected && status == 1{
            UIView.animate(withDuration: 0.35) {
                self.palyerB.isHidden = true
                self.myPlayerB.isHidden = true
                self.tipLab.isHidden = false
            }
        }
        
        
        if self.recoerdB.isSelected{
            //录制声音
            let suburl = "/courses/\(courseId!)/contents/\(contentId!)/pronunication/\(self.model.id!)"
            
            if (self.uploader != nil) {
                self.uploader?.cancleLoad()
            }
            
            self.uploader = StreamPost(suburl,subUrl: suburl)
            self.uploader?.completion = {[weak self](result,created_on) in
                guard let self = self else { return }
                switch result {
                case .success(let dic):
                    
                    guard let data = dic["data"] as? [String:Any] else{
                        return
                    }
                    guard let dataindexs = data["index"] as? [Int] else {
                        return
                    }
                    self.indexs = dataindexs
                    

                    self.model.errors = [CourseErrorModel].deserialize(from: data["detail"] as? NSArray) as? [CourseErrorModel]
                    self.selted = nil
                    self.collectionView.reloadData()
                    self.drawLie()
                    
                    break
                case .failure(_):
                    self.pcmRecoder?.stopRecored()
                    self.recoerdB.isSelected = false
                    break
                }
            }
            
            let queue = DispatchQueue.global()
            queue.async {
                let timeStamp = Date().timeStamp
                let tmpDir = NSHomeDirectory() + "/tmp"
                self.recoderPath = "file://" + tmpDir + "/\(timeStamp).pcm"
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
            }
            
        }else{
            //停止上传
            self.pcmRecoder?.stopRecored()
            self.myPlayerB.isEnabled = true

        }        
    }
    
    
    func drawLie(){
        
        
        guard let errors = self.model.errors else {
            return
        }
        
        if errors.count > 2 {
            return
        }
        
        self.collectionView.layoutIfNeeded()
       
        var points:[CGPoint] = [CGPoint]()
        var frames:[CGRect] = [CGRect]()

        for (idx,error) in errors.enumerated() {
            guard let index = error.index else {
                return
            }
            
            
            
            let attribut = self.collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0))
            let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! CoursewareCell
            let width = cell.rectYlablIndex(forIndex: 0)
            let footer = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: idx + 1)) as! CourseErrorFooter
            let footerattribut =  self.collectionView.layoutAttributesForSupplementaryElement(ofKind:UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: idx + 1))
            
            let point = CGPoint(x: (attribut?.frame.minX)! + width / 2, y: (attribut?.frame.maxY)!)
            points.append(point)
            let f = CGRect(x: 24, y: (footerattribut?.frame.minY)! + 5, width: footer.errorView.frame.width, height: 60)
            frames.append(f)
            
        }

        
        self.lineView.drawLineOnly(firstPoint: points.first!, firstFrame: frames.first!, secondPoint: points[1], secondFrame: frames[1])

        
        
        
//        self.lineView.drawLineOnly(firstPoint: CGPoint(x: (attribut1?.frame.minX)! + width1, y: (attribut1?.frame.maxY)!), firstFrame: CGRect(x: 24, y: (attribut3?.frame.minY)! + 5, width: footer1.errorView.frame.width, height: 60),secondPoint: CGPoint(x:(attribut2?.frame.minX)! + width2 , y: (attribut2?.frame.maxY)!),secondFrame: CGRect(x: footer2.errorView.left, y: (attribut4?.frame.minY)! + 5, width: footer2.errorView.width, height: 60))
        
        
//        let attribut1 = self.collectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))
//        let attribut2 = self.collectionView.layoutAttributesForItem(at: IndexPath(row: 2, section: 0))
//        let cell1 = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! CoursewareCell
//        let cell2 = self.collectionView.cellForItem(at: IndexPath(row: 2, section: 0)) as! CoursewareCell
//        let width1 = cell1.rectYlablIndex(forIndex: 0)
//        let width2 = cell2.rectYlablIndex(forIndex: 0)
//        let footer1 = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 1)) as! CourseErrorFooter
//        let footer2 = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 2)) as! CourseErrorFooter
//        let attribut3 =  self.collectionView.layoutAttributesForSupplementaryElement(ofKind:UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 1))
//        let attribut4 =  self.collectionView.layoutAttributesForSupplementaryElement(ofKind:UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 2))
////        self.lineView.drawLineTwo(firstPoints: [CGPoint(x:(attribut1?.frame.minX)! + width1 , y: (attribut1?.frame.maxY)!),CGPoint(x: 24, y: (attribut3?.frame.minY)! + 35)],secondPoints: [CGPoint(x:(attribut2?.frame.minX)! + width2 , y: (attribut2?.frame.maxY)!),CGPoint(x: ScreenWidth - 24, y: (attribut4?.frame.minY)! + 35)])
//        self.lineView.drawLineOnly(firstPoint: CGPoint(x: (attribut1?.frame.minX)! + width1, y: (attribut1?.frame.maxY)!), firstFrame: CGRect(x: 24, y: (attribut3?.frame.minY)! + 5, width: footer1.errorView.frame.width, height: 60),secondPoint: CGPoint(x:(attribut2?.frame.minX)! + width2 , y: (attribut2?.frame.maxY)!),secondFrame: CGRect(x: footer2.errorView.left, y: (attribut4?.frame.minY)! + 5, width: footer2.errorView.width, height: 60))
        self.lineView.touchEnable = true
    }
    
    @IBAction func myPlayerAC(_ sender: Any) {
        
        if self.myplayer?.isPlaying ?? false {
            return
        }
        self.recoerdB.isEnabled = false
        self.palyerB.isEnabled = false
        self.myPlayerB.setImage(UIImage(named: "用户声音小icon_播放中"), for: .normal)
        
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        } catch _ {}
        
        do {
            
//            let songData = try NSData(contentsOf: URL(string: self.recoderPath!)!, options: NSData.ReadingOptions.mappedIfSafe)
            let sonData = try Data(contentsOf: URL(string: self.recoderPath!)!)
            self.myplayer = AVAudioPlayer.sp_createPlayer(with: sonData)
            self.myplayer?.delegate = self;
            self.myplayer?.prepareToPlay()
            self.myplayer?.play()

        } catch let error as NSError {
            print(error)
            self.recoerdB.isEnabled = true
            self.palyerB.isEnabled = true
            self.myPlayerB.setImage(UIImage(named: "用户声音小icon_可点击"), for: .normal)
        }
                
    }
    
    func loadVoice(){
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        } catch _ {}
        
        do {
            let base64Data = Data(base64Encoded: model.speech!)
            self.player = try AVAudioPlayer.init(data: base64Data!)
            self.player?.delegate = self;
            self.player?.prepareToPlay()
        } catch _ {
            print("初始化语音播放数据失败")
        }
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let newValue = change![.newKey] as? CGSize else {
            return
        }
        self.lineView.height = newValue.height
        self.lineView.setNeedsDisplay()

    }
    
    deinit {
        
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
}

extension CourseDetailVC:AVAudioPlayerDelegate{
    
    //播放完成
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == self.player {
            self.recoerdB.isEnabled = true
            self.myPlayerB.isEnabled = true
            if status == 0{
                self.palyerB.setImage(UIImage(named: "播放原声icon"), for: .normal)
            }else{
                self.palyerB.setImage(UIImage(named: "播放原声icon(1)"), for: .normal)
            }
        }else{
            self.recoerdB.isEnabled = true
            self.palyerB.isEnabled = true
            self.myPlayerB.setImage(UIImage(named: "用户声音小icon_可点击"), for: .normal)
        }
    }
    
}

extension CourseDetailVC:UICollectionViewDataSource,JQCollectionViewAlignLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.model.contetns.count
        }else{
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if self.model.errors == nil {
            return 1
        }else{
            return 1 + (self.model.errors?.count ?? 0) + 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let indentifier = "CoursewareCellID"
        let cell:CoursewareCell! = (collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as! CoursewareCell)
        cell.model = model.contetns[indexPath.row]
       
        var ps = [String]()
        var ws = [String]()
       
        for item in self.indexs {
            ps.append(model.pinyin![item])
            ws.append(model.words![item])
        }
        
        cell.selectdPins = ps
        cell.selecdtwords = ws
        
        if self.selted?.row == indexPath.row {
            cell.seleted = true
        }else{
            cell.seleted = false
        }
                
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView : CoursewareHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CoursewareHeaderViewID", for: indexPath) as! CoursewareHeaderView
            headerView.title.text = self.model.eng
            return headerView
        }else{
            
            if indexPath.section == 0 {
                let footView : CoursewareFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CoursewareFooterViewID", for: indexPath) as! CoursewareFooterView
                if self.selted != nil {
                    let dmodel = model.contetns[self.selted!.row]
                    footView.lab1.text = dmodel.translate?.partsOfSpeech
                    footView.lab2.text = dmodel.translate?.text
                }
                
                return footView

            }else if indexPath.section == 1 || indexPath.section == 2{
                
                let footView : CourseErrorFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CourseErrorFooterID", for: indexPath) as! CourseErrorFooter
                footView.posionType = indexPath.section - 1
                footView.model = self.model.errors![indexPath.section - 1]
                return footView
            }else{
                let footView : SmartFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SmartFooterViewID", for: indexPath) as! SmartFooterView
                return footView
                
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.indexs.removeAll()
        if self.selted?.row == indexPath.row{
            self.selted = nil
        }else{
            self.selted = indexPath
        }
        self.collectionView.reloadData()

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == 0 {
            if self.selted == nil {
                
                return CGSize(width:ScreenWidth , height: 0)
                
            }else{
                
                let dmodel = model.contetns[self.selted!.row]
                return CGSize(width:ScreenWidth , height: (dmodel.translate?.text?.ex_height(with: ScreenWidth - 56, font: .customName("SemiBold", size: 24)) ?? 18) + 65)
            }
        }else{
            
            return CGSize(width:ScreenWidth , height: 70)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       
        if section == 0 {
            return CGSize(width:ScreenWidth , height: (model.eng?.ex_height(with: ScreenWidth - 56, font: .customName("SemiBold", size: 24)) ?? 20) + 40)
        }else{
            return CGSize(width:ScreenWidth , height: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let subModel = model.contetns[indexPath.row]
        return CGSize(width: subModel.widths[0] + subModel.widths[1] + 1, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0{
            return UIEdgeInsets(top: 12, left: 24, bottom: 24, right: 24)

        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout: JQCollectionViewAlignLayout!, itemsDirectionInSection section: Int) -> JQCollectionViewItemsDirection {
        return .LTR
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout: JQCollectionViewAlignLayout!, itemsVerticalAlignmentInSection section: Int) -> JQCollectionViewItemsVerticalAlignment {
        return .top
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout: JQCollectionViewAlignLayout!, itemsHorizontalAlignmentInSection section: Int) -> JQCollectionViewItemsHorizontalAlignment {
        return .left
    }
    
    
}

