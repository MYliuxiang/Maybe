//
//  CourseCell.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/15.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    
    var tagView = CoursewareTagView()
    
    var model:CoursewareModel?{
        didSet{
            tagView.model = model
            tagView.layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.addSubview(tagView)
        tagView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 43))
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
