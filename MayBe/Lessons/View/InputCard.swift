//
//  InputCard.swift
//  MayBe
//
//  Created by liuxiang on 2021/3/11.
//  Copyright © 2021 liuxiang. All rights reserved.
//



import UIKit

class InputCard: UIView {

    let maxWidth = ScreenWidth - 72

    lazy var contentL:YYLabel = {
        let label = YYLabel();
        label.textColor = .colorWithHexStr("#131616");
        return label;
    }()
    
    lazy var rightL:YYLabel = {
        let label = YYLabel();
        label.textColor = .colorWithHexStr("#15DABF");
        return label;
    }()
    
    lazy var arrowI:UIImageView = {
        let ig = UIImageView();
        ig.image = UIImage(named: "箭头")
        return ig;
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
            make.left.right.top.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(maxWidth)
        }
        
        contentL.preferredMaxLayoutWidth = maxWidth
       
        addSubview(resultI)
        resultI.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentL)
        }
        
        addSubview(rightL)
        addSubview(arrowI)
        
        
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = false
        self.clipsToBounds = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configError(errorStr:String,contentStr:String,rightStr:String){
        
        guard let range = contentStr.range(of: errorStr) else {
            return
        }
        
        let location = contentStr.distance(from: contentStr.startIndex, to: range.lowerBound)
        let nrange = NSRange(location: location, length: errorStr.count)
        
        let attrStr = NSMutableAttributedString(string: contentStr)
        attrStr.yy_color =  .colorWithHexStr("#131616");
        attrStr.yy_lineBreakMode = .byClipping
        attrStr.yy_font = self.font
        attrStr.yy_alignment = self.alignment
        attrStr.yy_maximumLineHeight = 28
        attrStr.yy_minimumLineHeight = 28
        attrStr.yy_setColor(UIColor.colorWithHexStr("#FF5C5C"), range: nrange)
        
        let border = YYTextBorder(fill: UIColor.colorWithHexStr("#FFEBEB"), cornerRadius: 6)
        border.insets = UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3)
        attrStr.yy_setTextBackgroundBorder(border, range: nrange)
        
        
        let container = YYTextContainer(size: CGSize(width: maxWidth, height: 1000))
        let layout = YYTextLayout(container: container, text: attrStr)
        contentL.textLayout = layout
        
        
        
        let rattrStr = NSMutableAttributedString(string: rightStr)
        rattrStr.yy_color =  .colorWithHexStr("#15DABF");
        rattrStr.yy_lineBreakMode = .byClipping
        rattrStr.yy_font = self.font
        rattrStr.yy_alignment = self.alignment
        rattrStr.yy_maximumLineHeight = 28
        rattrStr.yy_minimumLineHeight = 28
        
        let rborder = YYTextBorder(fill: UIColor.colorWithHexStr("#E2FFFB"), cornerRadius: 6)
        border.insets = UIEdgeInsets(top: -3, left: -5, bottom: -3, right: -3)
        rattrStr.yy_setTextBackgroundBorder(rborder, range: NSRange(location: 0, length: rightStr.count))
        
       
        rightL.attributedText = rattrStr
        
        guard  let rect = layout?.rect(for: YYTextRange(range: nrange)) else {
            return
        }
       
//        arrowI.frame = CGRect(x: contentL.left + (rect.maxX - rect.minX) / 2.0, y: contentL.top + rect.maxY + 6, width: 12, height: 15)
        
        arrowI.snp.remakeConstraints { (make) in
            make.top.equalTo(self.contentL.snp.top).offset(rect.maxY + 6)
            make.width.equalTo(12)
            make.height.equalTo(15)
           
            make.centerX.equalTo(self.contentL.snp.left).offset(rect.minX + (rect.maxX - rect.minX) / 2.0)
        }
        
        rightL.snp.remakeConstraints { (make) in
            make.centerX.equalTo(arrowI)
            make.top.equalTo(arrowI.snp.bottom).offset(6)
        }
        
                
        
    }
    

}

