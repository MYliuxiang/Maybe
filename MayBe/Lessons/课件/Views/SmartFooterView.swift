//
//  SmartFooterView.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/13.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class SmartFooterView: UICollectionReusableView {

    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.cornerRadius = 24
        self.bgView.layer.masksToBounds = true
    }
    
}
