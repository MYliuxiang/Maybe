//
//  AnswerAlert.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/24.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit


class AnswerView: NibView {
    
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var anserL: YYLabel!
    @IBOutlet weak var qusetionL: YYLabel!
    @IBOutlet weak var bottomImg: UIImageView!
    var showtimer:DispatchSourceTimer?
    var isShow:Bool = false

    
    var question:String?{
        didSet{
//            let attaStr = NSMutableAttributedString(string:question ?? "")
//            attaStr.yy_font = .customName("SemiBold", size: 28)
//            attaStr.yy_color = .colorWithHexStr("#C5D3D3")
//            attaStr.yy_alignment = .left
//            self.qusetionL.attributedText = attaStr
        }
    }
    
    var anwerStr:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.showtimer?.cancel()
    }
    func setUI()  {
        
       
//        self.qusetionL.textVerticalAlignment = .top

        let blurEffect = UIBlurEffect(style: .light)
        
        //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        self.view.insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.alpha = 0.8
        blurView.contentView.addSubview(whiteView)
        
        whiteView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
                
        self.width = ScreenWidth - 48
//        self.centerX = ScreenWidth / 2
//        self.height = 327 / (ScreenWidth - 48) * 330
        subTitleLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-24)
        }
                
    }
    
    
   
    func showAnswer(title:String, subTitle:String){
        titleLab.text = title
        subTitleLab.text = subTitle
        
//        if self.showtimer != nil {
//            self.showtimer?.cancel()
//            let range = question?.range(of: self.anwerStr!)
//            let location = question!.distance(from: question!.startIndex, to:range!.lowerBound)
//            let attaStr = NSMutableAttributedString(string: self.anwerStr!)
//            attaStr.yy_font = .customName("SemiBold", size: 28)
//            attaStr.yy_color = .clear
//
//            attaStr.yy_setColor(.colorWithHexStr("#131616", alpha:1), range: NSRange(location: location, length:self.anwerStr?.count ?? 0))
//            self.anserL.attributedText = attaStr
//        }
//        self.anwerStr = answer
//
//        var cecount:Double = 0
//        let secondes:Double = 0.3 / 3 / 10
//        showtimer = DispatchSource.makeTimerSource()
//        showtimer?.schedule(deadline: DispatchTime.now(),repeating: secondes)
//        showtimer?.setEventHandler(handler: { [self] in
//            DispatchQueue.main.sync {
//
//                let range = self.question?.range(of: self.anwerStr!)
//                let location = self.question!.distance(from: question!.startIndex, to:range!.lowerBound)
//                let attaStr = NSMutableAttributedString(string: self.anwerStr ?? "")
//                attaStr.yy_font = .customName("SemiBold", size: 28)
//                attaStr.yy_color = .clear
//                let alpha = cecount / 10
//                attaStr.yy_setColor(.colorWithHexStr("#131616", alpha:CGFloat(alpha)), range: NSRange(location: location, length:self.anwerStr?.count ?? 0))
//                self.anserL.attributedText = attaStr
//
//                cecount += 1;
//                if(cecount > 10){
//                    self.showtimer?.cancel()
//                }
//            }
//        })
//        showtimer?.resume()
        
    }
    
   
    
  
    func show(){
               
        if !isShow{
            isShow = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
//                self.bottom = ScreenHeight - YMKDvice.bottomOffset() - 20
                self.alpha = 1
            } completion: { (completion) in
            
            }
        }
        
    }
    
    func dismiss(){
        isShow = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
//            self.top = ScreenHeight
            self.alpha = 0
        } completion: { (completion) in
            
        }
    }
    
    func showQuestion(qusetion:String){
        
      
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners:[UIRectCorner.topLeft, UIRectCorner.topRight,UIRectCorner.bottomLeft,UIRectCorner.bottomRight] , cornerRadii: CGSize(width: 52, height: 52))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
                
    }
    

}
