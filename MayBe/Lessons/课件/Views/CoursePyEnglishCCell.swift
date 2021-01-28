//
//  CoursePyEnglishCCell.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/21.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CoursePyEnglishCCell: UITableViewCell {

    @IBOutlet weak var pyL: UILabel!
    @IBOutlet weak var englishL: UILabel!
    var model:CoursewareModel?{
        didSet{
            englishL.text = model?.eng
            guard let contents = model?.contetns else {
                return
            }
            var py:String = ""
            for (idx,item) in contents.enumerated() {
                if idx == contents.count - 1 {
                    py.append(item.pySymbolStr)
                }else{
                    py.append(item.pySymbolStr)
                    py.append(" ")
                }
            }
            pyL.text = py
        }
         
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
