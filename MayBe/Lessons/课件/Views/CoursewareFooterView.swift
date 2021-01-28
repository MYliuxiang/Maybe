//
//  CoursewareFooterView.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/10.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CoursewareFooterView: UICollectionReusableView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 28
        bgView.layer.masksToBounds = true
    }
    
}
