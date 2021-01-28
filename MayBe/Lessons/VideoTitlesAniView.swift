//
//  VideoTitlesAniView.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/30.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class VideoTitlesAniView: UIView {

    
    var subtitleL:YYLabel!
    var bgViews:[UIView]! = [UIView]()
    var timer:DispatchSourceTimer?
    var showtimer:DispatchSourceTimer?
    
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
//                     lab.width =  (self.width - myline.width) / 2 + width
                    lab.progress = ((self.width - myline.width) / 2 + width) / self.width
                    break
                }else{
//                    lab.frame = CGRect(x: 0, y: myline.y, width: self.width, height: myline.height)
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
        
        //清除背景数组里面的背景
        for bgview in bgViews{
            bgview.removeFromSuperview()
        }
        bgViews.removeAll()
        if subtitles.count == 0 {
            subtitleL.text = ""
            return
        }
        subtitleL.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
                
        let str = subtitles.joined(separator: " ")
        let attaStr = NSMutableAttributedString(string: str)
        attaStr.yy_font = .customName("SemiBold", size: 32)
        attaStr.yy_alignment = .center
        attaStr.yy_maximumLineHeight = 52
        attaStr.yy_minimumLineHeight = 52
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
            let attaStr1 = NSMutableAttributedString(string: line.text!)
            attaStr1.yy_font = .customName("SemiBold", size: 32)
            attaStr1.yy_alignment = .center
            attaStr1.yy_maximumLineHeight = 52
            attaStr1.yy_minimumLineHeight = 52
            attaStr1.yy_color = .colorWithHexStr("#131616")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 20
            attaStr1.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attaStr1.length))
            let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
//            container.insets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
            _ = YYTextLayout(container: container, text: attaStr1)
//            label.textLayout = layout
            label.attributedText = attaStr1
            label.textAlignment = .center
            
//            label.attributedText = attaStr1
//            label.backgroundColor = .colorWithHexStr("#17E8CB",alpha:0.4)
            self.subtitleL.addSubview(label)
            labers.append(label)
            label.lineBreakMode = .byClipping
            label.frame = CGRect(x: 0, y: line.y, width: self.width, height: line.height)
            label.isHidden = true
