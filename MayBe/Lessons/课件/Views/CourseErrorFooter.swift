//
//  CourseErrorFooter.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/12.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CourseErrorFooter: UICollectionReusableView {

    
    lazy var errorView = CourseErrorView()
    
    var posionType:Int = 0{
        didSet{
//            errorView.snp.removeConstraints()
            
            if posionType == 0 {
                errorView.snp.remakeConstraints { (make) in
                    make.left.equalTo(24)
                    make.centerY.equalToSuperview()
                }
            }else{
                errorView.snp.remakeConstraints { (make) in
                    make.right.equalTo(-24)
                    make.centerY.equalToSuperview()
                }
            }
        }
    }
    
    var model:CourseErrorModel?{
        didSet{
            
            errorView.configlabel(errorArray: model!.wrong!, sucessArray: model!.right!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addSubview(errorView)
//        errorView.snp.makeConstraints { (make) in
//            make.left.equalTo(30)
//            make.centerY.equalToSuperview()
//        }
        
    }
    
}
