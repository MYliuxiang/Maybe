//
//  CourseTag.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/15.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CourseTag: UIView {
   
    lazy var pingyinL:UILabel = {
        let label = UILabel()
        label.font = .customName("SemiBold", size: 20)
        label.textColor = .colorWithHexStr("#131616")
        label.textAlignment = .center
        return label
    }()
    
     lazy var titleL:UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 32,weight: .thin)
           label.textColor = .colorWithHexStr("#131616")
           label.textAlignment = .center
           return label
    }()
    
    lazy var title1L:UILabel = {
              let label = UILabel()
              label.font = .systemFont(ofSize: 32,weight: .thin)
              label.textColor = .colorWithHexStr("#131616")
              label.textAlignment = .center
              return label
       }()
    
    lazy var bgView:UIView = {
                return UIView()
          }()
    
    var model:CoursewareSubModel?
    
    
    

}

extension CourseTag{
    convenience init(model:CoursewareSubModel){
        self.init()
        self.model = model
//        addSubview(pingyinL)
//        addSubview(titleL)
        addSubview(title1L)
        addSubview(bgView)
        
        bgView.addSubview(pingyinL)
        bgView.addSubview(titleL)
        
        
        
        pingyinL.text = self.model?.pinyins[0]
        titleL.text = self.model?.titles[0]
        title1L.text = self.model?.titles[1]
        
        let attrStr = NSMutableAttributedString(string: model.titles[0])
        attrStr.addAttributes([NSAttributedString.Key.kern:0], range: NSMakeRange(0, attrStr.length - 1))
        titleL.attributedText = attrStr
        layoutUI()
        
    }
    func layoutUI(){

        self.snp.makeConstraints { (make) in
            make.width.equalTo((self.model?.widths[0])! + (self.model?.widths[1])! )
        }
        
        self.bgView.snp.makeConstraints { (make) in
            make.bottom.left.top.equalTo(self)
            make.width.equalTo((self.model?.widths[0])!)
        }
        
        pingyinL.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        titleL.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(pingyinL.snp.bottom).offset(10)
        }
        
        title1L.snp.makeConstraints { (make) in
            make.bottom.equalTo(titleL)
            make.left.equalTo(titleL.snp.right)
        }
        
        
    }
    
    
    
}
