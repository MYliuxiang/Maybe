//
//  TipCell.swift
//  MayBe
//
//  Created by liuxiang on 2020/9/1.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class TipCell: UITableViewCell {

    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var subL: UILabel!
    
    
    @IBOutlet weak var statusI: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.statusI.image = UIImage(named: "已选中")
            
        }else{
            self.statusI.image = UIImage(named: "未选中")


        }
       
    }
    
}
