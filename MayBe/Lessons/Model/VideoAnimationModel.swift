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

    var chatBox:ChatBox?
    var speech:String?
    var end:Bool?
    var animation:VAnimation?
    var promptBox:PromptBox?
    var background:Background?
//    var actionCard:ActionCard?
    
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

class Background: BaseModel {
    var mode:String?
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

