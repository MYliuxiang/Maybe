//
//  CardView.swift
//  MayBe
//
//  Created by liuxiang on 2021/1/22.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit


typealias MasktapBlock = () -> Void

class CardView: UIView {

    
    
    var maskBlock:MasktapBlock?
    
    var countimer:DispatchSourceTimer?

    
    lazy var timerL:UILabel = {
        let label = UILabel();
        label.font = .customName("Regular", size: 64);
        label.textColor = .colorWithHexStr("#17E8CB");
        return label;
    }()
   
    lazy var timerTL:YYLabel = {
        let label = YYLabel();
        label.font = .customName("Black", size: 28);
        label.textColor = .colorWithHexStr("#17E8CB");
        label.text = "Translate"
        return label;
        
    }()
    
    lazy var maskTimerView:UIView = {
        let view = UIView()
        view.backgroundColor = .colorWithHexStr("#ffffff", alpha: 0.95)
        return view
    }()
    
//    var chinesQL:GProgressView = GProgressView()
//
//    lazy var englishQL:UILabel = {
//        let label = UILabel();
//        label.font = .customName("MediumItalic", size: 20);
//        label.textColor = .colorWithHexStr("#C5D3D3");
//        return label;
//
//    }()
//
//    lazy var lineView:UIView = {
//        let label = UIView();
//        label.backgroundColor = .colorWithHexStr("#F9FBFB")
//        label.isHidden = true
//        return label;
//    }()
    
    lazy var answerL:YYLabel = {
        let label = YYLabel();
        label.font = .customName("SemiBold", size: 28);
        label.textColor = .colorWithHexStr("#131616");
        label.text = ""
        return label;
        
    }()
    
    lazy var animationI:UIImageView = {
        let label = UIImageView();
        label.isHidden = true
        label.image = UIImage(named: "语音icon")
        
        return label;
        
    }()
    
    lazy var answerResultI:UIImageView = {
        let img = UIImageView();
        img.contentMode = .center
        img.isHidden = true
        return img;
        
    }()
    
    lazy var cycleAniV:CardCycleView = {
        let label = CardCycleView(frame: CGRect(x: 0, y: 0, width: 30, height: 20));
        return label;
        
    }()
    
    public var answerStr:String?{
        didSet{
            
            let attaStr = NSMutableAttributedString(string: answerStr!)
            attaStr.yy_font = .customName("SemiBold", size: 28)
            attaStr.yy_maximumLineHeight = 32
            attaStr.yy_minimumLineHeight = 32
            attaStr.yy_color = .colorWithHexStr("#C5D3D3")
            attaStr.yy_lineBreakMode = .byClipping
            attaStr.yy_alignment = .left
          
            let attachment = NSMutableAttributedString.yy_attachmentString(withContent: cycleAniV, contentMode: .center, attachmentSize: CGSize(width: 30, height: 15), alignTo: .customName("SemiBold", size: 24), alignment: .bottom)
            attaStr.append(attachment);
            answerL.attributedText = attaStr

            
     
            
            
//            let container = YYTextContainer(size: CGSize(width: self.width - 40, height: 1000))
//            let layout = YYTextLayout(container: container, text: attaStr)
//            answerL.textLayout = layout
//
//            guard let line = layout?.lines.last else {
//                return
//            }

            
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func remakeConstranint(){

        answerL.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20);
            make.right.left.equalToSuperview().inset(20);
            make.height.greaterThanOrEqualTo(30)
            make.height.lessThanOrEqualTo(155)
            
//            make.height.equalTo(200)
        }

        animationI.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(60)
            make.height.equalTo(10)
            make.centerX.equalToSuperview()
        }

        answerResultI.snp.makeConstraints { make in
//            make.width.equalTo(65)
//            make.height.equalTo(65)
//            make.centerX.equalToSuperview()
//            make.centerY.equalTo(self.snp.bottom)
            make.edges.equalToSuperview()
        }
        
