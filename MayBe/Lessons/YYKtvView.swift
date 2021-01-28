//
//  YYKtvView.swift
//  MayBe
//
//  Created by liuxiang on 2020/8/3.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class YYKtvView: UIView {

    var lrcLab:YYLabel!
    var lrctext:String?{
        didSet{
            
            if(lrctext?.count == 0){
                lines.removeAll()
                for lab in labers {
                    lab.removeFromSuperview()
                }
                labers.removeAll()
                lrcLab.text = ""
                return
            }
            
            let attaStr = NSMutableAttributedString(string: lrctext!)
            attaStr.yy_font = .systemFont(ofSize: 28, weight: .medium)
            attaStr.yy_alignment = .center
            attaStr.yy_maximumLineHeight = 35
            attaStr.yy_minimumLineHeight = 35
            attaStr.yy_color = .gray
            attaStr.yy_lineBreakMode = .byCharWrapping
            
            

            let container = YYTextContainer(size: CGSize(width: self.size.width, height: 159 - 44))
            let layout = YYTextLayout(container: container, text: attaStr)
            lrcLab.textLayout = layout
//            lrcLab.sizeToFit()
            lrcLab.numberOfLines = 0
            lrcLab.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
//                make.height.equalTo(layout?.textBoundingRect.size.height as! ConstraintRelatableTarget)
                //               make.center.equalToSuperview()
                //                make.bottom.equalToSuperview()
            }
                        
            guard layout?.lines != nil else {
                return
            }

            lines.removeAll()
            for lab in labers {
                lab.removeFromSuperview()
            }
            labers.removeAll()

            
            totalwidth = 0
            for indx in 0 ..< (layout?.lines.count)! {

                let yline =  layout?.lines[indx]
                var line:Line = Line()
                line.x = yline?.left
                line.y = yline?.top
                line.width = yline?.width
                line.height = yline?.height
                line.text = self.lrctext?.ex_substring(at: (yline?.range.location)!, length: (yline?.range.length)!)
                self.totalwidth += line.width
                lines.append(line)
            

                let label = YYLabel()
//                label.textColor = .red
                label.backgroundColor = .white
//                label.font = .systemFont(ofSize: 28.2, weight: .medium)

                let attaStr1 = NSMutableAttributedString(string: line.text!)
                attaStr1.yy_font = .systemFont(ofSize: 28.2, weight: .medium)
//                attaStr1.yy_alignment = .center
                attaStr1.yy_maximumLineHeight = 35
                attaStr1.yy_minimumLineHeight = 35
                attaStr1.yy_color = .colorWithHexStr("#26D9D9")
                attaStr1.yy_lineBreakMode = .byClipping
                label.attributedText = attaStr1
//                label.text = line.text!
                label.lineBreakMode = .byClipping
                

                
//                let container1 = YYTextContainer(size: CGSize(width: 1000, height: 35))
//                let layout1 = YYTextLayout(container: container1, text: attaStr1)
//                label.width = layout1?.textBoundingRect.size.width as! CGFloat
//                label.textLayout = layout1
//                label.bounds = layout1?.textBoundingRect as! CGRect
                
                self.lrcLab.addSubview(label)
                labers.append(label)
                
                label.frame = CGRect(x: line.x, y: line.y, width: 0, height: line.height)
            }

            
            self.snp.makeConstraints { (make) in
                make.bottom.equalTo(lrcLab)
            }

                        
        }
    }
    
    var lines:[Line]! = [Line]()
    var labers:[YYLabel]! = [YYLabel]()
    var totalwidth:CGFloat! = 0
    var progerss:CGFloat! = 0{
        didSet{

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
        
        lrcLab = YYLabel()
//        lrcLab.frame  = CGRect(x: 0, y: 0, width: 300, height: 200)
//        lrcLab.font = .systemFont(ofSize: 28, weight: .medium)
        lrcLab.numberOfLines = 0
        lrcLab.preferredMaxLayoutWidth = self.width
        addSubview(lrcLab)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

}
