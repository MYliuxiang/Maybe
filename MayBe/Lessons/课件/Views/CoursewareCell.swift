//
//  CoursewareCell.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/10.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class CoursewareCell: UICollectionViewCell {
    
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab22: UILabel!
 
    @IBOutlet weak var ylab2: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var textlayout:YYTextLayout?
    var seleted:Bool?{
        didSet{
            if seleted ?? false {
                bgView.backgroundColor = .colorWithHexStr("#17E8CB")
            }else{
                bgView.backgroundColor = .white
            }
        }
    }
    var model:CoursewareSubModel?{
        didSet{
            lab1.text = model?.pinyins[0]
//            lab2.text = model?.titles[0]
            lab22.text = model?.titles[1]
            ylab2.text = model?.titles[0]
            ylab2.font = .systemFont(ofSize: 32, weight: .thin)

//            let attrStr = NSMutableAttributedString(string: lab2.text ?? "")
//            attrStr.addAttributes([NSAttributedString.Key.kern:10], range: NSMakeRange(0, attrStr.length - 1))
//            lab2.attributedText = attrStr
//            lab22.text = model?.titles[1]
            //            lab22.snp.makeConstraints { (make) in
            //                make.left.equalTo((model?.widths[0])!)
            //            }
            bgView.snp.remakeConstraints{ (make) in
                make.width.equalTo((model?.widths[0])!)
            }
            
        }
    }
    
    var selectdPins:[String] = [String](){
        didSet{
            let attrStr = NSMutableAttributedString(string: lab1.text ?? "")
            attrStr.yy_color = .colorWithHexStr("#131616")
            for item in selectdPins {
                if (lab1.text!.range(of: item) != nil){
                    let range = lab1.text!.range(of: item)
                    let location = lab1.text!.distance(from: lab1.text!.startIndex, to:range!.lowerBound)
                    attrStr.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.colorWithHexStr("#FF5C5C")], range: NSRange(location: location, length: item.count ))
                }
            }
            lab1.attributedText = attrStr
           
        }
    }
    
    var selecdtwords:[String] = [String](){
        didSet{
            
            let attrStr = NSMutableAttributedString(string: model?.titles[0] ?? "")
            attrStr.yy_color = .colorWithHexStr("#131616")
            attrStr.yy_font = .systemFont(ofSize: 32, weight: .thin)
//            attrStr.addAttributes([NSAttributedString.Key.kern:0], range: NSMakeRange(0, attrStr.length - 1))
            for item in selecdtwords {
                if (ylab2.text!.range(of: item) != nil){
                    let range = ylab2.text!.range(of: item)
                    let location = ylab2.text!.distance(from: ylab2.text!.startIndex, to:range!.lowerBound)
                    attrStr.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.colorWithHexStr("#FF5C5C")], range: NSRange(location: location, length: item.count ))
                }
            }
//            let errorContainer = YYTextContainer(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 60))
//            self.textlayout = YYTextLayout(container: errorContainer, text: attrStr)
//            ylab2.textLayout = textlayout
            ylab2.attributedText = attrStr
                        
        }
    }
    
    
    func rectYlablIndex(forIndex:Int) -> CGFloat{
        
//        guard (self.textlayout != nil) else {
//            return 0.0
//        }
//        let rect = self.textlayout?.rect(for: YYTextRange(range: NSRange(location: forIndex, length: 1)))
//        let cellrect = self.ylab2.convert(rect!, to: self)
//        return cellrect.minX + cellrect.width / 2
        
        return (model?.widths[0]) ?? 0.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 2
        bgView.layer.masksToBounds = true
        ylab2.font = .systemFont(ofSize: 32, weight: .thin)
        
    }
    
}
