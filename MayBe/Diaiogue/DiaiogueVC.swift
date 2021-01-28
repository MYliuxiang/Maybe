//
//  DiaiogueVC.swift
//  MayBe
//
//  Created by liuxiang on 09/04/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit


private let kTextMessageCellIdentifier  = "kTextMessageCellIdentifier"
private let kImageMessageCellIdentifier = "kImageMessageCellIdentifier"
private let kVideoMessageCellIdentifier = "kVideoMessageCellIdentifier"
private let kTimeMessageCellIdentifier = "kTimeMessageCellIdentifier"

class DiaiogueVC: BaseViewController {

    
    @IBOutlet weak var tableView: MessageTableView!
    var dataSource: [Any] = []
    lazy var titleLab:UILabel = UILabel()
    var pageNumber = 0
    var avplayer:AVAudioPlayer?
    
    
    var keyAnimation:CAKeyframeAnimation = {
        let keyA = CAKeyframeAnimation(keyPath: "transform.scale")
        keyA.keyTimes = [0,0.25,0.5,0.75, 1.0]//整个动画的百分之几时进行修改
        keyA.values = [1, 3.5,2,3.5, 1.0]//每个阶段的缩放比例，与keyTimes对应
        keyA.duration = 3//动画持续时间
        keyA.timingFunction = CAMediaTimingFunction(name: .linear)//整体效果要开始快结束慢
        keyA.repeatCount = HUGE
//        keyA.beginTime = CACurrentMediaTime()
        return keyA
    }()
        
    var doneBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "椭圆形"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "椭圆形"), for: .highlighted)
        return btn
        
    }()
    
    var liveRecorder:MbRecorder?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        
        self.tableView.contentInset = UIEdgeInsets.init(top: 82, left: 0, bottom: 32 + 42 * 3.5 + 42, right: 0)
        
        setNavBar()
        makeUI()
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
      
        tableView.mj_header = LXHerderRefresh(refreshingBlock: {[weak self] in
            self?.loadData()
        })
