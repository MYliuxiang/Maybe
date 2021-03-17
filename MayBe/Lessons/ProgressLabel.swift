//
//  ProgressLabel.swift
//  MayBe
//
//  Created by liuxiang on 2020/12/3.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit


class ProgressLabel: UILabel {

    var progress:CGFloat = 0.0{
        didSet{
            
            self.setNeedsDisplay()
        }
    }
    
    var fillColor:UIColor = .colorWithHexStr("#17E8CB")
    

//    override func setNeedsDisplay(_ rect: CGRect) {
//        super.setNeedsDisplay()
//        UIColor.red.set()
//        let fillRect = CGRect(x: 0, y: 0, width: self.bounds.width * progress, height: self.bounds.size.height)
//        UIRectFillUsingBlendMode(fillRect, .sourceIn)
//    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()

        fillColor.set()
//        UIColor.red.set()
        let fillRect = CGRect(x: 0, y: 0, width: self.bounds.width * progress, height: self.bounds.size.height)
        UIRectFillUsingBlendMode(fillRect, .sourceIn)

    }

   
}

