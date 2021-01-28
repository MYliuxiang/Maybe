//
//  GProgressView.swift
//  MayBe
//
//  Created by liuxiang on 2021/1/27.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit

enum GTextType {
    case textnone,textborder
}

class GProgressView: UIView {

    
    var subtitleL:YYLabel!
    var timer:DispatchSourceTimer?
    
    var fillColor:UIColor = .colorWithHexStr("#17E8CB")
//    var type:GTextType = .textnone
//    var textColor:UIColor = .colorWithHexStr("#131616")
    
    
    var lines:[Line]! = [Line]()
    var labers:[ProgressLabel]! = [ProgressLabel]()
    var totalwidth:CGFloat! = 0
    var progerss:CGFloat! = 0{
        didSet{
            for lab in labers {
                lab.isHidden = false
            }
            subtitleL.textColor = .clear
            var width = totalwidth * progerss
            for(idx,myline) in lines.enumerated() {
                let lab = labers[idx]
                if width <= myline.width {
                    lab.progress = ((self.width - myline.width) / 2 + width) / self.width
                    break
                }else{
                    width =  width - myline.width
                }
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        
        subtitleL = YYLabel()
        subtitleL.numberOfLines = 0
        subtitleL.backgroundColor = .clear
        addSubview(subtitleL)
        
    }
    
    func configAnimation(subtitles:[String], totalTime:Double){
       
        if subtitles.count == 0 {
            subtitleL.text = ""
            return
        }
        subtitleL.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
                
        let str = subtitles.joined(separator: " ")
        let attaStr = NSMutableAttributedString(string: str)
        attaStr.yy_font = .customName("SemiBold", size: 24)
        attaStr.yy_maximumLineHeight = 28
        attaStr.yy_minimumLineHeight = 28
        attaStr.yy_color = .colorWithHexStr("#131616")
        let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
        let layout = YYTextLayout(container: container, text: attaStr)
        subtitleL.textLayout = layout
                        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(subtitleL)
        }
        guard layout?.lines != nil else {
            return
        }
        
        lines.removeAll()
        for lab in labers {
            lab.removeFromSuperview()
        }
        labers.removeAll()
        totalwidth = 0
        
        for indx in 0 ..< (layout?.lines.count)! {
            let yline =  layout?.lines[indx]
            var line:Line = Line()
            line.x = yline?.left
            line.y = yline?.top
            line.width = yline?.width
            line.height = yline?.height
            line.text = str.ex_substring(at: (yline?.range.location)!, length: (yline?.range.length)!)
            self.totalwidth += line.width
            lines.append(line)
        
            let label = ProgressLabel()
            label.fillColor = fillColor
            let attaStr1 = NSMutableAttributedString(string: line.text!)
            attaStr1.yy_font = .customName("SemiBold", size: 24)
            attaStr1.yy_maximumLineHeight = 28
            attaStr1.yy_minimumLineHeight = 28
            attaStr1.yy_color = .colorWithHexStr("#131616")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 20
            attaStr1.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attaStr1.length))
            let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
            _ = YYTextLayout(container: container, text: attaStr1)
            label.attributedText = attaStr1
            
            self.subtitleL.addSubview(label)
            labers.append(label)
            label.lineBreakMode = .byClipping
            label.frame = CGRect(x: 0, y: line.y, width: self.width, height: line.height)
            label.isHidden = true
        }
        
        anginAnimation(time: totalTime)
                        
    }
    
   
    
    
   private  func anginAnimation(time:Double){
      
        var count:Double = 0
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: DispatchTime.now(),repeating: 0.002)
        self.timer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
                 // 回调 回到了主线程
                self.progerss = CGFloat(count / time)
                count = count + 0.002
                if count == time{
                    self.timer?.cancel()
                }
              }
        })

        self.timer?.resume()
                
        
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        subtitleL.preferredMaxLayoutWidth = self.width
        
    }

}