//        tableView.mj_header?.beginRefreshing()
        tableView.reloadData()
        requestRecordPermission()
        
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
    
    @objc private func beginRecordVoice() {
        
//        MBRequest("/stream",method: .post) { (result, code) in
//
//        }
//
//        return

        if  AVAudioSession.sharedInstance().recordPermission != .granted{
            let alert = UIAlertController(title: "您未打开麦克风权限", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default) { (alert) in
                JumpHelper.jumpToSystemSeting()
            }
            let action1 = UIAlertAction(title: "取消", style: .cancel) { (alert) in
            }
            alert.addAction(action)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            return
        }

        self.doneBtn.layer.add(keyAnimation, forKey: "pop")

        let timeStamp = Date().timeStamp
        let dmodel1 = DiaiogueModel()
        dmodel1.sendType = 0
        dmodel1.msgStatus = false
        dmodel1.msgType = 1
        dmodel1.text = ["demo"]
        dmodel1.created_on = timeStamp
        self.dataSource.append(dmodel1)
        self.tableView.reloadData()
        self.scrollToBottom()

        let post = StreamPost(timeStamp,subUrl: url_dialogue)
//        let post = LXPcmUploader(timeStamp)

        post.completion = {[weak self](result,created_on) in

            guard let self = self else { return }
            switch result {
            case .success(let dic):

                guard let model = NetModel.deserialize(from: dic["data"] as? [String:Any])else {

                    self.dataSource.removeAll {
                        if let value = $0 as? DiaiogueModel{
                            if value.created_on == created_on{
                                return true
                            }else{
                                return false
                            }
                        }else{

                            return false
                        }
                    }

                    self.tableView.reloadData()
                    self.scrollToBottom()
                    return
                }

                for (idx,smodel) in self.dataSource.reversed().enumerated() {

                    if let th = smodel as? DiaiogueModel {
                        if th.created_on == created_on{
                            let mIndex = self.dataSource.count - idx - 1
                            self.dataSource.remove(at: mIndex)
                            let dmodel = DiaiogueModel()
                            dmodel.id = model.id
                            dmodel.text = ["\(model.you ?? "")"]
                            dmodel.sendType = 0
                            dmodel.created_by = model.created_by
                            dmodel.created_on = model.created_on
                            dmodel.msgType = 1
                            let dmodel1 = DiaiogueModel()
                            dmodel1.id = model.id
                            dmodel1.text = ["\(model.lily ?? "")"]
                            dmodel1.sendType = 1
                            dmodel1.created_by = model.created_by
                            dmodel1.created_on = model.created_on
                            dmodel1.msgType = 1
                            self.dataSource.insert(dmodel1, at: mIndex)
                            self.dataSource.insert(dmodel, at: mIndex)
                            break
                        }
                    }

                }

                self.tableView.reloadData()
                self.scrollToBottom()

                break
            case .failure(_):

                self.dataSource.removeAll {
                    if let value = $0 as? DiaiogueModel{
                        if value.created_on == created_on{
                            return true
                        }else{
                            return false
                        }
                    }else{

                        return false
                    }
                }

                self.tableView.reloadData()
                break
            }

        }
        post.handleCancle = { [weak self](created_on) in
            guard let self = self else { return }
            self.dataSource.removeAll {
                if let value = $0 as? DiaiogueModel{
                    if value.created_on == created_on{
                        return true
                    }else{
                        return false
                    }
                }else{

                    return false
                }
            }

            self.tableView.reloadData()

        }

        let queue = DispatchQueue.global()
        queue.async {


            self.liveRecorder = MbRecorder(timeStamp)
            self.liveRecorder?.startRecored()

            var isfinshed = false
            self.liveRecorder?.callback = {(pcmData) in
                if !isfinshed{
                    if pcmData.count != 0{
                        post.uploadData(pcmData)

                    }else{
                        post.endUpload()
                        isfinshed = true

                    }
                }
            }
            self.liveRecorder?.callCancleback = {
                post.cancleLoad()
            }
        }
                
    }
    
    /// 取消录音
    @objc private func cancelRecordVoice() {
        print("cancle")
        if  AVAudioSession.sharedInstance().recordPermission != .granted{
            return
        }
        self.doneBtn.layer.removeAnimation(forKey: "pop")
        self.dataSource.removeLast()
        self.tableView.reloadData()
        self.liveRecorder?.cancleRecored()
       
    }
    
    /// 停止录音
    @objc private func endRecordVoice() {
          
        self.doneBtn.layer.removeAnimation(forKey: "pop")
        self.liveRecorder?.stopRecored()

    }
    
  
    
    
    /// 上划取消录音
    @objc private func remindDragExit() {
        print("Release to cancel")
    }
       
    /// 下滑继续录音
    @objc private func remindDragEnter() {
          
        print("Slide up to cancel")
    }
    
    func loadData(){
                
        MBRequest(url_dialogue,method: .get,bodyDict: ["PageNum": self.pageNumber,
        "PageSize": 20],show: false) { (result, code) in
            
            if code == 200{
                
                guard let dic = result?["data"] as? [String:Any] else{return}
                
                guard let array = [NetModel].deserialize(from: dic["lists"] as? NSArray), let total = dic["total"] as? Int else {
                    self.tableView.mj_header?.endRefreshing()
                    return
                }
                
                for netmodel in array {
                    
                    let dmodel1 = DiaiogueModel()
                    dmodel1.id = netmodel?.id
                    dmodel1.text = ["\(netmodel?.lily ?? "")"]
                    dmodel1.sendType = 1
                    dmodel1.created_by = netmodel?.created_by
                    dmodel1.created_on = netmodel?.created_on
                    dmodel1.msgType = 1
                    self.dataSource.insert(dmodel1, at: 0)
                    
                    let dmodel = DiaiogueModel()
                    dmodel.id = netmodel?.id
                    dmodel.text = ["\(netmodel?.you ?? "")"]
                    dmodel.sendType = 0
                    dmodel.created_by = netmodel?.created_by
                    dmodel.created_on = netmodel?.created_on
                    dmodel.msgType = 1
                    self.dataSource.insert(dmodel, at: 0)
                    
                }
                
                
                if  self.dataSource.count / 2 >= total {
                                
                    self.tableView.mj_header = nil
                             
                }
                var lastIndex = 0
                if self.pageNumber == 0{
                    lastIndex = array.count * 2 - 1
                }else{
                    lastIndex = array.count * 2
                }
                
               
                
                self.tableView.reloadData()
//                self.tableView.setNeedsLayout()
//                self.tableView.layoutIfNeeded()
                if self.dataSource.count != 0{
                    self.tableView.scrollToRow(at: IndexPath(row: lastIndex, section: 0), at: .top, animated: false)

                }
                self.tableView.mj_header?.endRefreshing()
                self.pageNumber += 1

                
            }else{
                self.tableView.mj_header?.endRefreshing()
            }
        }
                        
    }
    
    private func setNavBar(){
        titleLab.font = UIFont.customName("Bold", size: 24)
        titleLab.text = "Dialogue"
        navBar.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(navBar).offset(20)
            make.height.equalTo(82)
            make.bottom.equalTo(navBar)
        }
        
        navBar.height = 82 + YMKDvice.statusBarHeight()
        
    }
    
    func makeUI(){
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = true
        registerChatCell()
        
        view.addSubview(doneBtn)

        doneBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 84, height: 84))
            make.centerY.equalTo(ScreenHeight - YMKDvice.tabBarHeight() - 32 - 42)
        }
        
        
        doneBtn.addTarget(self, action: #selector(beginRecordVoice), for: .touchDown)
        doneBtn.addTarget(self, action: #selector(cancelRecordVoice), for: .touchCancel)
        doneBtn.addTarget(self, action: #selector(cancelRecordVoice), for: .touchUpOutside)
        doneBtn.addTarget(self, action: #selector(endRecordVoice), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(remindDragExit), for: .touchDragExit)
        doneBtn.addTarget(self, action: #selector(remindDragEnter), for: .touchDragEnter)
        
        let img = UIImageView()
        img.image = UIImage(named: "编组 9")
        view.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.center.equalTo(doneBtn)
            make.size.equalTo(CGSize(width: 19, height: 25))
        }
        
        
       
    }
    
    private func registerChatCell() {
        tableView.register(LXTextMessageCell.self, forCellReuseIdentifier: kTextMessageCellIdentifier)
        tableView.register(LXImageMessageCell.self, forCellReuseIdentifier: kImageMessageCellIdentifier)
        tableView.register(LXVideoMessageCell.self, forCellReuseIdentifier: kVideoMessageCellIdentifier)
        tableView.register(LXTimeCell.self, forCellReuseIdentifier: kTimeMessageCellIdentifier)
        
    }
    
    /// 滚到底部
    private func scrollToBottom(_ animated: Bool = true) {
        
        let row = tableView.numberOfRows(inSection: 0)
         self.tableView.scrollToRow(at: IndexPath(row: row - 1, section: 0), at: .top, animated: animated)
    }
    
        
}

// MARK: - UITableViewDelegate
extension DiaiogueVC: UITableViewDelegate, UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //        if isSended {
        //            isSended = false
        //        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        if isSended {
        //            return
        //        }
        
        //        if plainTabView.y <= 0 && isBecome {
        //            DispatchQueue.main.async {
        //                NotificationCenter.default.post(name: .kChatTextKeyboardNeedHide, object: nil)
        //            }
        //        }
    }
}



