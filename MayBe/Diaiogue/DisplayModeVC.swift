//
//  DisplayModeVC.swift
//  MayBe
//
//  Created by liuxiang on 2021/3/10.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit

class DisplayModeVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataList:[String] = [String]()
    var subList:[String] = [String]()
    var displayModeBlock:((_ mode:String)->())?
    var seltedStr:String

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        subList = ["","Default",""]
        dataList = [CourseWareType.PinyinOnly.rawValue,CourseWareType.PinyinEnglish.rawValue,CourseWareType.PinyinCharacters.rawValue]
        tableView.reloadData()
        
        for (idx,value) in self.dataList.enumerated() {
            if value == seltedStr {
                tableView.selectRow(at: IndexPath(row: idx, section: 0), animated: false, scrollPosition: .none)
                break
            }
        }
        
    }
    
   
    
     init(_ seleted:String) {
        self.seltedStr = seleted

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension DisplayModeVC: UITableViewDataSource, UITableViewDelegate {
    
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
        return 56
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.displayModeBlock != nil) {
            self.displayModeBlock!(self.dataList[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }
    
   
}






