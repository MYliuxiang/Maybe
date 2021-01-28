//
//  LXCycleAnimation.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/17.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

enum AnimationType {
    case scale,opacity
    func getWidth()->CGFloat{
        switch self {
        case .scale:
            return 5
            
        default:
            return 8
        }
    }
}

class LXCycleAnimation: NSObject {
    
  
//    private var width:CGFloat?
//
//
//    static let shared = LXCycleAnimation()
//    override init() {
//        super.init()
//    }
    
    static func setUpScaleAnimation(fatherView:UIView,type:AnimationType){
        var typeStr = ""
        var vaules1:[Any]?
        var vaules2:[Any]?
        var vaules3:[Any]?
        switch type {
        case .scale:
            //缩放
            typeStr = "transform.scale"
            vaules1 = [3,2,1,3]
            vaules2 = [2,3,2.2,2]
            vaules3 = [1,1,3,1]
            break
        default:
            //颜色
            typeStr = "opacity"
            vaules1 = [1,0.3,0.3,1];
            vaules2 = [0.3,1,0.3,0.3];
            vaules3 = [0.3,0.3,1,0.3];
            break
        }
        
        let oldred1 = fatherView.viewWithTag(10001)
        let oldred2 = fatherView.viewWithTag(10002)
        let oldred3 = fatherView.viewWithTag(10003)
                
        oldred1?.removeFromSuperview()
        oldred2?.removeFromSuperview()
        oldred3?.removeFromSuperview()
        
       

        let redPoint1 = CGPoint(x: fatherView.center.x - 20, y: fatherView.bounds.size.height/2.0)
        let red1 = self.setUpView(fatherView: fatherView, center: redPoint1,redWidth: type.getWidth());
        red1.tag = 10001
        self.addAnimation(view: red1, vaules: vaules1!, keyPath: "firstAnimation", animationPath: typeStr)
        fatherView.addSubview(red1)
        red1.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: type.getWidth(), height: type.getWidth()))
            make.centerX.equalToSuperview().offset(-20)
        }
        
        let redPoint2 = CGPoint(x: fatherView.center.x, y: fatherView.bounds.size.height/2.0)
        let red2 = self.setUpView(fatherView: fatherView, center: redPoint2,redWidth: type.getWidth());
        red2.tag = 10002

        self.addAnimation(view: red2, vaules: vaules2!, keyPath: "firstAnimation", animationPath: typeStr)
        
        fatherView.addSubview(red2)
        red2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: type.getWidth(), height: type.getWidth()))
            make.centerX.equalToSuperview()
        }
        
        let redPoint3 = CGPoint(x: fatherView.center.x + 20, y: fatherView.bounds.size.height/2.0)
        let red3 = self.setUpView(fatherView: fatherView, center: redPoint3,redWidth: type.getWidth());
        red3.tag = 10003

        self.addAnimation(view: red3, vaules: vaules3!, keyPath: "firstAnimation", animationPath: typeStr)
        
        fatherView.addSubview(red3)
        red3.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: type.getWidth(), height: type.getWidth()))
            make.centerX.equalToSuperview().offset(20)
        }
        
    }
    
    private class func setUpView(fatherView:UIView, center:CGPoint, redWidth:CGFloat) -> UIView{
        
        let animationView = UIView(frame: CGRect(x: center.x, y: center.y, width: redWidth, height: redWidth))
        animationView.backgroundColor = .gray
        animationView.layer.cornerRadius = redWidth/2.0
        animationView.clipsToBounds = true
//        fatherView.addSubview(animationView);
        return animationView;
    }
    
    private class func addAnimation(view:UIView, vaules:[Any],keyPath:String,animationPath:String){

        let animation = CAKeyframeAnimation(keyPath: animationPath)
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        animation.values = vaules
        animation.timingFunctions = [CAMediaTimingFunction(name: .linear),CAMediaTimingFunction(name: .linear),CAMediaTimingFunction(name: .linear),CAMediaTimingFunction(name: .linear)]
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        view.layer.add(animation, forKey: keyPath)
             
    }
    
    static func hideAnimation(fatherView:UIView){
        
        guard let red1 = fatherView.viewWithTag(10001),let red2 = fatherView.viewWithTag(10002),let red3 = fatherView.viewWithTag(10003) else {
            return
        }
        red1.removeFromSuperview()
        red2.removeFromSuperview()
        red3.removeFromSuperview()
    }
            
}
