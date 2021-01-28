//
//  Video subtitles Video subtitles VideoSubTitlesView.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/23.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class VideoSubTitlesView: UIView {
    var subtitleL:YYLabel!
    var bgViews:[UIView]! = [UIView]()
    var timer:DispatchSourceTimer?
    var showtimer:DispatchSourceTimer?
    
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
        addSubview(subtitleL)
        
    }
    
    func configAnimation(subtitles:[String], totalTime:Double){
        
        //清除背景数组里面的背景
        for bgview in bgViews{
            bgview.removeFromSuperview()
        }
                
        if subtitles.count == 0 {
            subtitleL.text = ""
            return
        }
        
        subtitleL.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
                
        let str = subtitles.joined(separator: " ")
        print("vs---\(str)")

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
                
        guard let lines = layout?.lines else {
            return
        }
        
        var topView:UIView?
               
        for line in lines{
            let bgV = UIView()
            let top = (topView == nil ? line.top : topView!.bottom)
            bgV.backgroundColor = .colorWithHexStr("#17E8CB", alpha: 0.4)
            bgV.frame = CGRect(x: line.left - 4, y: top, width: 0, height: line.bottom - top)
            bgV.layer.cornerRadius = 4
            bgV.layer.masksToBounds = true
            topView = bgV
            insertSubview(bgV, at: 0)
            bgViews.append(bgV)
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
        
        var cecount:Double = 0
        let secondes:Double = time / 5 / 10 * 4
        showtimer = DispatchSource.makeTimerSource()
        showtimer?.schedule(deadline: DispatchTime.now(),repeating: secondes)
        showtimer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
              
                let attaStr = NSMutableAttributedString(string: str)
                attaStr.yy_font = .customName("SemiBold", size: 32)
                attaStr.yy_alignment = .center
                attaStr.yy_maximumLineHeight = 52
                attaStr.yy_minimumLineHeight = 52
                attaStr.yy_color = .clear
                let alpha = cecount / 10
                attaStr.yy_setColor(.colorWithHexStr("#131616", alpha:1), range: NSRange(location: 0, length:blackStr.count - subtitles[count].count))
                attaStr.yy_setColor(.colorWithHexStr("#131616", alpha:CGFloat(alpha)), range: NSRange(location: blackStr.count - subtitles[count].count, length: subtitles[count].count))
              
                let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
                let layout = YYTextLayout(container: container, text: attaStr)
                self.subtitleL.textLayout = layout
                
                cecount += 1;
                if(cecount > 10){
                    self.showtimer?.cancel()
                }
                
            }
        })
        showtimer?.resume()
                
        let attaStr = NSMutableAttributedString(string: str)
        attaStr.yy_font = .customName("SemiBold", size: 32)
        attaStr.yy_alignment = .center
        attaStr.yy_maximumLineHeight = 52
        attaStr.yy_minimumLineHeight = 52
        attaStr.yy_color = .clear
        attaStr.yy_setColor(.colorWithHexStr("#131616"), range: NSRange(location: 0, length: blackStr.count))
      
        let container = YYTextContainer(size: CGSize(width: self.size.width, height: 1000))
        let layout = YYTextLayout(container: container, text: attaStr)
//        subtitleL.textLayout = layout
                
       let range = NSRange(location: blackStr.count - subtitles[count].count  , length: subtitles[count].count)
        let rect = layout?.rect(for: YYTextRange(range: range))
        
        var animationView:UIView?

        for bgView in bgViews {
            if rect?.maxY == bgView.frame.maxY  {
                //说明在
                animationView = bgView
            }
        }
        
        guard let aniV = animationView else {
            return
        }
        
        UIView.animate(withDuration: time, delay: 0, options: .curveEaseIn) {
            aniV.frame = CGRect(x: aniV.frame.minX, y: aniV.frame.minY, width: rect!.maxX - aniV.frame.minX + 8, height: aniV.frame.height)
        } completion: { (complete) in
            
        }
                
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        subtitleL.preferredMaxLayoutWidth = self.width
        
    }
   

}
