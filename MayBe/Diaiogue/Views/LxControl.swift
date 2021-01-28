//
//  LxControl.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/12.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LxControl: UIControl {
    
    override var isSelected: Bool{
        didSet{
            
        }
    }
    var path:UIBezierPath?
      let sharelayer = CAShapeLayer()
    override init(frame: CGRect) {
             super.init(frame: frame)
             setUI()
         }
       
       override func draw(_ rect: CGRect) {
           superview?.draw(rect)
           path = UIBezierPath.init(arcCenter: CGPoint(x: self.width / 2, y: self.height + self.width - 120), radius: self.width, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi), clockwise: false)
           path?.addLine(to: CGPoint(x: 0, y: self.height))
           path?.addLine(to: CGPoint(x: self.width,y:self.height))
           path?.close()
//           path?.stroke()
//           path?.fill()
                  
       
           sharelayer.fillColor = UIColor.green.cgColor
           sharelayer.strokeColor = UIColor.green.cgColor
           sharelayer.path = path?.cgPath
//           sharelayer.lineWidth = 1
//           self.layer.addSublayer(sharelayer)
        self.layer.mask = sharelayer
        sharelayer.backgroundColor = UIColor.white.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
           
       }
       
       func setUI(){
 
           self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
           
       }
    
    @objc func touchUpInside(){
        
        print("点击了")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if (path?.cgPath.contains(point))!{
            return self
        }else{
            return nil
        }
    }
              
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setUI()
       }

}
