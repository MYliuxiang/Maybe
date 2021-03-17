//
//  CardCycleView.swift
//  MayBe
//
//  Created by liuxiang on 2021/1/22.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit

class CardCycleView: UIView {

    let pointWidth:CGFloat = 5
    let color:UIColor = .colorWithHexStr("#C5D3D3")
    
    lazy var red1:UIView = {
        let animationView = UIView()
        animationView.backgroundColor = color
        animationView.layer.cornerRadius = pointWidth/2.0
        animationView.clipsToBounds = true
        return animationView;
    }()
    
    lazy var red2:UIView = {
        let animationView = UIView()
        animationView.backgroundColor = color
        animationView.layer.cornerRadius = pointWidth/2.0
        animationView.clipsToBounds = true
        return animationView;
    }()
    
    lazy var red3:UIView = {
        let animationView = UIView()
        animationView.backgroundColor = color
        animationView.layer.cornerRadius = pointWidth/2.0
        animationView.clipsToBounds = true
        return animationView;
    }()
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
               
        addSubview(red1)
        addSubview(red2)
        addSubview(red3)
        red1.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: pointWidth, height: pointWidth))
            make.centerX.equalToSuperview().offset(-9)
        }
        
        
        red2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: pointWidth, height: pointWidth))
            make.centerX.equalToSuperview()
        }
       
        red3.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: pointWidth, height: pointWidth))
            make.centerX.equalToSuperview().offset(9)
        }

    }
    
    func startAnimation(){
        
        let typeStr = "opacity"
        let vaules1 = [1,0.3,0.3,1];
        let vaules2 = [0.3,1,0.3,0.3];
        let vaules3 = [0.3,0.3,1,0.3];
        
        self.addAnimation(view: red1, vaules: vaules1, keyPath: "firstAnimation", animationPath: typeStr)
        self.addAnimation(view: red2, vaules: vaules2, keyPath: "firstAnimation", animationPath: typeStr)
        self.addAnimation(view: red3, vaules: vaules3, keyPath: "firstAnimation", animationPath: typeStr)
        
    }

    
    private  func setUpView(fatherView:UIView, center:CGPoint, redWidth:CGFloat) -> UIView{
        
        let animationView = UIView(frame: CGRect(x: center.x, y: center.y, width: redWidth, height: redWidth))
        animationView.backgroundColor = .gray
        animationView.layer.cornerRadius = redWidth/2.0
        animationView.clipsToBounds = true
        return animationView;
    }
    
    private  func addAnimation(view:UIView, vaules:[Any],keyPath:String,animationPath:String){

        let animation = CAKeyframeAnimation(keyPath: animationPath)
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        animation.values = vaules
        animation.timingFunctions = [CAMediaTimingFunction(name: .linear),CAMediaTimingFunction(name: .linear),CAMediaTimingFunction(name: .linear),CAMediaTimingFunction(name: .linear)]
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        view.layer.add(animation, forKey: keyPath)
             
    }
    
    func hideAnimation(fatherView:UIView){
        
        guard let red1 = fatherView.viewWithTag(10001),let red2 = fatherView.viewWithTag(10002),let red3 = fatherView.viewWithTag(10003) else {
            return
        }
        red1.removeFromSuperview()
        red2.removeFromSuperview()
        red3.removeFromSuperview()
    }
            

}
