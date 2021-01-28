//
//  WCDataBaseTable.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/9.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

typealias kTABLE = WCDataBaseTable

class WCDataBaseTable: NSObject {
    /// 数据库 - 表名称
    private enum TableName: String {
        case diaiogueTable    = "diaiogueTable"
        case messageTable = "messageTable"
        case sessionTable = "sessionTable"
    }
    
    static var diaiogue : String {
        get {
            return TableName.diaiogueTable.rawValue
        }
    }
    
    static var message : String {
        get {
            return TableName.messageTable.rawValue
        }
    }
    
    static var session : String {
        get {
            return TableName.sessionTable.rawValue
        }
    }
}
