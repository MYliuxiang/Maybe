//
//  DetailLVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/9/1.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class DetailLVC: BaseViewController {

    @IBOutlet weak var statesI: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var heightC: NSLayoutConstraint!
    @IBOutlet weak var headerTitleL: UILabel!
    @IBOutlet weak var headerCoverI: UIImageView!
    @IBOutlet var headerView: UIView!
    public var smodel:LsessonsBModel!
    var backImg:UIImageView = {
        let imagV = UIImageView()
        let subImage = UIImageView()
        subImage.image = UIImage(named: "绿色蒙层")
        imagV.addSubview(subImage)
        subImage.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
        }
        return imagV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bottomView.backgroundColor = .clear
        self.titleL.text = self.smodel.name
        self.heightC.constant = (ScreenWidth - 48) / 327 * 378
        view.backgroundColor = .white
        self.navBar.isHidden = true
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        
        tableView.backgroundView = self.backImg
      
        loadData()
    }
    
    func loadData(){
        let url = url_courses + "/" + (self.smodel.id ?? "")
        MBRequest(url, method: .get, bodyDict: ["courseId" : self.smodel.id ?? ""], show: true) { (result, code) in
            if code == 200{
                
                self.smodel = LsessonsBModel.deserialize(from: result?["data"] as? [String:Any])
                self.tableView.reloadData()
                            
//                self.headerCoverI.kfImage(self.smodel.icon)
                self.backImg.kfImage(self.smodel.icon)
                
                self.headerTitleL.text = self.smodel.description ?? ""
                self.headerTitleL.preferredMaxLayoutWidth = ScreenWidth - 96;
                self.headerView.height = 400
                self.tableView.tableHeaderView = self.headerView
                
//                let height = self.tableView.tableHeaderView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//                var frame = self.tableView.tableHeaderView?.frame
//                frame?.size.height = height!
//                self.tableView.tableHeaderView?.frame = frame!
            }
        }
    }
    
    
    @IBAction func coureseAC(_ sender: Any) {
        
        let model = self.smodel.contents![0]
        let vc = CoursewareVC()
        vc.navBar.title = model.name
        vc.courseId = smodel.id
        vc.contentId = model.id
        vc.smodel = self.smodel
        navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func backAC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func permissionToReques(){
        let alert = UIAlertController(title: "温馨提示", message: "此功能需要您开启麦克风权限,请前往设置中开启", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "前往开启", style: .default, handler: { (action) in
            let url = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.open(url!)
            }
           
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func requestMicroPhoneAuth(){
        AVCaptureDevice.requestAccess(for: .audio) { (granted) in
            if granted{
                DispatchQueue.main.async {
                    self.palyerAC("")
                }
            }
        }
    }
    
   
    @IBAction func palyerAC(_ sender: Any) {
        let microPhoneStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch microPhoneStatus {
        case .denied:
        // 被拒绝
            permissionToReques()
            break

        case .restricted:
            // 被拒绝
            permissionToReques()
            break
        case .notDetermined:
            // 没弹窗
            requestMicroPhoneAuth()
            break
        case .authorized:
            // 有授权
            
            //跳转u3d课程
    //        let vc = DetailLessonsVC()
    //        vc.smodel = self.smodel
    //        navigationController?.pushViewController(vc, animated: true)
            
    //        //跳转视频课程
    //        let vc = DetailVideoVC()
    //        vc.smodel = self.smodel
    //        navigationController?.pushViewController(vc, animated: true)
            
            //跳转GPU视频课程
            let vc = GPUDetaiVideoVC()
            vc.smodel = self.smodel
            self.navigationController?.pushViewController(vc, animated: true)
       
            break
        
        default:
            break
        }
        
      

    }
}

extension DetailLVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.smodel.contents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let indentifier = "VideoCellID"
        var cell:DetailLCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? DetailLCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("DetailLCell", owner: nil, options: nil)?.last as? DetailLCell
            cell.selectionStyle = .none
            
        }
        let model = self.smodel.contents![indexPath.row]
        cell.nameL.text = model.name
        cell.backgroundColor = .clear
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.smodel.contents![indexPath.row]

        let vc = CoursewareVC()
        vc.navBar.title = model.name
        vc.courseId = smodel.id
        vc.contentId = model.id
        vc.smodel = self.smodel
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