//            label.backgroundColor = .yellow
        }

                
        
        var topView:UIView?
        
        var location = 0
        for (idx,subStr) in subtitles.enumerated() {
            let str = subStr
            let range = NSRange(location:  location , length: str.count)
            let rect = layout?.rect(for: YYTextRange(range: range))
            location += str.count + 1
            
            let bgV = UIView()
            var left:CGFloat = 0
            var top:CGFloat = 0
            
            var isfirst:Bool = false
            
            if topView == nil {
                top = 0;
                left = rect!.minX - 4.0
                isfirst = true
            }else if rect!.maxY == topView!.bottom{
                top = topView!.top
                left = topView!.right
            }else{
                top = topView!.bottom
                left = rect!.minX - 4
                isfirst = true
            }
        
            bgV.frame = CGRect(x: left, y: top, width: rect!.width + 8, height: rect!.maxY - top)
            bgV.backgroundColor = .colorWithHexStr("#17E8CB")
            bgV.alpha = 0.0
            insertSubview(bgV, at: 0)
            bgViews.append(bgV)
            if topView == nil {
                bgV.snp.makeConstraints { (make) in
                    make.left.equalTo(rect!.minX - 4.0)
                    make.height.equalTo(rect!.maxY - top)
                    make.top.equalTo(0)
                    make.width.equalTo(rect!.width + 7)
                }
            }else if rect!.maxY == topView!.bottom{
                bgV.snp.makeConstraints { (make) in
                    make.left.equalTo(topView!.snp.right)
                    make.height.equalTo(rect!.maxY - top)
                    make.top.equalTo(top)
                    make.width.equalTo(rect!.width + 8)
                }
            }else{
                
            }
            
            
            //绘制圆角
            if isfirst {
                let maskPath = UIBezierPath(roundedRect: bgV.bounds, byRoundingCorners:[UIRectCorner.topLeft, UIRectCorner.bottomLeft] , cornerRadii: CGSize(width: 4, height: 4))
                let maskLayer = CAShapeLayer()
                maskLayer.frame = bgV.bounds
                maskLayer.path = maskPath.cgPath
                bgV.layer.mask = maskLayer
                if topView != nil {
                    let maskPath = UIBezierPath(roundedRect: topView!.bounds, byRoundingCorners:[UIRectCorner.topRight, UIRectCorner.bottomRight] , cornerRadii: CGSize(width: 4, height: 4))
                    let maskLayer = CAShapeLayer()
                    maskLayer.frame = topView!.bounds
                    maskLayer.path = maskPath.cgPath
                    topView!.layer.mask = maskLayer
                }
            }
            
            if idx == subtitles.count - 1 {
                let maskPath = UIBezierPath(roundedRect: bgV.bounds, byRoundingCorners:[UIRectCorner.topRight, UIRectCorner.bottomRight] , cornerRadii: CGSize(width: 4, height: 4))
                let maskLayer = CAShapeLayer()
                maskLayer.frame = bgV.bounds
                maskLayer.path = maskPath.cgPath
                bgV.layer.mask = maskLayer
            }
            
            topView = bgV
            
        }

        var count = 0
        let secondes = totalTime / Double(subtitles.count)
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: DispatchTime.now(),repeating: secondes)
        self.timer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
                 // 回调 回到了主线程
                //显示文字
                self.showSubtitle(subtitles:subtitles , time: secondes,count: count)
                count = count + 1
                if count == subtitles.count{
                    self.timer?.cancel()
                }
              }
        })

        self.timer?.resume()
                
        
    }
    
    func showSubtitle(subtitles:[String], time:Double,count:Int){
        
        let str = subtitles.joined(separator: " ")
        let blackStr = Array(subtitles[0...count]).joined(separator: " ")
                
        self.bgViews[count].alpha = 0.4
        let attaStr = NSMutableAttributedString(string: str)
        attaStr.yy_font = .customName("SemiBold", size: 32)
        attaStr.yy_alignment = .center
        attaStr.yy_maximumLineHeight = 52
        attaStr.yy_minimumLineHeight = 52
        attaStr.yy_color = .clear
        attaStr.yy_setColor(.colorWithHexStr("#131616", alpha:1), range: NSRange(location: 0, length:blackStr.count - subtitles[count].count))
        attaStr.yy_setColor(.colorWithHexStr("#131616", alpha:1), range: NSRange(location: blackStr.count - subtitles[count].count, length: subtitles[count].count))
        let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
        let layout = YYTextLayout(container: container, text: attaStr)
        self.subtitleL.textLayout = layout
        
        return
                        
        var cecount:Double = 0
        let secondes:Double = time / 5 / 15 * 4
       
        showtimer = DispatchSource.makeTimerSource()
        showtimer?.schedule(deadline: DispatchTime.now(),repeating: secondes)
        showtimer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
              
                let alpha = cecount / 10 / 5 * 4
                self.bgViews[count].alpha =  CGFloat(alpha * 0.4)
                let attaStr = NSMutableAttributedString(string: str)
                attaStr.yy_font = .customName("SemiBold", size: 32)
                attaStr.yy_alignment = .center
                attaStr.yy_maximumLineHeight = 52
                attaStr.yy_minimumLineHeight = 52
                attaStr.yy_color = .clear
                attaStr.yy_setColor(.colorWithHexStr("#131616", alpha:1), range: NSRange(location: 0, length:blackStr.count - subtitles[count].count))
                attaStr.yy_setColor(.colorWithHexStr("#131616", alpha:CGFloat(alpha)), range: NSRange(location: blackStr.count - subtitles[count].count, length: subtitles[count].count))
                let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
                let layout = YYTextLayout(container: container, text: attaStr)
                self.subtitleL.textLayout = layout
                
                cecount += 1;
                if(cecount > 15){
                    self.showtimer?.cancel()
                }
            }
        })
        showtimer?.resume()
                
    }
    
    
    func anginAnimation(time:Double){
        if self.timer == nil{
            
            return
        }
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
