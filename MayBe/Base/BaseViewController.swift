//
//  BaseViewController.swift
//  GDDZ
//
//  Created by ykm on 2019/1/9.
//  Copyright © 2019 ymk. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    public typealias OnClickRightButton = (() -> Void)
    public typealias OnClickLeftButton = (() -> Void)
    
    
    lazy var navBar:WRCustomNavigationBar = WRCustomNavigationBar.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: YMKDvice.navBarHeight()))
    
    var rightButton:UIButton?
    var onClickRightButton:OnClickRightButton?
    var leftButton:UIButton?
    var onClickLeftButton:OnClickLeftButton?
    var haveNetData:Bool = false
    
    
    lazy var bottomView : UIView = {
        let bottomView = UIView(frame: CGRect(x: 0, y: ScreenHeight - YMKDvice.bottomOffset(), width: ScreenWidth, height: YMKDvice.bottomOffset()))
        bottomView.backgroundColor = UIColor.white
        return bottomView
    }()
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        requestRecordPermission()
        UIViewController.attemptRotationToDeviceOrientation()
        navigationController?.navigationBar.isHidden = true
        automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.bottomView)
        self.view.backgroundColor = UIColor.colorWithHex(hexColor:0xECECEC)
        setupNavBar()
        add_noNetView()
        
        self.tabBarController?.tabBar.isTranslucent = true;
        
    }
    
    fileprivate func setupNavBar()
    {
        //自定义导航栏
        view.addSubview(navBar)
        // 设置自定义导航栏背景图片
        navBar.barBackgroundColor = UIColor.white.withAlphaComponent(0.9)
        navBar.wr_setBottomLineHidden(true)
        
        
//        let blurEffect = UIBlurEffect.init(style: .extraLight)
//        let effectView = UIVisualEffectView.init(effect: blurEffect)
//        navBar.insertSubview(effectView, at: 0)
//        
        navBar.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        
        //let effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
        
        
        // 设置自定义导航栏标题颜色
        navBar.titleLabelFont = UIFont.systemFont(ofSize: 18)
        navBar.titleLabelColor = .black
        // 设置自定义导航栏左右按钮字体颜色
        navBar.wr_setTintColor(.black)
        //        navBar.wr_setBottomLineHidden(hidden: true)
        
        if self.navigationController?.children.count != 1 {
            navBar.wr_setLeftButton(with: UIImage.init(named: "返回icon")!)
            navBar.onClickLeftButton = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    func add_rightButton(titleString:String = "",imageString:String = "",style:ButtonEdgeInsetsStyle = .none,space:CGFloat = 0,textColor:UIColor = .black,backgroundColor:UIColor = .clear,font:UIFont = UIFont.systemFont(ofSize: 14),radius:CGFloat = 0,btnWidth:CGFloat = 44,btnHeight:CGFloat = 44,onClickRightButton:OnClickRightButton?) {
        
        self.onClickRightButton = onClickRightButton
        rightButton = UIButton(type: .custom)
        rightButton?.frame = CGRect(x: navBar.width - btnWidth - 10, y: YMKDvice.statusBarHeight() + (44 - btnHeight) / 2.0 , width: btnWidth, height: btnHeight)
        rightButton?.layer.cornerRadius = radius
        rightButton?.backgroundColor = backgroundColor
        rightButton?.setTitleColor(textColor, for: .normal)
        rightButton?.setTitle(titleString, for: .normal)
        rightButton?.titleLabel?.font = font
        rightButton?.setImage(UIImage(named: imageString), for: .normal)
        rightButton?.addTarget(self, action: #selector(rightButton_action), for: .touchDown)
        rightButton?.layoutButtonWithEdgeInsetsStyle(style:style, space: space)
        self.navBar.addSubview(rightButton!)
    }
    
    @objc func rightButton_action() {
        if onClickRightButton != nil {
            onClickRightButton!()
        }
    }
    
    
    func add_leftButton(titleString:String = "",imageString:String = "",style:ButtonEdgeInsetsStyle = .none,space:CGFloat = 0,textColor:UIColor = .black,backgroundColor:UIColor = .clear,font:UIFont = UIFont.systemFont(ofSize: 14),radius:CGFloat = 0,btnWidth:CGFloat = 50,btnHeight:CGFloat = 26,onClickLeftButton:OnClickLeftButton?) {
        
        self.onClickLeftButton = onClickLeftButton
        leftButton = UIButton(type: .custom)
        leftButton?.frame = CGRect(x: 15, y: YMKDvice.statusBarHeight() + (44 - btnHeight) / 2.0 , width: btnWidth, height: btnHeight)
        leftButton?.layer.cornerRadius = radius
        leftButton?.backgroundColor = backgroundColor
        leftButton?.setTitleColor(textColor, for: .normal)
        leftButton?.setTitle(titleString, for: .normal)
        leftButton?.titleLabel?.font = font
        leftButton?.setImage(UIImage(named: imageString), for: .normal)
        leftButton?.addTarget(self, action: #selector(leftButton_action), for: .touchDown)
        leftButton?.layoutButtonWithEdgeInsetsStyle(style:style, space: space)
        self.navBar.addSubview(leftButton!)
    }
    
    @objc func leftButton_action() {
        if onClickLeftButton != nil {
            onClickLeftButton!()
        }
    }
    
    // *************************** 屏幕旋转 ****************
    override var shouldAutorotate : Bool
    {
        return false
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return false
    }
    
    
    //添加无网视图
    func add_noNetView() {
        //        appNoNetView.isHidden = true
        //        keywindow.addSubview(appNoNetView)
    }
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return UIStatusBarStyle.default
    }
    
    
    func setBackgroundImage(imageName:String) {
        let background = UIImageView.init(frame: screenFrame)
        background.clipsToBounds = true
        background.contentMode = .scaleAspectFill
        background.image = UIImage.init(named: imageName)
        self.view.addSubview(background)
    }
    
    deinit {
        
        LLog( "销毁了" )
        
        
    }
    
}

extension BaseViewController{
    
     private func monitorNetwork(){
        YMKReachability.defaultIAPHelper.reachabilityChangedblock = { (reachability) in
            switch reachability.connection {
            case .wifi:
                print("当前处于WIFI状态")
            case .cellular:
                print("当前处于手机网络状态")
            case .none:
                print("无法识别")
            case .unavailable:
                print("当前处于无网状态")
            }
        }
    }
    
    
   private func requestRecordPermission(){
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
    
    
    
    
    
    
}
