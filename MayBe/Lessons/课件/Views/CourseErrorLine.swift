//
//  CourseErrorLine.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/10.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CourseErrorLine: UIView {
    
    let radius:CGFloat = 10
    
    let margin:CGFloat = 10
    
    let otherRadius:CGFloat = 24
    var touchEnable:Bool = false
    
   
    
    var touchBlock:(()->())?
    
    var isDrawLine:Bool = true{
        didSet{
            
            guard let array = self.layer.sublayers else {
                return
            }
            for lay in array {
                lay.removeFromSuperlayer()
            }
        }
    }

       
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tap))
        self.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap() {
        if self.touchBlock != nil {
            self.touchBlock!()
        }
        return
    }
   
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if touchEnable {
            return self
        }
        return nil
    }
    
    
    func drawLineTwo(firstPoints:[CGPoint],secondPoints:[CGPoint]? = nil){
        if let array = self.layer.sublayers{
            for lay in array {
                lay.removeFromSuperlayer()
            }
        }
        
        guard firstPoints.count == 2 else {
            guard let array = self.layer.sublayers else {
                return
            }
            for lay in array {
                lay.removeFromSuperlayer()
            }
            return
        }
        
        let fist = firstPoints[0]
        let second = firstPoints[1]
        
       
        let linePath = UIBezierPath.init()
        linePath.move(to: fist)
        linePath.addArc(withCenter: CGPoint(x: fist.x - radius, y: fist.y), radius: radius, startAngle: CGFloat(0/180.0 * Float.pi), endAngle: CGFloat(90/180.0 * Float.pi), clockwise: true)
        linePath.addLine(to: CGPoint.init(x: margin + radius, y: fist.y + radius))
        linePath.addArc(withCenter: CGPoint(x: margin + radius, y: fist.y + radius + radius), radius: radius, startAngle: CGFloat(270/180.0 * Float.pi), endAngle: CGFloat(180/180.0 * Float.pi), clockwise: false)
        
        linePath.addLine(to: CGPoint.init(x: margin, y: second.y - radius))

        linePath.addArc(withCenter: CGPoint(x: margin + radius, y: second.y - radius), radius: radius, startAngle: CGFloat(180/180.0 * Float.pi), endAngle: CGFloat(90/180.0 * Float.pi), clockwise: false)
        
        linePath.addLine(to: CGPoint.init(x: second.x, y: second.y))
        linePath.lineWidth = 1
        linePath.lineCapStyle = .butt
        linePath.lineJoinStyle = .bevel
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.colorWithHexStr("#C5CED3").cgColor
        shapeLayer.path = linePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        
        guard secondPoints?.count == 2 else {
            return
        }
        
        guard let fists = secondPoints?[0]  else {
            return
        }
        
        guard let seconds = secondPoints?[1]  else {
            return
        }
                
        let linePath1 = UIBezierPath.init()
        linePath1.move(to: fists)
        linePath1.addArc(withCenter: CGPoint(x: fists.x + radius, y: fists.y), radius: radius, startAngle: CGFloat(180/180.0 * Float.pi), endAngle: CGFloat(90/180.0 * Float.pi), clockwise: false)
        linePath1.addLine(to: CGPoint.init(x:self.width - margin - radius, y: fists.y + radius))
        linePath1.addArc(withCenter: CGPoint(x: self.width - margin - radius, y: fists.y + radius + radius), radius: radius, startAngle: CGFloat(270/180.0 * Float.pi), endAngle: CGFloat(0/180.0 * Float.pi), clockwise: true)
        
        linePath1.addLine(to: CGPoint.init(x: self.width - margin, y: seconds.y - radius))

        linePath1.addArc(withCenter: CGPoint(x: self.width - margin - radius, y: seconds.y - radius), radius: radius, startAngle: CGFloat(0/180.0 * Float.pi), endAngle: CGFloat(90/180.0 * Float.pi), clockwise: true)
        
        linePath1.addLine(to: CGPoint.init(x: seconds.x, y: seconds.y))
        linePath1.lineWidth = 1
        linePath1.lineCapStyle = .butt
        linePath1.lineJoinStyle = .bevel
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.lineWidth = 1
        shapeLayer1.strokeColor = UIColor.colorWithHexStr("#C5CED3").cgColor

        shapeLayer1.path = linePath1.cgPath
        shapeLayer1.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer1)
                
    }
   
    func drawLineOnly(firstPoint:CGPoint,firstFrame:CGRect,secondPoint:CGPoint? = nil,secondFrame:CGRect? = nil){
            
        
        if let array = self.layer.sublayers{
            for lay in array {
                lay.removeFromSuperlayer()
            }
        }
        
//        let redView = UIView()
//        let grayView = UIView()
//        self.addSubview(redView)
//        self.addSubview(grayView)
//        redView.backgroundColor = .red
//        grayView.backgroundColor = .green
//        redView.layer.masksToBounds = true
//        redView.layer.cornerRadius = otherRadius
//        grayView.layer.masksToBounds = true
//        grayView.layer.cornerRadius = otherRadius
//
//        redView.frame = firstFrame
//
        
        if firstPoint.x <= firstFrame.maxX {
            let linePath = UIBezierPath.init()
            linePath.move(to: firstPoint)
           
            var otherHeight:Float = 0
            
            if fabsf(Float(firstPoint.x - firstFrame.minX)) < Float(otherRadius) {
                
                let rwidth = fabsf(Float(firstPoint.x - firstFrame.minX))
                 otherHeight = sqrtf(powf(Float(otherRadius), 2) -
                                        powf((Float(otherRadius) - rwidth), 2))
                linePath.addLine(to: CGPoint.init(x: firstPoint.x, y: firstFrame.minY - CGFloat(otherHeight) + otherRadius))
            }else if fabsf(Float(firstPoint.x - firstFrame.maxX)) < Float(otherRadius){
                let rwidth = fabsf(Float(firstPoint.x - firstFrame.maxX))
                 otherHeight = sqrtf(Float(otherRadius) * Float(otherRadius) - (Float(otherRadius) - rwidth) * (Float(otherRadius) - rwidth))
                linePath.addLine(to: CGPoint.init(x: firstPoint.x, y: firstFrame.minY - CGFloat(otherHeight) + otherRadius))
            }else{
                linePath.addLine(to: CGPoint.init(x: firstPoint.x, y: firstFrame.minY))
            }
                                    
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1
            shapeLayer.lineJoin = .bevel
            shapeLayer.lineCap = .butt
            shapeLayer.strokeColor = UIColor.colorWithHexStr("#C5CED3").cgColor

            shapeLayer.path = linePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(shapeLayer)
            
        }else{
            
            let linePath = UIBezierPath.init()
            let minWidth:CGFloat = firstPoint.x -  firstFrame.maxX < radius ? firstFrame.maxX + radius : firstPoint.x
            linePath.move(to: CGPoint(x: minWidth, y: firstPoint.y))
            linePath.addLine(to: CGPoint.init(x: minWidth, y: (firstFrame.minY + firstFrame.height / 2) - radius))
            linePath.addArc(withCenter: CGPoint(x: minWidth - radius, y: firstFrame.minY + firstFrame.height / 2 - radius), radius: radius, startAngle: CGFloat(0/180.0 * Float.pi), endAngle: CGFloat(90/180.0 * Float.pi), clockwise: true)
            linePath.addLine(to: CGPoint.init(x: firstFrame.maxX, y: firstFrame.minY + firstFrame.height / 2))
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1
            shapeLayer.lineJoin = .bevel
            shapeLayer.lineCap = .butt
            shapeLayer.strokeColor = UIColor.colorWithHexStr("#C5CED3").cgColor
            shapeLayer.path = linePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(shapeLayer)
            
        }
        
        
        guard (secondPoint != nil) else {
            return
        }
        
        guard  (secondFrame != nil) else {
            return
        }
        
//        grayView.frame = secondFrame!
        
        let linePath1 = UIBezierPath.init()

        if secondPoint!.x >= firstFrame.maxX + radius {
            linePath1.move(to: secondPoint!)
            
            if secondPoint!.x < secondFrame!.minX  {
                
                let minx:CGFloat = secondFrame!.minX -  secondPoint!.x < radius ? secondFrame!.minX - radius : secondPoint!.x
                linePath1.move(to: CGPoint(x: minx, y: secondPoint!.y))
                linePath1.addArc(withCenter: CGPoint(x: minx + radius, y: secondFrame!.minY + secondFrame!.height / 2.0 - radius), radius: radius, startAngle: CGFloat(180/180.0 * Float.pi), endAngle: CGFloat(90/180.0 * Float.pi), clockwise: false)
                linePath1.addLine(to: CGPoint(x: secondFrame!.minX, y:secondFrame!.minY + secondFrame!.height / 2.0))
                
            }else{
                
                linePath1.move(to: secondPoint!)
                var otherHeight:Float = 0
                if fabsf(Float(secondPoint!.x - secondFrame!.minX)) < Float(otherRadius) {
                    let rwidth = fabsf(Float(secondPoint!.x - secondFrame!.minX))
                     otherHeight = sqrtf(powf(Float(otherRadius), 2) -
                                            powf((Float(otherRadius) - rwidth), 2))
                    linePath1.addLine(to: CGPoint.init(x: secondPoint!.x, y: secondFrame!.minY - CGFloat(otherHeight) + otherRadius))
                }else if fabsf(Float(secondPoint!.x - secondFrame!.maxX)) < Float(otherRadius){
                    let rwidth = fabsf(Float(secondPoint!.x - secondFrame!.maxX))
                     otherHeight = sqrtf(Float(otherRadius) * Float(otherRadius) - (Float(otherRadius) - rwidth) * (Float(otherRadius) - rwidth))
                    linePath1.addLine(to: CGPoint.init(x: secondPoint!.x, y: secondFrame!.minY - CGFloat(otherHeight) + otherRadius))
                }else{
                    
                    linePath1.addLine(to: CGPoint.init(x: secondPoint!.x, y: secondFrame!.minY))
                    
                }
                
                
            }
                                   
            
        }else{
                        
            linePath1.move(to: secondPoint!)
            linePath1.addArc(withCenter: CGPoint(x: secondPoint!.x + radius, y: secondPoint!.y), radius: radius, startAngle: CGFloat(180/180.0 * Float.pi), endAngle: CGFloat(90/180.0 * Float.pi), clockwise: false)
            if firstFrame.maxX > secondFrame!.minX {
               
                if firstFrame.maxX >= secondFrame!.maxX{
                    //从最右边过去
                    linePath1.addLine(to: CGPoint(x: firstFrame.maxX, y: secondPoint!.y + radius))
                    linePath1.addArc(withCenter: CGPoint(x: firstFrame.maxX, y: secondPoint!.y + 2 * radius), radius: radius, startAngle: CGFloat(270/180.0 * Float.pi), endAngle: CGFloat(0/180.0 * Float.pi), clockwise: true)
                    
                    linePath1.addLine(to: CGPoint(x: firstFrame.maxX + radius, y: secondFrame!.minY + secondFrame!.height / 2.0 - radius))
                    linePath1.addArc(withCenter: CGPoint(x: firstFrame.maxX, y: secondFrame!.minY + secondFrame!.height / 2.0 - radius), radius: radius, startAngle: CGFloat(0/180.0 * Float.pi), endAngle: CGFloat(90/180.0 * Float.pi), clockwise: true)
                }else if secondFrame!.maxX - firstFrame.maxX - radius  <= otherRadius{
                    
                    linePath1.addArc(withCenter: CGPoint(x: firstFrame.maxX, y: secondPoint!.y + 2 * radius), radius: radius, startAngle: CGFloat(270/180.0 * Float.pi), endAngle: CGFloat(0/180.0 * Float.pi), clockwise: true)
                    //在右边圆角上面
                    let rwidth = fabsf(Float(secondFrame!.maxX - firstFrame.maxX - radius))
                    let otherHeight = sqrtf(Float(otherRadius) * Float(otherRadius) - (Float(otherRadius) - rwidth) * (Float(otherRadius) - rwidth))
                    linePath1.addLine(to: CGPoint.init(x: firstFrame.maxX + radius, y: secondFrame!.minY - CGFloat(otherHeight) + otherRadius))
                                    
                    
                }else if firstFrame.maxX + radius - secondFrame!.minX <= otherRadius {
                    
                    linePath1.addArc(withCenter: CGPoint(x: firstFrame.maxX, y: secondPoint!.y + 2 * radius), radius: radius, startAngle: CGFloat(270/180.0 * Float.pi), endAngle: CGFloat(0/180.0 * Float.pi), clockwise: true)
                    
                    let rwidth = fabsf(Float(firstFrame.maxX + radius - secondFrame!.minX))
                    let otherHeight = sqrtf(Float(otherRadius) * Float(otherRadius) - (Float(otherRadius) - rwidth) * (Float(otherRadius) - rwidth))
                    linePath1.addLine(to: CGPoint.init(x: firstFrame.maxX + radius, y: secondFrame!.minY - CGFloat(otherHeight) + otherRadius))
                    
                }else{
                    
                    linePath1.addArc(withCenter: CGPoint(x: firstFrame.maxX + radius, y: secondPoint!.y + 2 * radius), radius: radius, startAngle: CGFloat(270/180.0 * Float.pi), endAngle: CGFloat(0/180.0 * Float.pi), clockwise: true)
                    linePath1.addLine(to: CGPoint(x: firstFrame.maxX + radius + radius, y: secondFrame!.minY))
                    
                }
              

            }else{
                
                // 第一个的最右边 小于第二个的最左边 ok
                linePath1.addLine(to: CGPoint(x: secondFrame!.minX + otherRadius - radius, y: secondPoint!.y + radius))
                linePath1.addArc(withCenter: CGPoint(x: secondFrame!.minX + otherRadius - radius, y: secondPoint!.y + 2 * radius), radius: radius, startAngle: CGFloat(270/180.0 * Float.pi), endAngle: CGFloat(0/180.0 * Float.pi), clockwise: true)
                linePath1.addLine(to:CGPoint(x: secondFrame!.minX + otherRadius, y: secondFrame!.minY))
                
            }
            
        }
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.lineWidth = 1
        shapeLayer1.lineJoin = .bevel
        shapeLayer1.lineCap = .butt
        shapeLayer1.strokeColor = UIColor.colorWithHexStr("#C5CED3").cgColor

        shapeLayer1.path = linePath1.cgPath
        shapeLayer1.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer1)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
              
    }

}
