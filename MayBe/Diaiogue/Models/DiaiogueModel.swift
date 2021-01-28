//
//  DiaiogueModel.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/9.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit
import WCDBSwift

enum SendType: Int {
    case mine = 0
    case Lili = 1
}

class DiaiogueModel: BaseModel, TableCodable {
    
    /// 主键自增id
    var identifier: Int? = nil
    var text:[String]? = nil
    var sendType:Int? = nil
    var id:Int? = nil
    var created_on:String? = nil
    var created_by:String? = nil
    //聊天类型
    var msgType: Int? = 1
    var msgStatus:Bool? = true

    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DiaiogueModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier
        case text
        case sendType
        case msgType
        case id
        case created_on
        case created_by


        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .identifier: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }
}

