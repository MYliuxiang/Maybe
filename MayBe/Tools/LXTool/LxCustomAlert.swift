//
//  LxCustomAlert.swift
//  JZYZApp
//
//  Created by liuxiang on 2020/3/31.
//  Copyright © 2020 李江. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


enum LxCustomAlertType:Int {
    case alert = 0
    case sheet
}

class LxCustomAlert: NibView {
     
    lazy var lxmaskView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    var type:LxCustomAlertType! = .alert
    var offsetBotom:CGFloat! = 0.00
    var offsetTop:CGFloat! = 0.00

    var topVC:UIViewController?
    var dimissBlcok:(()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()

    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI(){
        lxmaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
    }
    
    func show(){
        if topVC == nil {
            UIApplication.shared.keyWindow?.addSubview(lxmaskView)
        }else{
            topVC?.view.addSubview(lxmaskView)
        }
        lxmaskView.addSubview(self)
        self.centerX = lxmaskView.centerX
        self.snp.makeConstraints { (make) in
            make.centerX.equalTo(lxmaskView);
        }
        showAnimation()
        let lxmisstap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(misstap))
        lxmisstap.delegate = self
        lxmaskView.addGestureRecognizer(lxmisstap)
        
        
    }
    
    func disMiss(){
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        hideAnimation()
        
    }
    
    @objc func misstap(){
        let manger = IQKeyboardManager.shared
        if manger.keyboardShowing{
            self.endEditing(true)
        }
        disMiss()
    }
    
    private func showAnimation(){
        
        switch type {
        case .alert:
            self.centerX = lxmaskView.centerX
            self.bottom = lxmaskView.top
            lxmaskView.layoutIfNeeded()

            self.alpha = 0;
            UIView.animate(withDuration: 0.35) {
                self.alpha = 1;
                if self.offsetTop == 0{
                    self.center = self.lxmaskView.center

                }else{
                    self.top = self.offsetTop

                }
                self.centerX = self.lxmaskView.centerX
                
            }
            
           
            break
        case .sheet:
            var bottomSafeAreaHeight:CGFloat? = 0
            if #available(iOS 11.0, *) {
                bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
            } else {
                // Fallback on earlier versions
            }
            
            lxmaskView.layoutIfNeeded()
            self.top = ScreenHeight

            UIView.animate(withDuration: 0.35) {
                self.bottom = self.lxmaskView.bottom - self.offsetBotom - (bottomSafeAreaHeight ?? 0)
            }
        
            break
        default:
            break
        }
    }
    
    private func hideAnimation(){
           switch type {
                  case .alert:
                    UIView.animate(withDuration: 0.35, animations: {
                        self.alpha = 0.0
                        self.lxmaskView.alpha = 0
                    }) { (finished) in
                        self.removeFromSuperview()
                        self.lxmaskView.removeFromSuperview()
                        if self.dimissBlcok != nil{
                            self.dimissBlcok!()
                               
                        }
                        
                    }
                      
                      break
                  case .sheet:
                    
                    lxmaskView.layoutIfNeeded()
                    UIView.animate(withDuration: 0.35, animations: {
                        self.top = ScreenHeight
                    }) { (finished) in
                        self.removeFromSuperview()
                        self.lxmaskView.removeFromSuperview()
                        if self.dimissBlcok != nil{
                            self.dimissBlcok!()

                        }
                    }
                      
                  
                      break
                  default:
                      break
                  }
       }
    

}

extension LxCustomAlert:UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self) ?? true {
            return false
        }
        return true
    }
    
}


