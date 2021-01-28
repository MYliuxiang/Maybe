//
//  NetModel.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/16.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class NetModel: BaseModel {
       
    var id:Int? = nil
    var created_on:String? = nil
    var created_by:String? = nil
    var lily:String? = nil
    var you:String? = nil
    var createDateString: String?
       {
           guard let createDate = created_on, createDate.count > 0 ,createDate != "" else
             {
                 return ""
             }
           
           let date = Date(string: createDate)
           return date?.updateTimeToCurrennTime(timeStamp: (date?.ex_timestamp ?? 0) * 1000)
       }
    
}
