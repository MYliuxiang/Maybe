//
//  CharPsitionLabel.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/11.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CharPsitionLabel: UILabel {
    
    var textStorage:NSTextStorage! = NSTextStorage()
    var layoutManager:NSLayoutManager! = NSLayoutManager()
    var textContainer:NSTextContainer! = NSTextContainer()
    override var text: String?{
        didSet{
            configWithLabel()
        }
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
        
    func characterRectAtIndex(index:Int) -> CGRect{
        
        if index > self.text!.count {
            return CGRect.zero
        }
        textContainer.size = self.bounds.size
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        let textRange = NSMakeRange(0, attributedText.length)
        attributedText.addAttribute(.font, value: self.font as Any, range: textRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: textRange)
        self.textStorage.setAttributedString(attributedText)
        
        let characterRange = NSMakeRange(index, 1)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
    }
    
    func configWithLabel(){
        
        textContainer.size = self.bounds.size
        textContainer.lineFragmentPadding = 0;
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        let textRange = NSMakeRange(0, attributedText.length)
        attributedText.addAttribute(.font, value: self.font as Any, range: textRange)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: textRange)
        self.textStorage.setAttributedString(attributedText)
        
    }
    
    
    
}
