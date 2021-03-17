//
//  DiaCenterView.swift
//  MayBe
//
//  Created by liuxiang on 2021/3/2.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit

class DiaCenterView: UIView {

    let maxWidth = ScreenWidth - 72

    lazy var contentL:UILabel = {
        let label = UILabel();
        label.textColor = .colorWithHexStr("#131616");
        return label;
    }()
    
    lazy var resultI:UIImageView = {
        let img = UIImageView();
        img.contentMode = .center
        img.isHidden = true
        return img;
        
    }()
    
    var alignment:NSTextAlignment
    var font:UIFont
    
    var contentStr:String?{
        didSet{
            
            let attaStr = NSMutableAttributedString(string: contentStr!)
            attaStr.yy_color =  .colorWithHexStr("#131616");
            attaStr.yy_lineBreakMode = .byClipping
            attaStr.yy_font = self.font
            attaStr.yy_alignment = self.alignment
            attaStr.yy_maximumLineHeight = 28
            attaStr.yy_minimumLineHeight = 28
            contentL.attributedText = attaStr
            
        }
    }
    
    init(alignment:NSTextAlignment = .center, font:UIFont = .customName("Medium", size: 24)) {
        self.font = font
        self.alignment = alignment
        super.init(frame: .zero)
        self.addSubview(contentL)
        contentL.numberOfLines = 0
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        
        contentL.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
            make.width.lessThanOrEqualTo(maxWidth)
        }
       
        addSubview(resultI)
        
        resultI.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentL)
        }

        
        self.layer.cornerRadius = 32
        self.layer.masksToBounds = false
        self.clipsToBounds = false

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
