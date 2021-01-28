//
//  LxTestView.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/12.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LxTestView: UIView {

   var path:UIBezierPath?
   let sharelayer = CAShapeLayer()

   var button:UIButton?
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
        path?.stroke()
        path?.fill()
               
    
        sharelayer.fillColor = UIColor.green.cgColor
        sharelayer.strokeColor = UIColor.green.cgColor
        sharelayer.path = path?.cgPath
        sharelayer.lineWidth = 1
        self.layer.addSublayer(sharelayer)
        
    }
    
    func setUI(){
//
       
        button = UIButton.init(type: .custom)
        button?.frame = CGRect(x: 30, y: 30, width: 50, height: 50)
        button?.addTarget(self, action: #selector(beginRecordVoice), for: .touchDown)
        button?.addTarget(self, action: #selector(endRecordVoice), for: .touchUpInside)
        button?.addTarget(self, action: #selector(cancelRecordVoice), for: .touchUpOutside)
        button?.addTarget(self, action: #selector(cancelRecordVoice), for: .touchCancel)
        button?.addTarget(self, action: #selector(remindDragExit), for: .touchDragExit)
        button?.addTarget(self, action: #selector(remindDragEnter), for: .touchDragEnter)
//        button?.addTarget(self, action: #selector(touchMoveDrawView), for: .touchDragInside)
        button?.addTarget(self, action: #selector(touchMoveDrawOutsideView), for: .touchDragOutside)

        self.addSubview(button!)
        button?.backgroundColor = .yellow
        self.layer.masksToBounds = true
        
        
    }
    
    @objc func touchMoveDrawView(sender: AnyObject?,event:UIEvent){
            let button = sender as! UIButton
            let touch:UITouch = (event.touches(for: button)?.first)!
            let location = touch.location(in: self);
            print("inside","x:"+String(describing: location.x)+",y:"+String(describing: location.y));
            
        }
    
    @objc func touchMoveDrawOutsideView(sender: AnyObject?,event:UIEvent){
               let button = sender as! UIButton
               let touch:UITouch = (event.touches(for: button)?.first)!
               let location = touch.location(in: self);
               print("outside","x:"+String(describing: location.x)+",y:"+String(describing: location.y));
//        if CGPathContainsPoint()
//        if CGPath.contains(path!.cgPath){
//
//        }
        if (path?.cgPath.contains(location))!{
            print("进入圆形")
             path = UIBezierPath.init(arcCenter: CGPoint(x: self.width / 2, y: self.height + self.width - 120), radius: self.width + 10, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi), clockwise: false)
            sharelayer.path = path?.cgPath

        }else{
            print("离开圆形")
             path = UIBezierPath.init(arcCenter: CGPoint(x: self.width / 2, y: self.height + self.width - 120), radius: self.width, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi), clockwise: false)
            sharelayer.path = path?.cgPath

        }

          
    }
   
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print(point)
//        return button
//    }
//
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        print("inside:",point)
//        return true
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches{
            
            //获取用户点击的坐标
            var point = (touch as AnyObject).location(in: self)
            print(point)
            //返回在图层层次中包含point的view.layer的最远子代，即获取到用户点击的View的layer
            let layer = self.layer.hitTest(point)
            
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()

    }

}

extension LxTestView{
    
    /// 开始录音
       @objc private func beginRecordVoice() {
          //
        print("按下按钮")
        AudioServicesPlaySystemSound(1520);


       }
       
       /// 停止录音
       @objc private func endRecordVoice() {
          print("松开手指")
        
       }
       
       /// 取消录音
       @objc private func cancelRecordVoice() {
        print("取消")
       }
       
       /// 上划取消录音
       @objc private func remindDragExit() {
        print("手指离开按钮")
       }
       
       /// 下滑继续录音
       @objc private func remindDragEnter() {
        print("手指重新进入按钮")

       }
}



