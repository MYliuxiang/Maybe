//
//  CoursewareVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/10.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit


class CoursewareVC: BaseViewController {


    @IBOutlet weak var tableView: UITableView!
    var datas:[CoursewareModel] = [CoursewareModel]()
    
    public var courseId:String?
    public var contentId:String?
    public var navTitle:String?
    public var smodel:LsessonsBModel!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.titleLabelFont = .customName("Regular", size: 16)
        navBar.titleLabelColor = .colorWithHexStr("#051724")
        navBar.wr_setRightButton(with: UIImage(named: "切换视图"))
        navBar.backgroundView.backgroundColor = .clear
        navBar.title = "Key points"
        bottomView.backgroundColor = .clear
        

        weak var weakSelf = self

        navBar.onClickRightButton = {
            
            let list = [CourseWareType.PinyinEnglish.rawValue,CourseWareType.PinyinCharactersEnglish.rawValue]
            let type = UserDefaultsStandard.object(forKey: CType) as! String
            let alert = LessonsTipAlert(seleteds: [type], dataList: list, subList: ["Default","","",""], allowsMultipleSelection:false)
            alert.confirmBlock = {(seltes) in
                UserDefaultsStandard.set(seltes.first, forKey: CType)
                UserDefaultsStandard.synchronize()
                weakSelf?.tableView.reloadData()
                
            }
            alert.show()
        }
        view.backgroundColor = .colorWithHexStr("#F1F5F5")
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .colorWithHexStr("#F1F5F5")
        loadData()
        
    }
 
    func loadData(){
        
        let url = "courses/\(courseId!)/contents/\(contentId!)"
        MBRequest(url, method: .get, show: true) { (result, code) in
            if code == 200{
                guard let dic = result?["data"] as? [String:Any] else{return}
                let models = [CoursewareModel].deserialize(from: dic["pronunication"] as? NSArray) as! [CoursewareModel]
                self.datas = models
                self.tableView.reloadData()
            }
        }
    }

}

extension CoursewareVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let type = UserDefaultsStandard.object(forKey: CType) as! String
        let ctype = CourseWareType(courseWareType: type)
        
        if indexPath.section == 1{
            let indentifier = "SomeCountriesCell"
            var cell:SomeCountriesCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? SomeCountriesCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("SomeCountriesCell", owner: nil, options: nil)?.last as? SomeCountriesCell
                cell.selectionStyle = .none
                
            }
            cell.type = ctype
            return cell
        }
        
        if indexPath.section == 2{
            let indentifier = "NationalitiesCell"
            var cell:NationalitiesCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? NationalitiesCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("NationalitiesCell", owner: nil, options: nil)?.last as? NationalitiesCell
                cell.selectionStyle = .none
                
            }
            cell.type = ctype
            return cell
        }
        switch ctype {
//        case .Pinyinonly:
//            let indentifier = "Pinyinonly"
//            var cell:CoursePyOnlyCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? CoursePyOnlyCell
//            if cell == nil {
//                cell = Bundle.main.loadNibNamed("CoursePyOnlyCell", owner: nil, options: nil)?.last as? CoursePyOnlyCell
//                cell.selectionStyle = .none
//
//            }
//            cell.model = self.datas[indexPath.row]
//            return cell
            
        case .PinyinEnglish:
            let indentifier = "PinyinEnglish"
            var cell:CoursePyEnglishCCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? CoursePyEnglishCCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("CoursePyEnglishCCell", owner: nil, options: nil)?.last as? CoursePyEnglishCCell
                cell.selectionStyle = .none
                
            }
            cell.model = self.datas[indexPath.row]
            return cell
            break
//        case .PinyinCharacters:
//            let indentifier = "PinyinCharacters"
//            var cell:CourseCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? CourseCell
//            if cell == nil {
//                cell = Bundle.main.loadNibNamed("CourseCell", owner: nil, options: nil)?.last as? CourseCell
//                cell.selectionStyle = .none
//
//            }
//            cell.model = self.datas[indexPath.row]
//            return cell
        case .PinyinCharactersEnglish:
            let indentifier = "PinyinCharactersEnglish"
            var cell:CoursePyEnCharactersCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? CoursePyEnCharactersCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("CoursePyEnCharactersCell", owner: nil, options: nil)?.last as? CoursePyEnCharactersCell
                cell.selectionStyle = .none
                
            }
            cell.model = self.datas[indexPath.row]
            return cell
        default:
            let indentifier = "CourseCellID"
            var cell:CourseCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? CourseCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("CourseCell", owner: nil, options: nil)?.last as? CourseCell
                cell.selectionStyle = .none
                
            }
            cell.model = self.datas[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.datas.count == 0 {
            return 0.1
        }
        return 66
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if self.datas.count == 0 {
            return view
        }
        let label = UILabel()
        label.frame = CGRect(x: 36, y: 36, width: ScreenWidth - 72, height: 20)
        label.font = .customName("SemiBold", size: 16)
        label.textColor = .colorWithHexStr("#C5D3D3")
        label.text = "Key sentence"
        view.addSubview(label);
        return view
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        if self.datas.count == 0 {
            
            return view
        }
        
        let button = UIButton(type: .custom);
        
        button.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 60)
        button.titleLabel?.font = .customName("Bold", size: 16)
        button.setTitleColor(.colorWithHexStr("#15DABF"), for: .normal)
        button.setTitle("Practice", for: .normal)
        button.tag = section
        
        let img = UIImageView()
        img.image = UIImage(named: "A")
        img.frame = CGRect(x: ScreenWidth - 24 - 28, y: (60 - 24) / 2, width: 24, height: 24)
        view.addSubview(img)
        view.addSubview(button);
        view.backgroundColor = .white
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.datas.count == 0 {
            return 0.1
        }
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = CourseDetailVC()
        vc.model = self.datas[indexPath.row].copy() as! CoursewareModel
        vc.courseId = self.courseId
        vc.contentId = self.contentId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
                    // 圆角路径
            let path:UIBezierPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 40, height: 0))
            //
            let shapLayer:CAShapeLayer = CAShapeLayer()
            shapLayer.lineWidth = 0
            shapLayer.strokeColor = UIColor.white.cgColor
            shapLayer.fillColor = UIColor.clear.cgColor
            shapLayer.path = path.cgPath
            let maskLayer:CAShapeLayer = CAShapeLayer.init()
            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer
            view.layer.addSublayer(shapLayer)
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == 0 {
                let path:UIBezierPath = UIBezierPath.init(roundedRect: cell.contentView.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 40, height: 0))
                let shapLayer:CAShapeLayer = CAShapeLayer()
                shapLayer.lineWidth = 0
                shapLayer.strokeColor = UIColor.white.cgColor
                shapLayer.fillColor = UIColor.clear.cgColor
                shapLayer.path = path.cgPath
                let maskLayer:CAShapeLayer = CAShapeLayer.init()
                maskLayer.path = path.cgPath
                cell.layer.mask = maskLayer
                cell.layer.addSublayer(shapLayer)
            }
        }
    
    
}

