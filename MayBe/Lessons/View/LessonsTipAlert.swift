//
//  LessonsTipAlert.swift
//  MayBe
//
//  Created by liuxiang on 2020/9/1.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LessonsTipAlert: LxCustomAlert {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var closeB: UIButton!
    
    @IBOutlet weak var confirmB: UIButton!
    
    var dataList:[String] = [String]()
    var subList:[String] = [String]()

    var seleteds:[String] = [String]()
 

    @IBOutlet weak var heiconstraint: NSLayoutConstraint!
    
    var confirmBlock:((_ seleteds:[String])->Void)?

    
    convenience init(seleteds:[String], dataList:[String],subList:[String] = [String](),allowsMultipleSelection:Bool = true){
        self.init()
        self.layer.cornerRadius = 32
        self.layer.masksToBounds = true
        
        self.dataList = dataList
        self.seleteds = seleteds
        self.subList = subList
        
        if dataList.count > 6 {
            heiconstraint.constant = 270
        }else{
            heiconstraint.constant = CGFloat(54 * dataList.count)

        }
        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(confirmB).offset(24)
            make.width.equalTo(ScreenWidth - 24)
            
        }
        self.confirmB.layer.cornerRadius = 32
        self.confirmB.layer.masksToBounds = true
        self.offsetTop = YMKDvice.statusBarHeight() + 20
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = allowsMultipleSelection
        
        tableView.reloadData()
        guard self.seleteds.count != 0 else {
            return
        }
    
        for (idx,value) in self.dataList.enumerated() {
            for value1 in self.seleteds {
                if value == value1 {
                    tableView.selectRow(at: IndexPath(row: idx, section: 0), animated: false, scrollPosition: .none)
                    break
                }
            }
        }
    }
    
    
    @IBAction func closeAC(_ sender: Any) {
    
        self.disMiss()
    }
    
    @IBAction func confireAC(_ sender: Any) {
        
        if self.confirmBlock != nil{
            self.confirmBlock!(self.seleteds)
        }
        self.disMiss()
    }
}

extension LessonsTipAlert: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indentifier = "VideoCellID"
        var cell:TipCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? TipCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("TipCell", owner: nil, options: nil)?.last as? TipCell
            cell.selectionStyle = .none
        }
        
        cell.nameL.text = self.dataList[indexPath.row] as String
        if subList.count != 0{
            cell.subL.text = self.subList[indexPath.row]
        }
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
        return 54
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.seleteds.append(self.dataList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let index = self.seleteds.firstIndex(of:self.dataList[indexPath.row]){
            self.seleteds.remove(at: index)
        }

    }
}


