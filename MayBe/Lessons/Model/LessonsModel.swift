//
//  LessonsModel.swift
//  MayBe
//
//  Created by liuxiang on 2020/7/9.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class DisPlayModel: BaseModel {

    var text:String?
    var trans:String?
    
    
}

class Animation: BaseModel {

    var t1:Int?
    var t0:Int?
    var modeName:String?
    var aniName:String?

    
    
}

class LessonsModel: BaseModel {

    var display:DisPlayModel?
    var speech:String?
    var content:String?
    var end:Bool?
    
    var animations:[Animation]?
    
}

class TipModel: BaseModel {

    var lists:[String]?
    
}

class LsessonsBModel:BaseModel{
    var  id:String?
    var  type:String?
    var  name:String?
    var  score:String?
    var  icon:String?
    var  description:String?    
    var contents:[Courseware]?
 
}

class Courseware:BaseModel{
    
    var  id:String?
    var  name:String?
    var  score:String?
    
}

class U3dAniModel:BaseModel{
    var  ModelName:String! = "lily"
    var  AniName:String! = ""
    var  isSpeak:Int! = 1
    
}



