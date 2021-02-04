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
        attaStr.yy_font = .customName("Black", size: 40)
        attaStr.yy_alignment = .center
        attaStr.yy_maximumLineHeight = 56
        attaStr.yy_minimumLineHeight = 56
        attaStr.yy_lineSpacing = -14
        attaStr.yy_color = .colorWithHexStr("#131616")
        let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
        let layout = YYTextLayout(container: container, text: attaStr)
        subtitleL.textLayout = layout
                        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(subtitleL)
        }
        guard let yylayouts = layout?.lines else {
            return
        }
        
        lines.removeAll()
        for lab in labers {
            lab.removeFromSuperview()
        }
        labers.removeAll()
        totalwidth = 0
        
        var topView:UIView?
        
        
        for (idx,syline) in yylayouts.enumerated(){
           
            let bgV = UIView()
            bgV.frame = CGRect(x: syline.bounds.minX - 4, y: syline.bounds.minY, width: syline.bounds.width, height: syline.bounds.height)
            if idx == yylayouts.count - 1 {
                bgV.frame = CGRect(x: syline.bounds.minX - 4, y: syline.bounds.minY, width: syline.bounds.width + 8, height: syline.bounds.height)
            }
            bgV.backgroundColor = .colorWithHexStr("#17E8CB")
            bgV.layer.cornerRadius = 4
            bgV.layer.masksToBounds = true
            bgV.alpha = 1
            insertSubview(bgV, at: 0)
            totalwidth += bgV.bounds.width
            bgViews.append(bgV)
        }
        
        var progress:CGFloat = 0
        let secondes = 0.02
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: DispatchTime.now(),repeating: secondes)
        self.timer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
                 // 回调 回到了主线程
                progress += 0.02
                self.displayProgress(prog: progress)
               
              }
        })

        self.timer?.resume()
         
    }
    
    func displayProgress(prog:CGFloat){
        
        var width = totalwidth * prog
        
        for(idx,myline) in lines.enumerated() {
            let bgView = bgViews[idx]
            if width <= myline.width {
                bgView.width = width
                break
            }else{
                bgView.frame = CGRect(x: myline.x, y: myline.y, width: myline.width, height: myline.height)
                width =  width - myline.width
            }
        }
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