// MARK: - UITableViewDataSource
extension DiaiogueVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = dataSource[indexPath.row] as? DiaiogueModel {
            if model.msgType == 1 {
                let textCell = tableView.dequeueReusableCell(withIdentifier: kTextMessageCellIdentifier) as! LXTextMessageCell
                //                            textCell.delegate = self
                configureCellModel(cell: textCell, at: indexPath)
                return textCell
            }else if model.msgType == 2 {
                let imageCell = tableView.dequeueReusableCell(withIdentifier: kImageMessageCellIdentifier) as! LXImageMessageCell
                configureCellModel(cell: imageCell, at: indexPath)
                //                            imageCell.delegate = self
                return imageCell
            }else if model.msgType == 3 {
                let videoCell = tableView.dequeueReusableCell(withIdentifier: kVideoMessageCellIdentifier) as! LXVideoMessageCell
                configureCellModel(cell: videoCell, at: indexPath)
                //                            videoCell.delegate = self
                return videoCell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let model = dataSource[indexPath.row] as? DiaiogueModel {
            if model.msgType == 1 {
                return tableView.fd_heightForCell(withIdentifier: kTextMessageCellIdentifier, cacheBy: indexPath) { [weak self] (cell) in
                    if let textCell = cell as? LXTextMessageCell {
                        self?.configureCellModel(cell: textCell, at: indexPath)
                    }
                }
            }else if model.msgType == 2 {
                return tableView.fd_heightForCell(withIdentifier: kImageMessageCellIdentifier, cacheBy: indexPath) { [weak self] (cell) in
                    if let imageCell = cell as? LXImageMessageCell {
                        self?.configureCellModel(cell: imageCell, at: indexPath)
                    }
                }
            }else if model.msgType == 3 {
                return tableView.fd_heightForCell(withIdentifier: kVideoMessageCellIdentifier, cacheBy: indexPath) { [weak self] (cell) in
                    if let videoCell = cell as? LXVideoMessageCell {
                        self?.configureCellModel(cell: videoCell, at: indexPath)
                    }
                }
            }
        }
        
        return 0.01
    }
    
    
    func configureCellModel(cell: UITableViewCell, at indexPath: IndexPath) {
        if let textCell = cell as? LXTextMessageCell {
            textCell.model = self.dataSource[indexPath.row] as? DiaiogueModel
        }else if let imageCell = cell as? LXImageMessageCell {
            imageCell.model = self.dataSource[indexPath.row] as? DiaiogueModel
        }else if let viodeCell = cell as? LXVideoMessageCell {
            viodeCell.model = self.dataSource[indexPath.row] as? DiaiogueModel
        }
    }
}






