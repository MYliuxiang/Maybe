//
//  GTextBoderProgress.swift
//  MayBe
//
//  Created by liuxiang on 2021/1/27.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit

class GTextBoderProgress: UIView {

    var timer:DispatchSourceTimer?
    var lrcLab:YYLabel!
    
    var fillColor:UIColor = .colorWithHexStr("#17E8CB")
    var textColor:UIColor = .colorWithHexStr("#131616")
    
    var lines:[Line]! = [Line]()
    var labers:[YYLabel]! = [YYLabel]()
    var totalwidth:CGFloat! = 0
    var progerss:CGFloat! = 0{
        didSet{

            for label in labers {
                label.width = 0
            }
            var width = totalwidth * progerss
            for(idx,myline) in lines.enumerated() {
                let lab = labers[idx]
                if width <= myline.width {
                     lab.width = width
                    break
                }else{
                    lab.frame = CGRect(x: myline.x, y: myline.y, width: myline.width, height: myline.height)
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
        
        lrcLab = YYLabel()
        lrcLab.numberOfLines = 0
        addSubview(lrcLab)
        lrcLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0);
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerX.equalToSuperview()

        }
        
    }
    
    
    
    func configAnimation(text:String, totalTime:Double){
        
        
        if text.count == 0 {
            return
        }
        
        let attaStr = NSMutableAttributedString(string: text)
        attaStr.yy_font = .customName("SemiBold", size: 24)
        attaStr.yy_maximumLineHeight = 28
        attaStr.yy_minimumLineHeight = 28
        attaStr.yy_strokeWidth = -3
        attaStr.yy_strokeColor = .red
        attaStr.yy_color = .white
        attaStr.yy_alignment = .center
        let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
        let layout = YYTextLayout(container: container, text: attaStr)
        lrcLab.textLayout = layout
                        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(lrcLab)
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
            line.text = text.ex_substring(at: (yline?.range.location)!, length: (yline?.range.length)!)
            self.totalwidth += line.width
            lines.append(line)
        
            let label = YYLabel()
            let attaStr1 = NSMutableAttributedString(string: line.text!)
            attaStr1.yy_font = .customName("SemiBold", size: 24)
            attaStr1.yy_maximumLineHeight = 28
            attaStr1.yy_minimumLineHeight = 28
            attaStr1.yy_strokeWidth = -3
            attaStr1.yy_strokeColor = .white
            attaStr1.yy_alignment = .center
            attaStr1.yy_color = .red

           
            let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
            let layout = YYTextLayout(container: container, text: attaStr1)
            label.textLayout = layout
            lrcLab.addSubview(label)
            labers.append(label)
            label.lineBreakMode = .byClipping
            label.frame = CGRect(x: line.x, y: line.y, width: 0, height: line.height)
//            label.snp.makeConstraints { (make) in
//                make.left.equalToSuperview()
//            }
//            label.isHidden = true
        }
        
       anginAnimation(time: totalTime)
    
    
    }
    
    private func anginAnimation(time:Double){
       
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
        lrcLab.preferredMaxLayoutWidth = self.width
        
    }


}
