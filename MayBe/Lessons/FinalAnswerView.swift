//
//  FinalAnswerView.swift
//  MayBe
//
//  Created by liuxiang on 2020/12/23.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class FinalAnswerView: NibView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var answerLab: UILabel!
    @IBOutlet weak var headerImg: UIImageView!
    var isShow:Bool = false

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    
    func configFinal(_ fanswer:String, ferrIdx:[Int]){
        
        if fanswer.count == 0 {
            return
        }
                
        let attaStr = NSMutableAttributedString(string: fanswer)
        attaStr.yy_font = .customName("SemiBold", size: 24)
        attaStr.yy_alignment = .center
        attaStr.yy_color = .colorWithHexStr("#15DABF")
        let anss = fanswer.split(separator: " ").map{"\($0)"}
        if ferrIdx.count <= anss.count{
            for idx in ferrIdx {
                if idx >= anss.count{
                    return
                }
                let range = fanswer.range(of: anss[idx])
                let location = fanswer.distance(from: anss[idx].startIndex, to:range!.lowerBound)
                attaStr.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.colorWithHexStr("#FF5C5C")], range: NSRange(location: location, length: anss[idx].count ))
            }
        }
        
        
        self.answerLab.attributedText = attaStr
        
                
        
        
    }
    
    
    func setUI()  {
        
        self.headerImg.layer.cornerRadius = 20
        self.headerImg.layer.masksToBounds = true
        self.headerImg.layer.borderWidth = 3
        self.headerImg.layer.borderColor = UIColor.white.cgColor
       

        self.bgView.layer.cornerRadius = 48
        self.bgView.layer.masksToBounds = true
        

        //        let blurEffect = UIBlurEffect(style: .light)
//
//        //创建一个承载模糊效果的视图
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        self.bgView.insertSubview(blurView, at: 0)
//        blurView.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        }
//
//        let whiteView = UIView()
//        whiteView.backgroundColor = .white
//        whiteView.alpha = 0.8
//        blurView.contentView.addSubview(whiteView)
//
//        whiteView.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        }
        
                
        self.width = ScreenWidth - 48

        answerLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-48)
        }
                
    }

  
    func show(){
               
        if !isShow{
            isShow = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                self.alpha = 1
            } completion: { (completion) in
            
            }
        }
        
    }
    
    func dismiss(){
        isShow = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            self.alpha = 0
        } completion: { (completion) in
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
    }
    

}
