//
//  CoursewareTagView.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/15.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CoursewareTagView: UIView {

    var model:CoursewareModel?{
        didSet{
            for tag in self.tags {
                tag.removeFromSuperview()
            }
            self.tags.removeAll()
            setupUI()
        }
    }
    var tags:[CourseTag] = [CourseTag]()
    
    var margin:CGFloat = 10
    var topMargin:CGFloat = 10

}

extension CoursewareTagView{
    convenience init(model:CoursewareModel){
        self.init()
        self.model = model
        setupUI()

    }
    
    func setupUI(){
        
        guard let models = self.model?.contetns else {
            return
        }
                  
        for subModel in models {
            let tag = CourseTag(model: subModel)
            self.addSubview(tag)
            self.tags.append(tag)
        }
        
        if self.tags.count == self.model?.contetns.count && self.tags.count != 0 {
            let count = self.tags.count
//            let totalwidth = self.bounds.size.width
            let totalwidth = ScreenWidth - 43 - 10
            var rowWidth:CGFloat = 0
            var last:UIView?
            var isChange:Bool = true
            for i in 0 ..< count{
                let tag = self.tags[i]
                let subModel = self.model?.contetns[i]
                var tagWidth = (subModel?.widths[0])! + (subModel?.widths[1])!
                rowWidth += tagWidth + margin

                if rowWidth > totalwidth - margin{
                    //需要换行
                    isChange = true
                    if tagWidth + margin * 2 > totalwidth {
                        tagWidth = (totalwidth - margin*2);
                    }
                    rowWidth = tagWidth + margin
                }
                
                tag.snp.makeConstraints { (make) in
                    if isChange{//换行
                        if last == nil{
                            make.top.equalTo(self).offset(self.topMargin)
                        }else{
                            make.top.equalTo(last!.snp.bottom).offset(self.topMargin)
                        }
                        make.left.equalTo(self).offset(margin)
                        isChange = false
                        
                    }else{
                        make.left.equalTo(last!.snp.right).offset(margin)
                        make.top.equalTo(last!.snp.top)
                    }
                    
                    if i == count - 1{
                        make.bottom.equalTo(self).offset(-topMargin)
                    }
                    last = tag
                    
                }
    
            }
        
        }
            
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
}
