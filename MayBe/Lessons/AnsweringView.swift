//
//  AnsweringView.swift
//  MayBe
//
//  Created by liuxiang on 2020/12/23.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class AnsweringView: UIView {

    var labels:[YYLabel]! = [YYLabel]()
    
    var fanswer:String?
    
    var ferrIdx:[Int] = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
   
    
    func showAnser(anser:String?,arrIdx:[Int]){
        self.fanswer = anser
        self.ferrIdx = arrIdx
        //清除背景数组里面的背景
        for label in labels{
            label.removeFromSuperview()
        }
        labels.removeAll()
        guard let anserStr = anser else {
            return
        }
       
        let attaStr = NSMutableAttributedString(string: anserStr)
        attaStr.yy_font = .customName("SemiBold", size: 32)
        attaStr.yy_alignment = .center
        attaStr.yy_maximumLineHeight = 52
        attaStr.yy_minimumLineHeight = 52
        attaStr.yy_color = .colorWithHexStr("#131616")
        let container = YYTextContainer(size: CGSize(width: self.size.width, height: 200))
//        container.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        guard let layout = YYTextLayout(container: container, text: attaStr) else {
            return
        }
        

       
        for line in layout.lines {
       
            let lineText = anserStr.ex_substring(at: line.range.location, length: line.range.length)
            let label = YYLabel()
            let attaStr1 = NSMutableAttributedString(string: lineText)
            attaStr1.yy_font = .customName("SemiBold", size: 32)
            attaStr1.yy_alignment = .center
            attaStr1.yy_maximumLineHeight = 52
            attaStr1.yy_minimumLineHeight = 52
            attaStr1.yy_color = .colorWithHexStr("#131616")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 20
            attaStr1.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attaStr1.length))
            let container = YYTextContainer(size: CGSize(width: self.size.width, height: 200))
            container.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            let layout = YYTextLayout(container: container, text: attaStr1)
//            label.attributedText = attaStr1
            label.textLayout = layout
            label.textAlignment = .center
            label.backgroundColor = .white
            label.layer.cornerRadius = 16
            label.layer.masksToBounds = true

            addSubview(label)
            labels.append(label)
            label.lineBreakMode = .byClipping
            label.frame = CGRect(x: line.left - 10, y: line.top, width: line.width + 20, height: line.height)
        }

                
        
       
        
    }

}
