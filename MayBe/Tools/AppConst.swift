//
//  AppConst.swift
//  MayBe
//
//  Created by liuxiang on 09/04/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//
import Foundation
import UIKit

///MARK:TODO 定义常用的类库信息, 使用@_exported关键字，就可以全局引入对应的包
//@_exported import JXSegmentedView
//@_exported import JXPagingView
@_exported import HandyJSON
@_exported import Kingfisher
@_exported import SnapKit
@_exported import LXFProtocolTool
@_exported import SwiftyJSON
@_exported import RxSwift
@_exported import RxCocoa
//@_exported import Moya
//@_exported import Alamofire
//@_exported import NSObject_Rx
//@_exported import WCDBSwift
//@_exported import SwifterSwift







// ************** 基本配置 ************************

let versionString = "1.0"



//基本属性
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let keywindow = UIApplication.shared.keyWindow!
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let screenFrame:CGRect = UIScreen.main.bounds

let ScareX = (ScreenWidth/375)
let ScareY = (ScreenHeight/667)

let APPVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]//app version
let DeviceId = UIDevice.current.identifierForVendor?.uuidString//设备id

//通知
let NotiCenter = NotificationCenter.default


//UserDefaults
let UserDefaultsStandard = UserDefaults.standard

let isLogin = "islogin"

let CType = "CourseWareType" //课件展示形式


let userDefaults_userInfo = "userDefaults_userInfo"//用户信息


//通知
enum NotificationName: String {
    case LoginSuccess// 用户登录成功
    case Logout // 用户退出登录
    case RestrictedStateNotice
  
}

//课件展示形式type
enum CourseWareType:String {
    case PinyinEnglish = "Pinyin + English"
    case PinyinCharactersEnglish = "Pinyin + Characters + English"
    init?(courseWareType:String) {
        switch courseWareType {
        case "Pinyin + English":  self = .PinyinEnglish
        case "Pinyin + Characters + English":  self = .PinyinCharactersEnglish           
        default:
            return nil
        }
    }
}

