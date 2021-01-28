//
//  SkillsVC.swift
//  MayBe
//
//  Created by liuxiang on 09/04/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class SkillsVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar()
        tableView.contentInset = UIEdgeInsets.init(top: 82, left: 0, bottom: 0, right: 0)

    }
    
     private func setNavBar(){
           
            navBar.height = 82 + YMKDvice.statusBarHeight()
            
                      
        }


}

extension SkillsVC: UITableViewDataSource, UITableViewDelegate {
    
      func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        }
           
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
       }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           
                
                let indentifier = "CellSmallID"
                var cell:SkillCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? SkillCell
                if cell == nil {
                              
                    cell = Bundle.main.loadNibNamed("SkillCell", owner: nil, options: nil)?.last as? SkillCell
                    cell.selectionStyle = .none
                          
                }
                
                return cell
           
            
        }
    
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

                return 56
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let view = UIView.init()
            view.height = 56
            
            let lab1 = UILabel.init()
            lab1.font = UIFont.customName("Black", size: 32)
            lab1.text = "Lessons"
            view.addSubview(lab1)
             
            lab1.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(20)
                make.height.equalTo(24)
                make.bottom.equalTo(view).offset(-12)
            }
             
               
               return view
       }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView.init()
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0.1
        }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
           
        return 96;
        
    }
       
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        navigationController?.pushViewController(ConfigureWifiVC(), animated: true)
        
    }
    
   
}

