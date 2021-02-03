//
//  VideoAnimationModel.swift
//  MayBe
//
//  Created by liuxiang on 2020/12/15.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

enum VAniType {
    case NomorAni,WaitAni
}


class VideoAnimationModel: BaseModel {

    var bodyText:BodyText?
    var speech:String?
    var headerText:String?
    var end:Bool?
    var animation:VAnimation?
    var actionCard:ActionCard?
    
    override func didFinishMapping() {
        

        guard let ani = animation else {return}
        guard let teachs = ani.teachingAni else {return}
        if ani.split == 0{
            ani.nextAni = teachs.first
        }
        for (index,subAni) in teachs.enumerated() {
            
            subAni.nextAni = (index == (teachs.count - 1)) ? teachs.first : teachs[index + 1]
            subAni.finishAni = (index == (teachs.count - 1)) ? nil : ani.endAni![index]
        }
    }
}

class GPUModel: BaseModel {
    
    
    var video:[VAnimation]?
    var input:Input?
    var query:Query?
    var intent:String?
    var audio:[GAudio]?
    var background:Background?
    var title:Title?

    
   
    
    

    var chatBox:ChatBox?
    var speech:String?
    var end:Bool?
    var animation:VAnimation?
    var promptBox:PromptBox?
//    var actionCard:ActionCard?
    
    override func didFinishMapping() {
        
        guard let ani = video else {
            return
        }
        
        for (index,subAni) in ani.enumerated() {
            subAni.nextAni = (index == (ani.count - 1)) ? nil : ani[index + 1]
        }
        
        

//        guard let ani = animation else {return}
//
//        guard let teachs = ani.teachingAni else {return}
//        if ani.split == 0{
//            ani.nextAni = teachs.first
//        }
//        for (index,subAni) in teachs.enumerated() {
//
//            subAni.nextAni = (index == (teachs.count - 1)) ? teachs.first : teachs[index + 1]
//            subAni.finishAni = (index == (teachs.count - 1)) ? nil : ani.endAni![index]
//        }
    }
}

enum BClass: String, HandyJSONEnum {
    case Regular = "regular" //常规背景
    case WrongAnswer = "wrong_answer" //红色背景
    case Congrats = "congrats" //绿色背景+点赞贴纸
    case WrongPronuanciation = "wrong_pronuanciation" //未定
    case unkown = ""
    
    func getBackColor() -> UIColor{
        var backColor:UIColor 
        
        switch self {
        case .Regular:
            backColor = .colorWithHexStr("#E2EFED")
            break
        case .WrongAnswer:
            backColor = .colorWithHexStr("#FF5C5C")

            break
        case .Congrats:
            backColor = .colorWithHexStr("#17E8CB")

            break
        case .WrongPronuanciation:
            backColor = .colorWithHexStr("#E2EFED")

            break
        default:
            backColor = .colorWithHexStr("#E2EFED")

            break
        }
        
        return backColor
        
    }

}

class Background: BaseModel {
    var bclass:BClass?
   
    override func mapping(mapper: HelpingMapper) {
           mapper <<<
               self.bclass <-- "class"
    }
}

enum IClass: String, HandyJSONEnum {
    case Placeholder = "placeholder" //…
    case WrongAnswer = "wrong_answer" //❌动态出现
    case SayWrong = "say_wrong" //❌静态保持
    case Congrats = "congrats" //✅动态出现
    case SayCongrats = "say_congrats" //✅静态保持
    case WrongPronunciation = "wrong_pronunciation" //wrong pronunciation
    case CorrectPronunciation = "correct_pronunciation" //wrong pronunciation
    case unknown = ""
  

}


class Input: BaseModel {
    var iclass:IClass?
    var placeholder:String?
    var pos:String?
    var content:String?
   
    override func mapping(mapper: HelpingMapper) {
           mapper <<<
               self.iclass <-- "class"
    }
}

class Query: BaseModel {
    var top:Top?
    var sub:String?
    var pos:Double?
    var content:String?
    var len:Double?

}

class Top: BaseModel {
    var unfold:String?
    var value:String?
}

class GAudio: BaseModel {
    var pos:Double?
    var speech:String?
}

enum TClass: String, HandyJSONEnum {
    case WrongAnswer = "wrong_answer" //红色wrong answer出现并左右摇摆 da2 cuo4 le直接出现
    case SayWrong = "say_wrong" //top：红色wrong answer保持静态 sub：da2 cuo4 le伴随语音从左到右变色
    case Congrats = "congrats" //top：绿色great出现并上下晃动 sub：hen3 hao3直接出现
    case SayCongrats = "say_congrats" //top：绿色great保持静态 sub：hen3 hao3伴随语音从左到右变色
    case WrongPronunciation = "wrong_pronunciation" //未定
    case unknown = ""
    
    func getNormal() -> UIColor {
        
        return .white
    }
    
    func getBorderColor() -> UIColor{
        
        var borderColor:UIColor
        switch self {
        
        case .WrongAnswer:
            borderColor = .colorWithHexStr("#FF5C5C")
            break
        case .SayWrong:
            borderColor = .colorWithHexStr("#FF5C5C")

            break
        case .Congrats:
            borderColor = .colorWithHexStr("#17E8CB")

            break
        case .SayCongrats:
            borderColor = .colorWithHexStr("#17E8CB")

            break
        case .WrongPronunciation:
            borderColor = .colorWithHexStr("#17E8CB")
            break
        default:
            borderColor = .colorWithHexStr("#17E8CB")
            break
        }
        
        return borderColor
    }
    
    
    func getTitleImage() -> UIImage{
        
        var image:UIImage
        switch self {
        
        case .WrongAnswer:
            image = UIImage(named: "wrong answer")!
            break
        case .SayWrong:
            image = UIImage(named: "wrong answer")!

            break
        case .Congrats:
            image = UIImage(named: "编组 3")!

            break
        case .SayCongrats:
            image = UIImage(named: "编组 3")!

            break
        case .WrongPronunciation:
            image = UIImage(named: "编组 3")!
            break
        default:
            image = UIImage(named: "编组 3")!
            break
        }
        
        return image
        
    }

}


class Title: BaseModel {
    var top:String?
    var tclass:TClass?
    var sub:Sub?
    
    override func mapping(mapper: HelpingMapper) {
           mapper <<<
               self.tclass <-- "class"
    }
}

class Sub: BaseModel {
    var unfold:String?
    var value:String?
}






class ChatBox: BaseModel {
    var zh:String?
    var voiceBegin:String?
    var voiceLen:String?
    var type:String?
    var mode:String?
    var en:String?
}

class PromptBox: BaseModel {
    var en:String?
    var zh:String?
    var type:String?
    var mode:String?
  
}



class AniTime: BaseModel  {
    var id:String?
    var endset:String?
    var offset:String?
    var nextAni:AniTime?
    var fishAni:AniTime?
        
}

extension AniTime:Equatable{
    static func == (lhs: AniTime, rhs: AniTime) -> Bool{
        return lhs.endset == rhs.endset && (lhs.offset != nil) == (rhs.offset != nil)
    }
}


class BodyText: BaseModel {
    var model:String?
    var value:String?
    var voiceBegin:Int?
    var voiceLen:Int?
    
}

class VAnimation: BaseModel {
    
    var id:String?
    var begin:String?
    var end:String?
    
    
    
    var split:Int?
    var endAni:[VAnimation]?
    var teachingAni:[VAnimation]?
    var finishAni:VAnimation?
    var nextAni:VAnimation?
    
}

class ActionCard: BaseModel {
    
    var mode:String?
    var value:String?
    var type:String?

}

