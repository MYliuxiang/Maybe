//
//  LessonsSmallCell.swift
//  MayBe
//
//  Created by liuxiang on 10/04/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LessonsSmallCell: UITableViewCell {

    @IBOutlet weak var scoreI: UIImageView!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var coverI: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coverI.layer.cornerRadius = 34
        coverI.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
