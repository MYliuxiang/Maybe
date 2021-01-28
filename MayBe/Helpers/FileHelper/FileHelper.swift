//
//  FileHelper.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/30.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class FileHelper: NSObject {
    
    //获取Documents
    static func getDocument() ->URL{
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        return url
    }
    
    //获取Caches
    static func getCaches() ->URL{
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .cachesDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        
        return url
    }
    
    
    
    //获取Library
    static func getLibrary() ->URL{
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .cachesDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        
        return url
    }
    
    //获取temp
    static func getTemp(file:String) ->URL{
        
        let url = URL(fileURLWithPath: NSHomeDirectory().appending("/tmp").appending(file))
        return url
    }
    
    
    
    //判断文件夹或文件是否存在
    static func fileExists(path:String) -> Bool{
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: path)
        return exist
    }
    
    //创建文件夹
    static func createFolder(name:String,baseUrl:URL){
        let manager = FileManager.default
        let folder = baseUrl.appendingPathComponent(name, isDirectory: true)
        let exist = manager.fileExists(atPath: folder.path)
        if !exist {
            try! manager.createDirectory(at: folder, withIntermediateDirectories: true,
                                         attributes: nil)
        }
    }
    
    //创建文件
    @discardableResult
    static func createFile(name:String, fileBaseUrl:URL) -> URL?{
        let manager = FileManager.default
        let file = fileBaseUrl.appendingPathComponent(name)
        print("文件: \(file)")
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let createSuccess = manager.createFile(atPath: file.path,contents:nil,attributes:nil)
            return file
        }
        return nil
    }
    
    //删除文件
    static func removeFile(fileUrl:URL){
        let manager = FileManager.default
        try! manager.removeItem(at: fileUrl)
        
    }
    
    //删除目录下所有的文件
    static func removeFolder(fileUrl:URL){
        let manager = FileManager.default
        
        guard let fileArray = manager.subpaths(atPath: fileUrl.path) else {
            return
        }
        for fn in fileArray{
            try! manager.removeItem(atPath: fileUrl.path + "/\(fn)")
        }
        
    }
    //获取文件实际大小
    static func getFileSize(path:URL)-> Int64{
        let manager = FileManager.default
        //结果为Dictionary类型
        guard  let attributes = try? manager.attributesOfItem(atPath: path.path) else {
            return 0
        }
        return attributes[.size] as! Int64
    }
    
    ///获取文件夹大小
    static  func getFolderSize(path:URL)-> Int64 {
        
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: path.path)
        //快速枚举出所有文件名 计算文件大小
        var size:Int64 = 0
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = path.path + ("/\(file)")
            size += FileHelper.getFileSize(path: URL(string: path)!)
            
        }
        return size
    }
    
    
}

extension FileManager {
    
    
    // 判断是否是文件夹的方法
    static func directoryIsExists (path: String) -> Bool {
        var directoryExists = ObjCBool.init(false)
        let fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &directoryExists)
        return fileExists && directoryExists.boolValue
    }
    
}
