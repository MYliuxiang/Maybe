//
//  CoursewareModel.swift
//  MayBe
//
//  Created by liuxiang on 2020/10/10.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

protocol Copyable {
    func copy() -> Copyable
}


class CoursewareModel: BaseModel,Copyable {
    
    var id:String?
    var name:String?
    var pinyin:[String]?
    var words:[String]?
    var pySymbol:[String]?

    var separate:[Int]?
    var eng:String?
    var speech:String?
     
    var contetns:[CoursewareSubModel] = [CoursewareSubModel]()
    var translate:[Translate]?
    
    var errors:[CourseErrorModel]?
    
    func copy() -> Copyable {
        
        let model = CoursewareModel()
        model.id = self.id
        model.name = self.name
        model.pinyin = self.pinyin
        model.words = self.words
        model.pySymbol = self.pySymbol
        model.separate = self.separate
        model.eng = self.eng
        model.speech = self.speech
        model.contetns = self.contetns
        model.translate = self.translate
        model.errors = self.errors
        
       

        
        return model

    }
    

    override func didFinishMapping() {
        
        //0 3 4 5
        var index = 0
        for i in 0 ..< separate!.count{
            
            let parray = pinyin![index ... (separate![i] - 1)]
            let warray = words![index ... (separate![i] - 1)]
            let pyarray = pySymbol![index ... (separate![i] - 1)]
            let pystr = pyarray.joined(separator: "")

            if parray.last?.count == 0 {
                //标点符号
                let pin = parray[0 ... (parray.count - 2)].joined(separator: "")
                let word = warray[0 ... (warray.count - 2)].joined(separator: "")
                let model = CoursewareSubModel()
                model.titles[0] = pin
                model.pinyins[0] = word
                model.pySymbolStr = pystr
                let width1 = pin.ex_width(with: .customName("SemiBold", size: 20))
                let width2 = word.ex_kernWidth(with: .systemFont(ofSize: 32,weight: .thin),kern:0)
                let width = (width1 > width2 ? width1:width2) + 1
                model.widths[0] = width
                contetns.append(model)
                
                model.titles[1] = warray.last!
                model.pinyins[1] = parray.last!
                
                let width21 = model.pinyins[1].ex_width(with: .customName("SemiBold", size: 20))
                let width22 = model.titles[1].ex_kernWidth(with: .systemFont(ofSize: 32),kern:0)
                let twidth = (width21 > width22 ? width21:width22) + 1
                model.widths[1] = twidth
                
                
            }else{
                let pin = parray.joined(separator: "")
                let word = warray.joined(separator: "")
                let model = CoursewareSubModel()
                model.titles[0] = word
                model.pinyins[0] = pin
                model.pySymbolStr = pystr
                let width1 = pin.ex_width(with: .customName("SemiBold", size: 20))
                let width2 = word.ex_kernWidth(with: .systemFont(ofSize: 32,weight: .thin),kern:0)
                let width = (width1 > width2 ? width1:width2) + 1
                model.widths[0] = width
                contetns.append(model)
            }

            if i == separate!.count - 1{
                let parray1 = pinyin![separate![i] ... pinyin!.count - 1]
                let warray1 = words![separate![i] ... words!.count - 1]
                let pyarray1 = pySymbol![separate![i] ... pySymbol!.count - 1]

                let py = pyarray1.joined(separator: "")

                if parray1.last?.count == 0 {
                    //标点符号
//                    let pin = parray1.last!
                    let pin = parray1.prefix(parray1.count - 1).joined(separator: "")
                    let word = warray1.prefix(warray1.count - 1).joined(separator: "")
                    let model = CoursewareSubModel()
                    model.titles[0] = word
                    model.pinyins[0] = pin
                    model.pySymbolStr = py
                    let width1 = pin.ex_width(with: .customName("SemiBold", size: 20))
                    let width2 = word.ex_kernWidth(with: .systemFont(ofSize: 32,weight: .thin),kern:0)
                    let width = (width1 > width2 ? width1:width2) + 1
                    model.widths[0] = width
                    contetns.append(model)
                    
                    model.titles[1] = warray1.last!
                    model.pinyins[1] = parray1.last!
                    
                    let width21 = model.pinyins[1].ex_width(with: .customName("SemiBold", size: 20))
                    let width22 = model.titles[1].ex_kernWidth(with: .systemFont(ofSize: 32),kern:0)
                    let twidth = (width21 > width22 ? width21:width22) + 1
                    model.widths[1] = twidth
                    
                }else{
                    let pin = parray.joined(separator: "")
                    let word = warray.joined(separator: "")
                    let model = CoursewareSubModel()
                    model.titles[0] = pin
                    model.pinyins[0] = word
                    model.pySymbolStr = py

                    let width1 = pin.ex_width(with: .customName("SemiBold", size: 20))
                    let width2 = word.ex_kernWidth(with: .systemFont(ofSize: 32),kern:0)
                    let width = (width1 > width2 ? width1:width2) + 1
                    model.widths[0] = width
                    contetns.append(model)
                }                
            }
            index = separate![i]
            
            
        }
        for (index, value) in contetns.enumerated() {
            value.translate = translate?[index]
        }

      
    }
  
    
}

class CoursewareSubModel: BaseModel {

    var titles:[String] = [String](repeating: "", count: 2)
    var indexs:[Int] = [Int]()
    var pinyins:[String] = [String](repeating: "", count: 2)
    var widths:[CGFloat] = [CGFloat](repeating: 0, count: 2)
    var pySymbolStr:String = ""
    var translate:Translate?
  
}

class Translate: BaseModel {

    var partsOfSpeech:String?
    var text:String?
     
}


class CourseErrorModel: BaseModel {
    var wrong:[String]?
    var right:[String]?
    var index:Int?
}



