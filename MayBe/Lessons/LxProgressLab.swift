//
//  LxProgressLab.swift
//  Record
//
//  Created by liuxiang on 11/05/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

struct Line {
    var x:CGFloat! = 0;
    var y:CGFloat! = 0;
    var width:CGFloat! = 0;
    var height:CGFloat! = 0;
    var text:String! = "";
}

//class LxProgressLab: UILabel {
//      
//    var textStorage:NSTextStorage! = NSTextStorage()
//    var layoutManager:NSLayoutManager! = NSLayoutManager()
//    var textContainer:NSTextContainer! = NSTextContainer()
//    var lines:[Line]! = [Line]()
//    var progerss:Float! = 0{
//        didSet{
//            
//            
//            
//            
//            
//            
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//    
//    func setup() {
//        textStorage.addLayoutManager(layoutManager)
//        layoutManager.addTextContainer(textContainer)
//
//    }
//    
//    //镂空文字
//    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()!
//        drawSubtractedText(text: text! as NSString, rect: frame, context: context)
//    }
//    
//    func drawSubtractedText(text:NSString, rect:CGRect, context:CGContext){
//
//        //将当前图形状态推入堆栈
//        context.saveGState()
//        context.setBlendMode(.destinationOut)
//        let label = UILabel(frame: rect)
//        label.font = self.font
//        label.text = self.text
//        label.textAlignment = self.textAlignment
//        label.backgroundColor = self.backgroundColor
//        label.numberOfLines = self.numberOfLines
//        label.layer.draw(in: context)
//        context.restoreGState()
//                             
//    }
//    
//
//
//  
//    
//  
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        configWithLabel()
//        
//        
//        var oriRect = CGRect.zero
//        var line:Line = Line()
//        
//        for (idx,value) in self.text!.enumerated() {
//            let idxrect = characterRectAtIndex(index: idx)
//            if idxrect.origin.y == oriRect.origin.y {
//                //是在同一行
//                line.width! += idxrect.size.width
//                line.text?.append(value)
//                
//                
//            }else{
//                //另外启一行
//                lines.append(line)
//                oriRect = idxrect
//                line.width = idxrect.size.width
//                line.height = idxrect.size.height
//                line.x = idxrect.origin.x
//                line.y = idxrect.origin.y
//                line.text = ""
//                
//            }
//            
//
//        }
//        
//        print(lines)
//        
//        
//        
//        
//        
//        
//        
//        
////        let context = UIGraphicsGetCurrentContext()!
////               drawSubtractedText(text: text! as NSString, rect: frame, context: context)
////        draw(rect)
//    }
//    
//    func configWithLabel(){
//        
//        textContainer.size = self.bounds.size
//        textContainer.lineFragmentPadding = 0;
//        textContainer.maximumNumberOfLines = self.numberOfLines
//        textContainer.lineBreakMode = self.lineBreakMode
//        let attributedText = NSMutableAttributedString(string: self.text ?? "")
//        let textRange = NSMakeRange(0, attributedText.length)
//        attributedText.addAttribute(.font, value: self.font, range: textRange)
//        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = self.textAlignment
//        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: textRange)
//        self.textStorage.setAttributedString(attributedText)
//
//
//    }
//    
//    func characterRectAtIndex(index:Int) -> CGRect{
//        
//        if index > self.text!.count {
//            return CGRect.zero
//        }
//        
//        let characterRange = NSMakeRange(index, 1)
//        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
//        
//        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
//     
//    }
//   
//
//}
