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
    
    var tablewView:UITableView = UITableView(frame: .zero, style: .plain)
    var disPlayLab:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.colorWithHexStr("#051724")
        lab.font = .customName("Medium", size: 16)
        lab.text = "Pinyin + Characters"
        lab.textAlignment = .center
        return lab
    }()
    
    var topImage:UIImageView = {
        let ig = UIImageView()
        ig.backgroundColor = .red
        return ig
    }()
    
    lazy var topView:UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.layer.masksToBounds = true
        v.backgroundColor = .colorWithHexStr("#F9FBFB")
        return v
    }()
    
    
    
    
    
        
    var pushBlock:((_ type:Int)->())?
    
    init() {
        super.init(frame: .zero)
        creatUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI(){
        
        self.backgroundColor = .white
        addSubview(topImage)
        addSubview(topView)
        
        let lab = UILabel()
        lab.textColor = UIColor.colorWithHexStr("#051724")
        lab.font = .customName("Bold", size: 16)
        lab.text = "Display:"
        
        let topI1 = UIImageView()
        topI1.image = UIImage(named: "显示模式_设置icon")
        
        let topI2 = UIImageView()
        topI2.image = UIImage(named: "显示模式_箭头icon")
        topView.addSubview(topI1)
        topView.addSubview(lab)
        topView.addSubview(disPlayLab)
        topView.addSubview(topI2)

                    
        
        tablewView.delegate = self
        tablewView.dataSource = self
        addSubview(tablewView)
        tablewView.backgroundColor = .white
        tablewView.separatorStyle = .none
                
        topImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        topView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(68)
            make.top.equalTo(self.topImage.snp.bottom).offset(30)
        }
        
        topI1.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            
        }
        
        lab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(topI1.snp.right).offset(8)
        }
        
        
        disPlayLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(lab.snp.right)
        }
        
        topI2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
        
        
        
        tablewView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(displayMode))
        self.topView.addGestureRecognizer(tap)
    
        

        
    }
    
    @objc func displayMode(){
        
        print("切换模式")
        
        if (self.pushBlock != nil) {
            self.pushBlock!(1)
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
        return PanModalHeight(type: .content, height: ScreenHeight - 102)
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let lab = UILabel()
        lab.textColor = UIColor.colorWithHexStr("#C5D3D3")
        lab.font = .customName("SemiBold", size: 16)
        lab.text = "Now, you can ask Lily..."
        lab.frame = CGRect(x: 24, y: 10, width: ScreenWidth, height: 20)
        view.addSubview(lab)
        view.backgroundColor = .white
        
        
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
            self.pushBlock!(0)
        }
      
    }
}

