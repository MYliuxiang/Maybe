//
//  MessageTableView.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/11.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LXMessageTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var contentSize: CGSize{
        get{
            return super.contentSize
        }
        set{
            if !__CGSizeEqualToSize(self.contentSize, CGSize.zero){
                
                if newValue.height > self.contentSize.height{
                    var offset = self.contentOffset
                    offset.y += (newValue.height - self.contentSize.height)
                    self.contentOffset = offset
                }
            }
            
            super.contentSize = newValue
        }
    }

}
