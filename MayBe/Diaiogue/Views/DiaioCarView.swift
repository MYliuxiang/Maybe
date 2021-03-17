//
//  DiaioCarView.swift
//  MayBe
//
//  Created by liuxiang on 2021/2/26.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit


enum CaryType {
    case MyCard,LiLYCard
}

class DiaioCarView: UIView {

    let maxWidth = ScreenWidth - 100
    var type:CaryType
    
    lazy var avtorI:UIImageView = {
        let imageV = UIImageView();
        imageV.layer.cornerRadius = 16
        imageV.layer.masksToBounds = true
        return imageV;
    }()
    
    lazy var contentL:UILabel = {
        let label = UILabel();
        label.textColor = .colorWithHexStr("#131616");
        return label;
    }()
    
    var contentStr:String?{
        didSet{
            
            
            let attaStr = NSMutableAttributedString(string: contentStr!)
          
            attaStr.yy_color =  .colorWithHexStr("#131616");
            attaStr.yy_lineBreakMode = .byClipping
            
            if self.type == .MyCard {
                attaStr.yy_font = .customName("Medium", size: 20)
                attaStr.yy_maximumLineHeight = 24
                attaStr.yy_minimumLineHeight = 24
            }else{
                attaStr.yy_font = .customName("SemiBold", size: 24)
                attaStr.yy_maximumLineHeight = 28
                attaStr.yy_minimumLineHeight = 28
            }
                        
            contentL.attributedText = attaStr
            
        }
    }
    
    init(type:CaryType) {
        self.type = type
        super.init(frame: .zero)
        self.addSubview(contentL)
        self.addSubview(avtorI)
        contentL.numberOfLines = 0
        self.clipsToBounds = true
        
        if type == .MyCard {
            contentL.font = .customName("Medium", size: 20)
            avtorI.snp.makeConstraints { (make) in
                make.height.width.equalTo(32)
                make.right.equalToSuperview().offset(-4)
                make.centerY.equalTo(self.snp.top)
            }
            avtorI.backgroundColor = .yellow
            avtorI.image = UIImage(named: "用户头像")
            self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            
            contentL.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
                make.width.lessThanOrEqualTo(maxWidth)
            }
            
            
        }else{
            contentL.font = .customName("SemiBold", size: 24)
            avtorI.snp.makeConstraints { (make) in
                make.height.width.equalTo(32)
                make.left.equalToSuperview().offset(8)
                make.centerY.equalTo(self.snp.top)
            }
            
            avtorI.image = UIImage(named: "756")
            self.backgroundColor = UIColor.white

            
            contentL.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
                make.width.lessThanOrEqualTo(200)
            }

            
        }
        
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = false

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   


}
