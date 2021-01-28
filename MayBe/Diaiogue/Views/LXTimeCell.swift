//
//  LXTimeCell.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/9.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LXTimeCell: UITableViewCell {

    lazy var dateLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 11)
           label.textColor = .white
           return label
       }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           selectionStyle = .none
           
           contentView.addSubview(dateLabel)
          
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
