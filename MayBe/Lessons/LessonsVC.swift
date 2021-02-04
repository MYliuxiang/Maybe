//
//  LessonsVC.swift
//  MayBe
//
//  Created by liuxiang on 09/04/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit


class LessonsVC: BaseViewController ,URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate{
    var responseData = NSMutableData()
    
    var cellStatus:Int = 1
    lazy var titleLab:UILabel = UILabel()
    
    @IBOutlet var sHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var uploader:StreamPost?
    var pcmRecoder:MbRecorder?
    //    var ccloader:CCVoiceUploader?
    var dataList:[LsessonsBModel] = [LsessonsBModel]()
    var tipModel:TipModel?
    var types:[String] = [String]()
    
    var carView:CardView?
    
    
    @IBAction func 动画(_ sender: Any) {
        
        carView?.answerStr = "\(carView?.answerStr)3";

        
        carView?.startListenAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        
        
        
        
        // Do any additional setup after loading the view.
        self.tableView.contentInset = UIEdgeInsets.init(top: 82, left: 0, bottom: 0, right: 0)
        cellStatus = 1
        setNavBar()
        loadData()
        
        
        //添加网络权限的通知
        NotificationCenter.addObserver(observer: self, selector: #selector(handleRestrictedStateNotice), name: NotificationName.RestrictedStateNotice)
        
        let vStitle = VideoTitlesAniView()
        view.addSubview(vStitle)
        vStitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(200)
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            DispatchQueue.main.async {
                vStitle.configAnimation(subtitles: ["we","shi","meiguo","we","shi"], totalTime: 3)
            }
        }

//        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
//            DispatchQueue.main.async {
//                vStitle.anginAnimation(time: 3)
//            }
//        }
//        let lab = UILabel()
//        lab.font = UIFont.init(name: "PinyinFont0-Regular", size: 100)
//        view.addSubview(lab)
//        lab.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(40)
//            make.right.equalToSuperview().offset(-40)
//            make.top.equalTo(200)
//        }
//        lab.text = "oi"
//
//        let lab1 = UILabel()
//        lab1.font = UIFont.init(name: "PinyinFont0-Regular", size: 100)
//        view.addSubview(lab1)
//        lab1.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(40)
//            make.right.equalToSuperview().offset(-40)
//            make.top.equalTo(200)
//        }
//        lab1.textColor = .red
//        lab1.text = "ǒǐ"
            
    }
    
   
    
        
    @objc func handleRestrictedStateNotice(noti:Notification){
        
        guard let state = noti.userInfo?["state"] else {
            return
        }
        if state as? Int == 1,self.dataList.count == 0 {
            self.loadData()
        }
       
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
   
    @IBAction func videoAC(_ sender: Any) {
        
        let vc = CoursewareVC()
        navigationController?.pushViewController(vc, animated: true)
        //        let vc = DemoPlayerVC()
        //        navigationController?.pushViewController(vc,animated: true)
    }
    
    
    func loadData(){
        MBRequest(url_courses, method: .get, bodyDict: ["type":self.types.joined(separator: ",")], show: true) { (result, code) in
            if code == 200{
                
                
                guard let dic = result?["data"] as? [String:Any] else{return}
                
                let modes = [LsessonsBModel].deserialize(from: dic["lists"] as? NSArray) as! [LsessonsBModel]
                self.dataList.removeAll()
                self.dataList += modes              
                self.tableView.reloadData()
                
            }
                        
        }
        
    }
    
    private func setNavBar(){
        titleLab.font = UIFont.customName("Bold", size: 24)
        titleLab.text = "Lessons";
        navBar.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(navBar).offset(20)
            make.height.equalTo(82)
            make.bottom.equalTo(navBar)
        }
        navBar.height = 82 + YMKDvice.statusBarHeight()
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "搜索icon"), for: .normal)
        navBar.addSubview(btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "筛选icon"), for: .normal)
        btn2.addTarget(self, action: #selector(confirmAC), for: .touchUpInside)
        navBar.addSubview(btn2)
        
        btn1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 28, height: 28))
            make.centerY.equalTo(titleLab)
            make.right.equalTo(navBar).offset(-20)
        }
        
        btn2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 28, height: 28))
            make.centerY.equalTo(titleLab)
            make.right.equalTo(btn1.snp_leftMargin).offset(-27)
            
        }
        
    }
    
    @objc func confirmAC(){
        
        guard (self.tipModel == nil) else {
            let alert = LessonsTipAlert(seleteds: self.types, dataList: (self.tipModel?.lists)! as [String])
            weak var weakSelf = self
            alert.confirmBlock = {(seltes) in
                weakSelf?.types = seltes
                weakSelf?.loadData()
            }
            alert.show()
            return
        }
        MBRequest(url_coursetype, method: .get, show: true) { (result, code) in
            if code == 200{
                
                guard let dic = result?["data"] as? [String:Any] else {
                    return
                }
                self.tipModel = TipModel.deserialize(from: dic)
                let alert = LessonsTipAlert(seleteds: [String](), dataList: (self.tipModel?.lists)! as [String])
                weak var weakSelf = self
                alert.confirmBlock = {(seltes) in
                    weakSelf?.types = seltes
                    weakSelf?.loadData()
                }
                alert.show()
                
            }
        }
        
    }
    
}


extension LessonsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cellStatus == 0{
            let indentifier = "CellBigID"
            var cell:LessonsBigCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? LessonsBigCell
            if cell == nil {
                
                cell = Bundle.main.loadNibNamed("LessonsBigCell", owner: nil, options: nil)?.last as? LessonsBigCell
                cell.selectionStyle = .none
                
            }
            
            return cell
            
        }else{
            
            let indentifier = "CellSmallID"
            var cell:LessonsSmallCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? LessonsSmallCell
            if cell == nil {
                
                cell = Bundle.main.loadNibNamed("LessonsSmallCell", owner: nil, options: nil)?.last as? LessonsSmallCell
                cell.selectionStyle = .none
                
            }
            
            let model = self.dataList[indexPath.row]
            cell.titleL.text = model.type ?? ""
            cell.contentL.text = model.name ?? ""
            cell.coverI.kfImage(model.icon)
            cell.scoreI.kfImage(model.score)
            //                cell.coverI.kf.sd
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        //            if section == 0 {
        //                return 0.1
        //            }else{
        
        return 0.1
        return 56
        //            }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //           if section == 0 {
        //               return UIView.init()
        //           }else{
        
        let view = UIView.init()
        view.height = 0.1
        
        //            let lab1 = UILabel.init()
        //            lab1.font = UIFont.customName("Black", size: 32)
        //            lab1.text = "Lessons"
        //            view.addSubview(lab1)
        //             
        //            lab1.snp.makeConstraints { (make) in
        //                make.left.equalTo(view).offset(20)
        //                make.height.equalTo(24)
        //                make.bottom.equalTo(view).offset(-12)
        //            }
        
        
        return view
        //           }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellStatus == 0 {
            return 187
        }else{
            return 95;
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let alert = AnswerAlert(qusetion: "Wo shì měiguó ");
        //        alert.show()
        //
        let model = self.dataList[indexPath.row]
        let vc = DetailLVC()
        vc.smodel = model
        navigationController?.pushViewController(vc, animated: true)
        
        //        let subView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 1000));
        //        subView.backgroundColor = .red;
        ////                self.tableView.insertSubview(subView, at: 0);
        //        self.tableView.insertSubview(subView, belowSubview: self.tableView.subviews.first!);
        
        
        
    }
    
}