        self.snp.makeConstraints { (make) in
//            make.bottom.equalTo(animationI.snp.bottom).offset(16)
            make.height.equalTo(181)
        }
        
        
        maskTimerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        timerTL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(36)
        }
        
        timerL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerTL.snp.bottom).offset(17)
        }
        
        
        
                
    }
    
    func setupUI() {
        
//        addSubview(chinesQL);
//        addSubview(englishQL);
//        addSubview(lineView)
        addSubview(answerL)
        addSubview(animationI)
        addSubview(answerResultI)
        
        addSubview(maskTimerView)
        maskTimerView.addSubview(timerTL)
        maskTimerView.addSubview(timerL)
        maskTimerView.isHidden = true
        
        

        remakeConstranint()
        answerL.numberOfLines = 0
        answerL.preferredMaxLayoutWidth = self.width - 40;
        
        self.layer.cornerRadius = 32;
        self.layer.masksToBounds = true;
        self.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(maskTap))
        maskTimerView.addGestureRecognizer(tap)
        
            
    }
    
    
    @objc func maskTap(){
        self.maskViewHidden()
       
    }
    
    func cofigwithBox(query:Query?, totalTime:Double){
        
        guard let squery = query, squery.sub?.value?.count != 0 else {
//            hidenSelf()
            return
        }
                
//        self.englishQL.text = squery.sub
//        let strs = squery.top?.value?.split(separator: " ").map{"\($0)"} ?? []
//        chinesQL.configAnimation(subtitles: strs,delay: 0.0, totalTime: totalTime)
//        let begin = squery.pos ?? 0.0
        

//        LXAsync.delay(begin) {[weak self] in
//            self?.startAnimation()
////            let len = squery.len ?? 0.0
////            LXAsync.delay(len) {[weak self] in
////                self?.startAnimation()
////            }
//        }
    
                
    }
    
    func startAnimation(){
        

        if self.isHidden == false {
            return
        }
        self.answerStr = ""
        self.clipsToBounds = true
        self.setNeedsUpdateConstraints()
        remakeConstranint()

//        self.snp.remakeConstraints { (make) in
//            make.bottom.equalTo(self.englishQL.snp.bottom).offset(17)
//            make.top.equalTo(self.superview!.snp.centerY)
//            make.left.right.equalToSuperview().inset(24)
//        }
        self.superview?.layoutIfNeeded()

//        self.lineView.isHidden = true
        self.animationI.isHidden = true
        answerResultI.isHidden = true
        self.isHidden = false


      
    }
    
    func hidenSelf(){
        UIView.animate(withDuration: 0.35) {
            self.isHidden = true
        }
        
    }
    
    func startListenAnimation(placeholder:String = "",len:Float = 3.0){
        self.clipsToBounds = true
        answerResultI.isHidden = true
        self.answerStr = placeholder
        //        self.setNeedsUpdateConstraints()
        //        remakeConstranint()
        self.animationI.isHidden = false
        self.maskTimerView.isHidden = false
        
        
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.35
        animation.isRemovedOnCompletion = true
        self.layer.add(animation, forKey: nil)
        self.isHidden = false
        
        
       
        
        
        
        
        //        self.lineView.isHidden = false
//        UIView.animate(withDuration: 0.35) {
//            //            self.snp.remakeConstraints { (make) in
//            //                make.bottom.equalTo(self.answerL.snp.bottom).offset(52)
//            //                make.top.equalTo(self.superview!.snp.centerY)
//            //                make.left.right.equalToSuperview().inset(24)
//            //            }
//            //            self.superview?.layoutIfNeeded()
//
//
//            self.alpha = 1.0
//
//        } completion: { (comple) in
//
//        }
        
        
        var count = 3
        
        let time:Double = Double(len / 3.0)
        
        countimer = DispatchSource.makeTimerSource()
//        countimer?.schedule(deadline: DispatchTime.now(),repeating: (len / 3))
//        countimer?.schedule(deadline: DispatchTime.now(), repeating: 1,ti)
        countimer?.schedule(deadline: DispatchTime.now(), repeating: time)
        self.countimer?.setEventHandler(handler: { [self] in
            DispatchQueue.main.sync {
                // 回调 回到了主线程
                self.timerL.text = "\(count)"
                count -= 1
                if count < 0{
                    self.countimer?.cancel()
                    let animation = CATransition()
                    animation.type = .moveIn
                    animation.duration = 0.35
                    animation.isRemovedOnCompletion = true
                    self.maskTimerView.layer.add(animation, forKey: nil)
                    self.maskViewHidden()
                 
                }
            }
        })
        self.countimer?.resume()
        
    }
    
    
    func maskViewHidden()  {
        self.maskTimerView.isHidden = true
        self.cycleAniV.startAnimation()
        if self.maskBlock != nil {
            self.maskBlock!()
        }
    }
    
    func endListen(){
        self.clipsToBounds = true
        answerResultI.isHidden = true
        self.animationI.isHidden = true
      
    }
    
   
    
    
    func endListenAnimation(){
        self.clipsToBounds = true
        answerResultI.isHidden = true
        self.answerStr = ""
        self.setNeedsUpdateConstraints()
//        self.lineView.isHidden = true
        self.animationI.isHidden = true
        
        
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.35
        self.layer.add(animation, forKey: nil)
        self.isHidden = true


//        UIView.animate(withDuration: 0.35) {
////            self.snp.remakeConstraints { (make) in
////                make.bottom.equalTo(self.answerL.snp.bottom).offset(52)
////                make.top.equalTo(self.superview!.snp.centerY)
////                make.left.right.equalToSuperview().inset(24)
////            }
////            self.superview?.layoutIfNeeded()
//
//            self.isHidden = true
//
//        } completion: { (comple) in
//        }
        
    }
    
    //返回回答结果（正确或者错误）的动画
    func anserReslutAni(){
        
        animationI.isHidden = true
        answerResultI.isHidden = false
        answerResultI.image = UIImage(named: "错误")
        self.clipsToBounds = false
        
//        opacity
        let oAni = CABasicAnimation(keyPath: "opacity")
        oAni.fromValue = 0.0
        oAni.toValue = 1.0
        
        // 缩放
        let tAni = CABasicAnimation(keyPath: "transform.scale")
        tAni.fromValue = NSNumber.init(value: 3.0)
        tAni.toValue = NSNumber.init(value: 1.0)
        
        // 组合
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [oAni, tAni]
        groupAnimation.duration = 0.5
        groupAnimation.isRemovedOnCompletion = true
        answerResultI.layer.add(groupAnimation, forKey: nil)
        
        
    }
    
    
   
   

}
