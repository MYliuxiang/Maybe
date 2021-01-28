//
//  CoursePyEnCharactersCell.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/21.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CoursePyEnCharactersCell: UITableViewCell {

    @IBOutlet weak var enlishL: UILabel!
    var tagView = CoursewareTagView()
    var model:CoursewareModel?{
        didSet{
            tagView.model = model
            tagView.layoutIfNeeded()
            enlishL.text = model?.eng
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.addSubview(tagView)
        tagView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-30)
            make.right.equalToSuperview().offset(-43)
            make.top.equalTo(self.enlishL.snp.bottom).offset(8)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
