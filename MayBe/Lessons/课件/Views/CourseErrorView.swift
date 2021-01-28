//
//  CourseErrorView.swift
//  MayBe
//
//  Created by liuxiang on 2020/11/11.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit


enum ToneEnum:Int{
    case zero = 0
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
   
    
    func getErrorImgeStr() -> String {
        switch self {
        case .zero:
            return "1声错"
        case .first:
            return "1声错"
        case .second:
            return "2声错"
        case .third:
            return "3声错"
            
        default:
            return "4声错"
        }
    }
    
    func getSucessImgeStr() -> String {
        switch self {
        case .zero:
            return "1声对"
        case .first:
            return "1声对"
        case .second:
            return "2声对"
        case .third:
            return "3声对"
            
        default:
            return "4声对"
        }
    }
    
}

class CourseErrorView: UIView {

    lazy var errorLab:YYLabel = {
        let label = YYLabel()
        label.font = .customName("SemiBold", size: 28)
        label.textColor = .colorWithHexStr("#131616")
        return label
    }()
        
    lazy var sucessLab:YYLabel = {
        let label = YYLabel()
        label.font = .customName("SemiBold", size: 28)
        label.textColor = .colorWithHexStr("#131616")

        return label
    }()
    
    lazy var errorImgView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "错误icon")
        return imgView
    }()
    
    lazy var sucessImgView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "正确icon")
        return imgView
    }()
    
    lazy var errorToneImg:UIImageView = {
        let imgView = UIImageView()
        imgView.size = CGSize(width: 10, height: 8)
        return imgView
    }()
    
    lazy var sucessToneImg:UIImageView = {
        let imgView = UIImageView()
        imgView.size = CGSize(width: 10, height: 8)
        return imgView
    }()
    
//    var sucessArry:[String]?
//    var errorArry:[String]?
//
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.addSubview(errorImgView)
        self.addSubview(errorLab)
        self.addSubview(sucessImgView)
        self.addSubview(sucessLab)
    }

}

extension CourseErrorView{
    
    convenience init(errorArray:[String],sucessArray:[String]) {
        self.init()
        setup()
        
        guard (errorArray.count == 3 && sucessArray.count == 3) else {
            
            return
        }
        
        let errorStr = errorArray[0...(errorArray.count - 2)].joined(separator: "")
        let sucessStr = sucessArray[0...(errorArray.count - 2)].joined(separator: "")
                
        let errorAtta = NSMutableAttributedString(string: errorStr)
        errorAtta.yy_font = .customName("SemiBold", size: 28)
        errorAtta.yy_lineBreakMode = .byCharWrapping
        errorAtta.yy_color = .colorWithHexStr("#131616")
        
        let successAtta = NSMutableAttributedString(string: sucessStr)
        successAtta.yy_font = .customName("SemiBold", size: 28)
        successAtta.yy_lineBreakMode = .byCharWrapping
        successAtta.yy_color = .colorWithHexStr("#131616")

        //处理错误
        if errorArray.first != sucessArray.first {
            //声母错误 需要全部显示红色
            errorAtta.yy_color = .colorWithHexStr("#FF5C5C")
            successAtta.yy_color = .colorWithHexStr("#17E8CB")

        }else if(errorArray[1] != sucessArray[1]){
            //韵母错误

            let range = errorStr.range(of: errorArray[1])
            let location = errorStr.distance(from: errorStr.startIndex, to:range!.lowerBound)
            let highlight = YYTextHighlight()
            highlight.setColor(.colorWithHexStr("#FF5C5C"))
            errorAtta.yy_setTextHighlight(NSRange(location: location, length: errorArray[1].count), color: .colorWithHexStr("#FF5C5C"), backgroundColor: nil) { (view, attrString, range, rect) in
                
            }
            
            let range1 = sucessStr.range(of: sucessArray[1])
            let location1 = sucessStr.distance(from: sucessStr.startIndex, to:range1!.lowerBound)
            successAtta.yy_setTextHighlight(NSRange(location: location1, length: sucessArray[1].count), color: .colorWithHexStr("#17E8CB"), backgroundColor: nil) { (view, attrString, range, rect) in
                
            }
        }
        
        
//        YYImage *image = [YYImage imageWithData:data scale:2];//修改表情大小
//                       image.preloadAllAnimatedImageFrames = YES;
//                       YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
//                       NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
//                       [text appendAttributedString:attachText];

//        let img = UIImageView()
//        img.size = CGSize(width: 20, height: 20)
//        img.image = UIImage(named: "1声对")
//        let attachtext = NSMutableAttributedString.yy_attachmentString(withContent: img, contentMode: .center, width: 20, ascent: 10, descent: 10)
////        errorAtta.append(attachtext)
//        errorAtta.insert(attachtext, at: 1)
//

        let errorContainer = YYTextContainer(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 60))
        let errorlayout = YYTextLayout(container: errorContainer, text: errorAtta)
        errorLab.textLayout = errorlayout
        
        //获取声调图片
        let errorType = ToneEnum(rawValue: Int(errorArray[2]) ?? 0)!
        errorToneImg.image = UIImage(named: errorType.getErrorImgeStr())
    
