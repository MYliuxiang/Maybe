//
//  DetailLCell.swift
//  MayBe
//
//  Created by liuxiang on 2020/9/1.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class DetailLCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var countI: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.cornerRadius = 32
        self.bgView.layer.masksToBounds = true
        self.bgView.alpha = 0.9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
