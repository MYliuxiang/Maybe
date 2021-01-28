//
//  LxWCDBManger.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/9.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit
import WCDBSwift

fileprivate struct WCDataBasePath {
    
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                     .userDomainMask,
                                                     true).last! + "/LXWCDB/Diaiogue.db"
}


class LxWCDBManger: NSObject {
    static let shared = LxWCDBManger()
    let dataBasePath = URL(fileURLWithPath: WCDataBasePath().dbPath)
    var dataBase: Database?
    
    
    private override init() {
        super.init()
        
        dataBase = createDb()
    }
    ///创建表
    
    private func createDb() -> Database {
        
        debugPrint("数据库路径==\(dataBasePath.absoluteString)")
        
        return Database(withFileURL: dataBasePath)
        
    }
    
    
    ///创建表
    func createTable<T: TableDecodable>(table: String, of ttype:T.Type) -> Void {
        do {
            try dataBase?.create(table: table, of:ttype)
        } catch let error {
            debugPrint("create table error \(error.localizedDescription)")
        }
    }
    
    
    ///插入
    func insertToDb<T: TableEncodable>(objects: [T], intoTable table: String) -> Void {
        
        do {
            try dataBase?.insert(objects: objects, intoTable: table)
        } catch let error {
            debugPrint(" insert obj error \(error.localizedDescription)")
        }
    }
    
    ///修改 on修改(某一属性或者全部）
    func updateToDb<T: TableEncodable>(table: String, on propertys:[PropertyConvertible],with object:T,where condition: Condition? = nil) -> Void {
        do {
            try dataBase?.update(table: table, on: propertys, with: object, where: condition)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
        }
    }
    
    ///删除
    func deleteFromDb(fromTable: String, where condition: Condition? = nil) -> Void {
        do {
            try dataBase?.delete(fromTable: fromTable, where:condition)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }
    
    //获取所有数据
    func getAllFromDB<T:TableDecodable>(fromTable:String) ->[T]?{
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable))!
            return allObjects
            
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
    /*
     let objects = LxWCDBManger.shared.qureyFromDb(fromTable: kTABLE.diaiogue, cls: DiaiogueModel.self, orderBy: [DiaiogueModel.Properties.identifier.asOrder(by: .descending)], pageSize: 20, pageNumber: 0)
     
     */
    
    //分页查询
    func qureyFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type,wehre condition: Condition? = nil,orderBy orderList:[OrderBy]? = nil,pageSize:Int,pageNumber:Int) -> [T]? {
        
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where:condition, orderBy:orderList, limit: pageSize,offset: pageSize * pageNumber))!
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
    //查询
    func qureyFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil,orderBy orderList:[OrderBy]? = nil) -> [T]? {
        
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where:condition, orderBy:orderList))!
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
 
    
    ///删除数据表
    func dropTable(table: String) -> Void {
        do {
            try dataBase?.drop(table: table)
        } catch let error {
            debugPrint("drop table error \(error)")
        }
    }
    
    /// 删除所有与该数据库相关的文件
    func removeDbFile() -> Void {
        do {
            try dataBase?.close(onClosed: {
                try dataBase?.removeFiles()
            })
        } catch let error {
            debugPrint("not close db \(error)")
        }
    }
    
}

