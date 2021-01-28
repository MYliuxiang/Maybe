//
//  DiaioListView.swift
//  MayBe
//
//  Created by liuxiang on 2020/12/17.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit
import HWPanModal


class DiaioListView: HWPanModalContentView {
    
    var tablewView:UITableView = UITableView(frame: .zero, style: .grouped)
    var titleLab:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.colorWithHexStr("#131616")
        lab.font = .customName("SemiBold", size: 16)
        lab.text = "Now, you can ask Lily..."
        lab.textAlignment = .center
        return lab
    }()
        
    var pushBlock:(()->())?
    
    init() {
        super.init(frame: .zero)
        creatUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI(){
        
        self.backgroundColor = .white
        addSubview(titleLab)
        tablewView.delegate = self
        tablewView.dataSource = self
        addSubview(tablewView)
        tablewView.backgroundColor = .white
        tablewView.separatorStyle = .none
        
        let closetBtn = UIButton(type: .custom)
        closetBtn.setImage(UIImage(named: "关闭技能卡片icon"), for: .normal)
        closetBtn.addTarget(self, action: #selector(closeAC), for: .touchUpInside)
        addSubview(closetBtn)
        
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(32)
            make.left.greaterThanOrEqualToSuperview().offset(20)
            make.right.greaterThanOrEqualToSuperview().offset(20)
        }
        
        tablewView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        closetBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(72)
            make.height.equalTo(64)
            make.bottom.equalToSuperview().offset(-34)
        }
        
    }
    
    @objc func closeAC(){
        
        self.dismiss(animated: true) {
            
        }
    }
  
  
    


}

extension DiaioListView{
    
    override func panScrollable() -> UIScrollView? {
        return self.tablewView
    }
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .content, height: ScreenHeight - 150)
    }
    
    override func presentingVCAnimationStyle() -> PresentingViewControllerAnimationStyle {
        return .none
    }
    
    override func showDragIndicator() -> Bool {
        return false
    }
    
    override func transitionDuration() -> TimeInterval {
        return 0.5
    }
    
    override func springDamping() -> CGFloat {
        return 1
    }
    
    override func shouldRoundTopCorners() -> Bool {
        return true
    }
    
    override func cornerRadius() -> CGFloat {
        return 40
    }
    
    override func allowScreenEdgeInteractive() -> Bool {
        return true
    }
    
    //关闭拖拽手势
//    override func shouldRespond(toPanModalGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
//        return false
//    }
//
//    override func allowsTapBackgroundToDismiss() -> Bool {
//        return false
//    }
    
    
    override func shouldPrioritizePanModalGestureRecognizer(_ panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        
        return false
    }
    
   
    
}

extension DiaioListView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let indentifier = "VideoCellID"
        var cell:DiaioListCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? DiaioListCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("DiaioListCell", owner: nil, options: nil)?.last as? DiaioListCell
            cell.selectionStyle = .none
            
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
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.pushBlock != nil) {
            self.pushBlock!()
        }
      
    }
}

