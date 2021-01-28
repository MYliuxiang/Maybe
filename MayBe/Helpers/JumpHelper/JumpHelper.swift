//
//  JumpHelper.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/24.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class JumpHelper: NSObject {
    
    /// 跳转到系统设置主页
    static  func jumpToSystemSeting() {
        JumpHelper.jumpTemplate(strurl: UIApplication.openSettingsURLString)
        
    }
    /// 定位服务
    static  func jumpToPosition() {
        JumpHelper.jumpTemplate(strurl: "prefs:root=LOCATION_SERVICES")
        
    }
    /// wifi服务
    static func jumpToWifi() {
        JumpHelper.jumpTemplate(strurl: "prefs:root=WIFI")
        
    }
    
    //声音设置
    static func jumpToSounds() {
           JumpHelper.jumpTemplate(strurl: "prefs:root=Sounds")
           
       }
    
    
    
    /// 系统通知
    static func jumpToNoti() {
        JumpHelper.jumpTemplate(strurl: "prefs:root=NOTIFICATIONS_ID")
    }
    
    /// 跳转的模版
    static func jumpTemplate(strurl: String) {
        let urltemp = URL(string: strurl)
        if let url = urltemp, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
}
