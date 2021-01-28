//
//  SomeCountriesCell.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/9.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class SomeCountriesCell: UITableViewCell {
    
    @IBOutlet weak var constraint1: NSLayoutConstraint!
    @IBOutlet weak var constraint2: NSLayoutConstraint!
    @IBOutlet weak var constraint3: NSLayoutConstraint!
    @IBOutlet weak var constraint4: NSLayoutConstraint!
    @IBOutlet weak var constraint5: NSLayoutConstraint!
    @IBOutlet weak var constraint6: NSLayoutConstraint!
 
    var type:CourseWareType?{
        didSet{
            if type == CourseWareType.PinyinEnglish {
                constraint1.constant = 0
                constraint2.constant = 0
                constraint3.constant = 0
                constraint4.constant = 0
                constraint5.constant = 0
                constraint6.constant = 0
            
            }else{
                constraint1.constant = 18
                constraint2.constant = 18
                constraint3.constant = 18
                constraint4.constant = 18
                constraint5.constant = 18
                constraint6.constant = 18
            }
            
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
