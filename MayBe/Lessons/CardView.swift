//
//  CardView.swift
//  MayBe
//
//  Created by liuxiang on 2021/1/22.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit

class CardView: UIView {

//    lazy var chinesQL:UILabel = {
//        let label = UILabel();
//        label.font = .customName("SemiBold", size: 24);
//        label.textColor = .colorWithHexStr("#131616");
//        return label;
//    }()
    
    var chinesQL:GProgressView = GProgressView()
    
    lazy var englishQL:UILabel = {
        let label = UILabel();
        label.font = .customName("MediumItalic", size: 20);
        label.textColor = .colorWithHexStr("#C5D3D3");
        return label;
        
    }()
    
    lazy var lineView:UIView = {
        let label = UIView();
        label.backgroundColor = .colorWithHexStr("#F9FBFB")
        label.isHidden = true
        return label;
    }()
    
    lazy var answerL:YYLabel = {
        let label = YYLabel();
        label.font = .customName("MediumItalic", size: 20);
        label.textColor = .colorWithHexStr("#C5D3D3");
        label.text = ""
        return label;
        
    }()
    
    lazy var animationI:UIImageView = {
        let label = UIImageView();
        label.backgroundColor = .green
        label.isHidden = true
        return label;
        
    }()
    
    lazy var answerResultI:UIImageView = {
        let img = UIImageView();
        img.isHidden = true
        return img;
        
    }()
    
    lazy var cycleAniV:CardCycleView = {
        let label = CardCycleView(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        return label;
        
    }()
    
    public var answerStr:String?{
        didSet{
            
            let attaStr = NSMutableAttributedString(string: answerStr!)
            attaStr.yy_font = .customName("SemiBold", size: 24)
            attaStr.yy_maximumLineHeight = 30
            attaStr.yy_minimumLineHeight = 30
            attaStr.yy_color = .colorWithHexStr("#131616")
            attaStr.yy_lineBreakMode = .byClipping
          
            let attachment = NSMutableAttributedString.yy_attachmentString(withContent: cycleAniV, contentMode: .center, attachmentSize: CGSize(width: 30, height: 30), alignTo: .customName("SemiBold", size: 24), alignment: .center)
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
        chinesQL.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16);
            make.right.left.equalToSuperview().inset(20);
            make.height.greaterThanOrEqualTo(28)
        }
        englishQL.snp.makeConstraints { make in
            make.top.equalTo(self.chinesQL.snp.bottom).offset(4);
            make.right.left.equalToSuperview().inset(20);
            make.height.greaterThanOrEqualTo(24)

        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(self.englishQL.snp.bottom).offset(16);
            make.right.left.equalToSuperview().inset(20);
            make.height.equalTo(1)
        }
        answerL.snp.makeConstraints { make in
            make.top.equalTo(self.lineView.snp.bottom).offset(12);
            make.right.left.equalToSuperview().inset(20);
            make.height.greaterThanOrEqualTo(61)
        }
        
        animationI.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16);
            make.width.equalTo(60)
            make.height.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        answerResultI.snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(65)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.bottom)
        }
                
    }
    
    func setupUI() {
        
        addSubview(chinesQL);
        addSubview(englishQL);
        addSubview(lineView)
        addSubview(answerL)
        addSubview(animationI)
        addSubview(answerResultI)
        
        remakeConstranint()
        cycleAniV.startAnimation()
        answerL.numberOfLines = 0
        answerL.preferredMaxLayoutWidth = self.width - 40;
        
        self.layer.cornerRadius = 32;
        self.layer.masksToBounds = true;
        self.backgroundColor = .white
            
    }
    
    func cofigwithBox(query:Query?, totalTime:Double){
        
        guard let squery = query, squery.sub?.count != 0 else {
//            hidenSelf()
            return
        }
                
        self.englishQL.text = squery.sub
        let strs = squery.top?.value?.split(separator: " ").map{"\($0)"} ?? []
        chinesQL.configAnimation(subtitles: strs,delay: 0.0, totalTime: totalTime)
        let begin = squery.pos ?? 0.0
        

        LXAsync.delay(begin) {[weak self] in
            self?.startAnimation()
//            let len = squery.len ?? 0.0
//            LXAsync.delay(len) {[weak self] in
//                self?.startAnimation()
//            }
        }
    
                
    }
    
    func startAnimation(){
        

        if self.isHidden == false {
            return
        }
        self.answerStr = ""
        self.clipsToBounds = true
        self.setNeedsUpdateConstraints()
        remakeConstranint()

        self.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.englishQL.snp.bottom).offset(17)
            make.top.equalTo(self.superview!.snp.centerY)
            make.left.right.equalToSuperview().inset(24)
        }
        self.superview?.layoutIfNeeded()

        self.lineView.isHidden = true
        self.animationI.isHidden = true
        answerResultI.isHidden = true
        self.isHidden = false


      
    }
    
    func hidenSelf(){
        UIView.animate(withDuration: 0.35) {
            self.isHidden = true
        }
        
    }
    
    func startListenAnimation(){
        self.clipsToBounds = true
        answerResultI.isHidden = true
        self.answerStr = ""
        self.setNeedsUpdateConstraints()
        remakeConstranint()
        self.animationI.isHidden = false
        self.lineView.isHidden = false
        UIView.animate(withDuration: 0.35) {
            self.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self.answerL.snp.bottom).offset(52)
                make.top.equalTo(self.superview!.snp.centerY)
                make.left.right.equalToSuperview().inset(24)
            }
            self.superview?.layoutIfNeeded()
        } completion: { (comple) in
        }
        
    }
    
    
    func endListenAnimation(){
        self.clipsToBounds = true
        answerResultI.isHidden = true
        self.answerStr = ""
        self.setNeedsUpdateConstraints()
        self.lineView.isHidden = true
        self.animationI.isHidden = true

        UIView.animate(withDuration: 0.35) {
            self.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self.answerL.snp.bottom).offset(52)
                make.top.equalTo(self.superview!.snp.centerY)
                make.left.right.equalToSuperview().inset(24)
            }
            self.superview?.layoutIfNeeded()
        } completion: { (comple) in
        }
        
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
