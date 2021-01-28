//
//  TrcParser.swift
//  Record
//
//  Created by liuxiang on 12/05/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

struct TrcModel {
    
    var trc:String?
    var alltime:Float? = 0
    var trctimeValue:Float? = 0
    var trctime:String?
    var timeList:[[String:Any]]?
        
}


class TrcParser: NSObject {
    
   open class func trcPraser(trcStr:String) -> [TrcModel] {
        
        var rootList = [TrcModel]()
        let array = trcStr.split(separator: "\n")
        for (_,tempStr) in array.enumerated() {
            
            //[00:00.76]<507>仍<392>然<292>倚<876>在<188>失<203>眠<737>夜 <438>望<360>天<1174>边<218>星<812>宿\n[00:06.66]<478>仍<286>然<346>听<1149>见<333>小<486>提<376>琴 <312>如<332>泣<696>似<356>诉<194>再<314>挑<164>逗
            var model = TrcModel()

            if tempStr.count < 8 {
                break
            }
            
            let str1 = String(tempStr).ex_substring(at: 3, length: 1)
            let str2 = String(tempStr).ex_substring(at: 6, length: 1)
            if str1 == ":" && str2 == "."{
                let lineArray = tempStr.split(separator: "]")
                if lineArray.count != 2 {
                    break
                }
                let timeStr = String(tempStr).ex_substring(at: 1, length: 8)
                let senconds = Float(timeStr.ex_substring(at: 0, length: 2))!
                let mins = Float(timeStr.ex_substring(at: 3, length: 5))!
                let time = senconds * 60 + mins
                model.trctime = timeStr
                model.trctimeValue = time
                
                let subStr = lineArray[1]
                let tempArray = subStr.split(separator: "<")
                var list = [[String:Any]]()
                var linetrcStr:String = ""
                var sum:Float = 0
                for tempArraySub in tempArray {
                    let Diclist = String(tempArraySub).split(separator: ">")
                    var dic = [String:Any]()
                    dic["time"] = Diclist[0]
                    dic["string"] = Diclist[1]
                    linetrcStr.append(String(Diclist[1]))
                    sum += Float(Diclist[0]) ?? 0
                    list.append(dic)
                }
                model.trc = linetrcStr
                model.alltime = sum / 1000
                model.timeList = list

            }
            rootList.append(model)
      }
            
           return rootList

     }
}

//   for subStr in lineArray {
//             if subStr.count > 8 {
//                 var rootDic = [String:Any]()
//
//                 let str1 = String(tempStr).ex_substring(at: 3, length: 1)
//                 let str2 = String(tempStr).ex_substring(at: 6, length: 1)
//                 if str1 == ":" && str2 == "." {
//                     let trcSubStr = String(lineArray.last!)
//
//                     var list = [Any]()
//
//                     let tempArray = trcSubStr.split(separator: "<")
//                     var linetrcStr:String = ""
//                     var sum:Float = 0
//                     for tempArraySub in tempArray {
//                         let Diclist = String(tempArraySub).split(separator: ">")
//                         var dic = [String:Any]()
//                         dic["time"] = Diclist[0]
//                         dic["string"] = Diclist[1]
//                         linetrcStr.append(String(Diclist[1]))
//                         sum += Float(Diclist[0]) ?? 0
//                         list.append(dic)
//
//                     }
//
//                     if linetrcStr.count != 0 {
//                         rootDic["lrc"] = linetrcStr
//                     }else{
//                         rootDic["lrc"] = trcSubStr
//                     }
//
//                     rootDic["alltime"] = sum/1000
//                     rootDic["lrctime"] = time
//                     rootDic["timeList"] = list
//                     rootList.append(rootDic)
//
//
//
//                 }
//
//             }
//         }
//     }
//
//     return rootList
//
// }
