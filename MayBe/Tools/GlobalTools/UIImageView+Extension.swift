//
//  UIImageView+Extension.swift
//  YJKApp
//
//  Created by wangwenjie on 2020/4/8.
//  Copyright © 2020 lijiang. All rights reserved.
//

import Foundation

extension UIImageView {
    func kfImage(_ url: String?) {
        self.kf.setImage(with: URL(string: url ?? ""), placeholder: UIImage(named: "def_noImages"))
    }
    
    func kfUserImage(_ url: String?) {
        self.kf.setImage(with: URL(string: url ?? ""), placeholder: UIImage(named: "def_userImg"))
    }
}

extension UIImageView {
    /// 设置网络图片
    func setImage(_ url: String?) {
        self.kfImage(url)
    }
    
    /// 设置网络图片
    func setUsetImage(_ url: String?) {
        self.kfUserImage(url)
    }
    
//    /// 设置为可点击放大
//    func setScopeImages(_ urls: [String], index: Int) {
//        self.isUserInteractionEnabled = true
//        var button: UIButton?
//        self.subviews.forEach {
//            if let b = $0 as? UIButton {
//                button = b
//            }
//        }
//        if button == nil { button = UIButton() }
//        guard let b = button else { return }
//        if !(self.subviews.contains(b)) {
//            self.addSubview(b)
//            b.snp.makeConstraints({ (make) in
//                make.edges.equalToSuperview()
//            })
//            b.addTarget(self, action: #selector(UIImageView.onClickScopeButton), for: .touchUpInside)
//        }
//        self.scopeImageURLs = urls
//        self.scopeImageIndex = index
//    }
}


var ScopeImageIndexKey: Void?
var ScopeImageURLsKey: Void?

extension UIImageView {
    
    var scopeImageIndex: Int {
        get {
            return objc_getAssociatedObject(self, &ScopeImageIndexKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &ScopeImageIndexKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var scopeImageURLs: [String]? {
        get {
            return objc_getAssociatedObject(self, &ScopeImageURLsKey) as? [String]
        }
        set {
            objc_setAssociatedObject(self, &ScopeImageURLsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
//    @objc func onClickScopeButton() {
//        if let urls = scopeImageURLs {
//            CurrencyGlobalTool.showImagesInPhotoBrower(urls, scopeImageIndex)
//        }
//    }
}

//旋转
extension UIImageView {
    
    ///
    /// - Parameters:
    ///   - duration: 周期 (控制速度:2--10)
    ///   - repeatCount: 次数
    func rotate360DegreeWithImageView(duration:CFTimeInterval , repeatCount :Float ) {
        
        //让其在z轴旋转
        let rotationAnimation  = CABasicAnimation(keyPath: "transform.rotation.z")
        
        //旋转角度
        rotationAnimation.toValue = NSNumber(value:  Double.pi * 2.0 )
        
        //旋转周期
        rotationAnimation.duration = duration;
        
        //旋转累加角度
        rotationAnimation.isCumulative = true;
        
        //旋转次数
        rotationAnimation.repeatCount = repeatCount;
        
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
    }
    //停止旋转
    func stopRotate() {
        
        self.layer.removeAllAnimations()
    }
    
    
}
