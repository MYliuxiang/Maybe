//
//  FYTextMessageCell.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/20.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import YYText

class LXTextMessageCell: LXMessageBaseCell {
    
    private let kMaxWidth: CGFloat = ScreenWidth * 0.55
    
    // MARK: - var lazy
    
    lazy var contentLabel: YYLabel = {
        let label = YYLabel()
        label.numberOfLines = 0
        label.displaysAsynchronously = true;
        label.clearContentsBeforeAsynchronouslyDisplay = false;
        label.text = ""
        return label
    }()
    
    lazy var subContentLabel: YYLabel = {
        let label = YYLabel()
        label.numberOfLines = 0
        label.displaysAsynchronously = true;
        label.clearContentsBeforeAsynchronouslyDisplay = false;
        return label
    }()
    
    lazy var subBubbleView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //忽略警告代码
        self.contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        self.translatesAutoresizingMaskIntoConstraints = false
        initSubview()
        setupLabelLongPressGes(cellType: .textCell)
    }
    
    func initSubview() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(subBubbleView)
        contentView.addSubview(subContentLabel)
        contentLabel.text = ""
        
    }
    
    override func refreshMessageCell() {
        super.refreshMessageCell()
        guard let msgType = model?.msgType, msgType == 1 else {
            return
        }
        
        
        
        if model?.msgStatus == false {
            model?.text = ["      "]
        }else{
        }
        
        contentLabel.text = model?.text?.first
        if model?.text?.count == 2 {
            subContentLabel.text = model?.text![1]
        }else{
            subContentLabel.text = ""
        }
        
        //        if let imageURL = model?.avatar {
        //            avatarView.setImageWithURL(imageURL, placeholder: "ic_avatar_placeholder")
        //        }
        
        //        if model?.nickName.isBlank == false {
        //            nameLabel.text = model?.nickName
        //        }else {
        //            nameLabel.text = model?.name
        //        }
        
        // 重新布局
        //        let contentSize = contentLabel.sizeThatFits(CGSize(width: kMaxWidth, height: CGFloat(Float.greatestFiniteMagnitude)))
        
//        let contentSize = contentLabel.text?.ex_size(with: CGSize(width: kMaxWidth, height: CGFloat(Float.greatestFiniteMagnitude)), font: UIFont.customName("SemiBold", size: 16))
        contentLabel.preferredMaxLayoutWidth = kMaxWidth
        subContentLabel.preferredMaxLayoutWidth = kMaxWidth
        
        if let sendType = model?.sendType {
            setupCellLayout(sendType: sendType)
        }
        
        // 设置泡泡
        //        let bubbleImage = model?.sendType == 0 ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        
        //        bubbleView.image = bubbleImage.stretchableImage(centerStretchScale: 0.65)
        
        if model?.sendType == 1{
            bubbleView.backgroundColor = .colorWithHexStr("#FFFFFF")
            bubbleView.layer.borderColor = UIColor.colorWithHexStr("#F3F7F7").cgColor
            bubbleView.layer.borderWidth = 1
            
            subBubbleView.backgroundColor = .colorWithHexStr("#FFFFFF")
            subBubbleView.layer.borderColor = UIColor.colorWithHexStr("#F3F7F7").cgColor
            subBubbleView.layer.borderWidth = 1
            
            contentLabel.font = UIFont.customName("SemiBold", size: 16)
            contentLabel.textColor = .colorWithHexStr("#051724")
            
            subContentLabel.font = UIFont.customName("SemiBold", size: 16)
            subContentLabel.textColor = .colorWithHexStr("#051724")
            
            
        }else{
            bubbleView.backgroundColor = .colorWithHexStr("#DEF7F7")
            bubbleView.layer.borderColor = UIColor.colorWithHexStr("#DEF7F7").cgColor
            bubbleView.layer.borderWidth = 1
            subBubbleView.backgroundColor = .colorWithHexStr("#DEF7F7")
            subBubbleView.layer.borderColor = UIColor.colorWithHexStr("#DEF7F7").cgColor
            subBubbleView.layer.borderWidth = 1
            
            contentLabel.font = UIFont.customName("Regular", size: 16)
            contentLabel.textColor = .colorWithHexStr("#051724")
            
            subContentLabel.font = UIFont.customName("Regular", size: 16)
            subContentLabel.textColor = .colorWithHexStr("#051724")
        }
        bubbleView.layer.cornerRadius = 28
        bubbleView.layer.masksToBounds = true
        
        subBubbleView.layer.cornerRadius = 28
        subBubbleView.layer.masksToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension LXTextMessageCell {
    
    func setupCellLayout(sendType: Int) {
       
        
        if sendType == 0 { //我发送的
            
            contentLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView.snp.top).offset(11)
                make.right.equalTo(avatarView.snp.left).offset(-33)
                make.width.lessThanOrEqualTo(kMaxWidth)
                make.height.greaterThanOrEqualTo(16)
                make.width.greaterThanOrEqualTo(10)

            }
            
            
            if subContentLabel.text?.count == 0{
                  bubbleView.snp.remakeConstraints { (make) in
                    make.right.equalTo(contentLabel).offset(26)
                    make.top.equalTo(contentLabel).offset(-17)
                    make.bottom.equalTo(contentLabel).offset(20)
                    make.left.equalTo(contentLabel).offset(-26)
                    make.bottom.equalTo(self.contentView).offset(-17)
                    
                }
                subBubbleView.isHidden = true
                subContentLabel.isHidden = true
                
            }else{
                
                subBubbleView.isHidden = false
                subContentLabel.isHidden = false
                bubbleView.snp.remakeConstraints { (make) in
                    make.right.equalTo(contentLabel).offset(26)
                    make.top.equalTo(contentLabel).offset(-17)
                    make.bottom.equalTo(contentLabel).offset(20)
                    make.left.equalTo(contentLabel).offset(-26)
                }
                
                subContentLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(contentLabel.snp.bottom).offset(41)
                    make.right.equalTo(avatarView.snp.left).offset(-33)
                }
                subBubbleView.snp.remakeConstraints { (make) in
                    make.right.equalTo(subContentLabel).offset(26)
                    make.left.equalTo(subContentLabel).offset(-26)
                    make.top.equalTo(subContentLabel).offset(-17)
                    make.bottom.equalTo(subContentLabel).offset(20)
                    make.bottom.equalTo(self.contentView).offset(-17)
                }
                
            }
                        
            activityIndicatorView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(bubbleView)
                make.right.equalTo(bubbleView.snp.left)
                make.width.height.equalTo(30)
                
            }
            
            // start
            activityStartAnimating()
            
        }else {
            
            contentLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView.snp.top).offset(11)
                make.left.equalTo(avatarView.snp.right).offset(33)
                make.width.lessThanOrEqualTo(kMaxWidth)
                make.height.greaterThanOrEqualTo(16)
                make.width.greaterThanOrEqualTo(10)

            }
            
            if subContentLabel.text?.count == 0{
                bubbleView.snp.remakeConstraints { (make) in
                    make.right.equalTo(contentLabel).offset(25)
                    make.top.equalTo(contentLabel).offset(-17)
                    make.bottom.equalTo(contentLabel).offset(20)
                    make.left.equalTo(contentLabel).offset(-25)
                    make.bottom.equalTo(self.contentView).offset(-17)
                }
                subBubbleView.isHidden = true
                subContentLabel.isHidden = true
                
            }else{
                
                subBubbleView.isHidden = false
                subContentLabel.isHidden = false
                bubbleView.snp.remakeConstraints { (make) in
                    make.right.equalTo(contentLabel).offset(25)
                    make.left.equalTo(contentLabel).offset(-25)
                    make.top.equalTo(contentLabel).offset(-17)
                    make.bottom.equalTo(contentLabel).offset(20)
                }
                
                
                subContentLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(contentLabel.snp.bottom).offset(41)
                    make.left.equalTo(avatarView.snp.right).offset(33)
                    make.width.lessThanOrEqualTo(kMaxWidth)
                }
                subBubbleView.snp.remakeConstraints { (make) in
                    make.right.equalTo(subContentLabel).offset(26)
                    make.left.equalTo(subContentLabel).offset(-26)
                    make.top.equalTo(subContentLabel).offset(-17)
                    make.bottom.equalTo(subContentLabel).offset(20)
                    make.bottom.equalTo(self.contentView).offset(-17)
                }
            }
                        
        }
        if model?.msgStatus == false {
            LXCycleAnimation.setUpScaleAnimation(fatherView: bubbleView, type: .opacity)
        }else{
            LXCycleAnimation.hideAnimation(fatherView:bubbleView)
        }
      
    }
}