        //获取声调位置
        let positon = getFinalsPositon(finals: errorArray[1])
        let rect : CGRect! = errorlayout?.rect(for:  YYTextRange(range: NSRange(location: errorArray[0].count + positon, length: 1)))
        errorToneImg.bottom = rect.minY + 5
        errorToneImg.left = rect.minX + (rect.width - 10) / 2
        errorLab.addSubview(errorToneImg)

        
        let sucessContainer = YYTextContainer(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 60))
        let sucesslayout = YYTextLayout(container: sucessContainer, text: successAtta)
        sucessLab.textLayout = sucesslayout
        
        //获取声调图片
        let sucessType = ToneEnum(rawValue: Int(sucessArray[2]) ?? 0)!
        sucessToneImg.image = UIImage(named: sucessType.getSucessImgeStr())
    
        //获取声调位置
        let positon1 = getFinalsPositon(finals: sucessArray[1])
        let rect1 : CGRect! = sucesslayout?.rect(for:  YYTextRange(range: NSRange(location: sucessArray[0].count + positon1, length: 1)))
        sucessToneImg.bottom = rect1.minY + 5
        sucessToneImg.left = rect1.minX + (rect1.width - 10) / 2
        sucessLab.addSubview(sucessToneImg)       
        
        self.errorImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
        
        self.errorLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.errorImgView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        self.sucessImgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.errorLab.snp.right).offset(24)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
        
        self.sucessLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.sucessImgView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 24
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.colorWithHexStr("#C5D3D3").cgColor
           
    }
    
    
    func configlabel(errorArray:[String],sucessArray:[String]) {
        guard (errorArray.count == 3 && sucessArray.count == 3) else {
            
            return
        }
        
        let errorStr = errorArray[0...(errorArray.count - 2)].joined(separator: "")
        let sucessStr = sucessArray[0...(errorArray.count - 2)].joined(separator: "")
                
        let errorAtta = NSMutableAttributedString(string: errorStr)
        errorAtta.yy_font = .customName("SemiBold", size: 28)
        errorAtta.yy_lineBreakMode = .byCharWrapping
        errorAtta.yy_color = .colorWithHexStr("#131616")
        
        let successAtta = NSMutableAttributedString(string: sucessStr)
        successAtta.yy_font = .customName("SemiBold", size: 28)
        successAtta.yy_lineBreakMode = .byCharWrapping
        successAtta.yy_color = .colorWithHexStr("#131616")

        //处理错误
        if errorArray.first != sucessArray.first {
            //声母错误 需要全部显示红色
            errorAtta.yy_color = .colorWithHexStr("#FF5C5C")
            successAtta.yy_color = .colorWithHexStr("#17E8CB")

        }else if(errorArray[1] != sucessArray[1]){
            //韵母错误

            let range = errorStr.range(of: errorArray[1])
            let location = errorStr.distance(from: errorStr.startIndex, to:range!.lowerBound)
            let highlight = YYTextHighlight()
            highlight.setColor(.colorWithHexStr("#FF5C5C"))
            errorAtta.yy_setTextHighlight(NSRange(location: location, length: errorArray[1].count), color: .colorWithHexStr("#FF5C5C"), backgroundColor: nil) { (view, attrString, range, rect) in
                
            }
            
            let range1 = sucessStr.range(of: sucessArray[1])
            let location1 = sucessStr.distance(from: sucessStr.startIndex, to:range1!.lowerBound)
            successAtta.yy_setTextHighlight(NSRange(location: location1, length: sucessArray[1].count), color: .colorWithHexStr("#17E8CB"), backgroundColor: nil) { (view, attrString, range, rect) in
                
            }
        }
        
        
//        YYImage *image = [YYImage imageWithData:data scale:2];//修改表情大小
//                       image.preloadAllAnimatedImageFrames = YES;
//                       YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
//                       NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
//                       [text appendAttributedString:attachText];

//        let img = UIImageView()
//        img.size = CGSize(width: 20, height: 20)
//        img.image = UIImage(named: "1声对")
//        let attachtext = NSMutableAttributedString.yy_attachmentString(withContent: img, contentMode: .center, width: 20, ascent: 10, descent: 10)
////        errorAtta.append(attachtext)
//        errorAtta.insert(attachtext, at: 1)
//

        let errorContainer = YYTextContainer(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 60))
        let errorlayout = YYTextLayout(container: errorContainer, text: errorAtta)
        errorLab.textLayout = errorlayout
        
        //获取声调图片
        let errorType = ToneEnum(rawValue: Int(errorArray[2]) ?? 0)!
        errorToneImg.image = UIImage(named: errorType.getErrorImgeStr())
    
        //获取声调位置
        let positon = getFinalsPositon(finals: errorArray[1])
        let rect : CGRect! = errorlayout?.rect(for:  YYTextRange(range: NSRange(location: errorArray[0].count + positon, length: 1)))
        errorToneImg.bottom = rect.minY + 5
        errorToneImg.left = rect.minX + (rect.width - 10) / 2
        errorLab.addSubview(errorToneImg)

        
                    
        
        
        let sucessContainer = YYTextContainer(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 60))
        let sucesslayout = YYTextLayout(container: sucessContainer, text: successAtta)
        sucessLab.textLayout = sucesslayout
        
        //获取声调图片
        let sucessType = ToneEnum(rawValue: Int(sucessArray[2]) ?? 0)!
        sucessToneImg.image = UIImage(named: sucessType.getSucessImgeStr())
    
        //获取声调位置
        let positon1 = getFinalsPositon(finals: sucessArray[1])
        let rect1 : CGRect! = sucesslayout?.rect(for:  YYTextRange(range: NSRange(location: sucessArray[0].count + positon1, length: 1)))
        sucessToneImg.bottom = rect1.minY + 5
        sucessToneImg.left = rect1.minX + (rect1.width - 10) / 2
        sucessLab.addSubview(sucessToneImg)
        
        self.errorImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
        
        self.errorLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.errorImgView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        self.sucessImgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.errorLab.snp.right).offset(24)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
        
        self.sucessLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.sucessImgView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 24
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.colorWithHexStr("#C5D3D3").cgColor
           
    }
    
    func getFinalsPositon(finals:String)->Int{
        
        return 0
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()

    }
    
}
