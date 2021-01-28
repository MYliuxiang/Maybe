//
//  LxKTVProgress.swift
//  Record
//
//  Created by liuxiang on 11/05/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LxKTVProgress: UIView {
     
    let lrcLab = UILabel()
    var text:String?{
        didSet{
            lrcLab.text = text
            lrcLab.sizeToFit()
            lrcLab.snp.makeConstraints { (make) in
                       make.edges.equalToSuperview()
            }
        }
    }
    
    var font:UIFont?{
        didSet{
            lrcLab.font = font
        }
    }
    
    var lrcColor:UIColor?{
        didSet{
            lrcLab.textColor = lrcColor
        }
    }
    
    override var backgroundColor: UIColor?{
        didSet{
            lrcLab.backgroundColor = backgroundColor
        }
    }
    
    
    var oKlrcColor:UIColor? = .yellow
    
    var textStorage:NSTextStorage! = NSTextStorage()
    var layoutManager:NSLayoutManager! = NSLayoutManager()
    var textContainer:NSTextContainer! = NSTextContainer()
    var lines:[Line]! = [Line]()
    var labers:[UILabel]! = [UILabel]()
    var totalwidth:CGFloat! = 0
    var progerss:CGFloat! = 0{
        didSet{
           creatSubLabes()

            for label in labers {
                label.width = 0
            }
            var width = totalwidth * progerss
            for(idx,myline) in lines.enumerated() {
                let lab = labers[idx]
                if width <= myline.width {
                    lab.width = width
                    break
                }else{
                    lab.frame = CGRect(x: myline.x, y: myline.y, width: myline.width, height: myline.height)
                    width =  width - myline.width
                }
            }
            
        }
    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setup()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setup()
       }
       
       func setup() {
        
        lrcLab.numberOfLines = 0
//        lrcLab.textAlignment = .center
        addSubview(lrcLab)
       
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)

       }
    
    
    
    //镂空文字
//       override func draw(_ rect: CGRect) {
//           let context = UIGraphicsGetCurrentContext()!
//           drawSubtractedText(text: text! as NSString, rect: frame, context: context)
//       }
//
//       func drawSubtractedText(text:NSString, rect:CGRect, context:CGContext){
//
//           //将当前图形状态推入堆栈
//           context.saveGState()
//           context.setBlendMode(.destinationOut)
//           let label = UILabel(frame: rect)
//           label.font = self.font
//           label.text = self.text
//           label.textAlignment = lrcLab.textAlignment
//           label.backgroundColor = lrcLab.backgroundColor
//           label.numberOfLines = lrcLab.numberOfLines
//           label.layer.draw(in: context)
//           context.restoreGState()
//
//       }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
//        guard labers.count == 0  else {
//            return
//        }
//        guard  self.text?.count != nil else {
//            return
//        }
        configWithLabel()
        
    }
       
    func creatSubLabes(){
        var oriRect = CGRect.zero
        var line:Line = Line()
        lines.removeAll()
                                         
                        
        for (idx,value) in self.text!.enumerated() {
            
            let idxrect = characterRectAtIndex(index: idx)

            totalwidth += idxrect.size.width
            if idxrect.origin.y == oriRect.origin.y {
                                 
                //是在同一行
                line.width! += idxrect.size.width
                line.height = idxrect.size.height
                line.text?.append(value)
                if idx == (self.text!.count - 1){
                    lines.append(line)
                }
                                             
            }else{
                  
                lines.append(line)
                //另外启一行
                oriRect = idxrect
                line.width = idxrect.size.width
                line.height = idxrect.size.height
                line.x = idxrect.origin.x
                line.y = idxrect.origin.y
                line.text = String(value)

            }
        }
                         
        for label in labers {
            label.removeFromSuperview()
        }
        labers.removeAll()
                          
                    
        for (_,myline) in lines.enumerated(){
                                         
            let label = UILabel()
            label.textColor = self.oKlrcColor
            label.font = lrcLab.font
            label.frame = CGRect(x: myline.x, y: myline.y, width: myline.width, height: myline.height)
            label.text = myline.text
            label.backgroundColor = .yellow
//            label.lineBreakMode = .byCharWrapping
            addSubview(label)
            labers.append(label)
        }
//        self.progerss = 0.5
    }
    
    
        
    func configWithLabel(){
        
        textContainer.size = self.lrcLab.bounds.size
        textContainer.lineFragmentPadding = 0;
        textContainer.maximumNumberOfLines = lrcLab.numberOfLines
        textContainer.lineBreakMode = lrcLab.lineBreakMode
        let attributedText = NSMutableAttributedString(string: lrcLab.text ?? "")
        let textRange = NSMakeRange(0, attributedText.length)
        attributedText.addAttribute(.font, value: lrcLab.font as Any, range: textRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = lrcLab.textAlignment
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: textRange)
        self.textStorage.setAttributedString(attributedText)
        
    }
    
    func characterRectAtIndex(index:Int) -> CGRect{
        
        if index > lrcLab.text!.count {
            return CGRect.zero
        }
        
        let characterRange = NSMakeRange(index, 1)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
    }
    

}
