//
//  UpdateManager.swift
//  YJKApp
//
//  Created by liuxiang on 2020/5/28.
//  Copyright © 2020 lijiang. All rights reserved.
//

import UIKit
import Alamofire

let AppleAppID = "585829637"


class UpdateManager: NSObject {
    /// app版本更新检测
      ///
    ///
    ///

    ///585829637
      /// - Parameter appId: apple ID - 开发者帐号对应app处获取
     
    static func updateVersion(result:@escaping((_ isUpdate:Bool)->Void)) {
        let url = "http://itunes.apple.com/lookup?id="+AppleAppID
        
        MBProgressHUD.showAdded(to: keywindow, animated: true)
       
        AF.request(url).responseJSON { (response) in
            MBProgressHUD.hide(for: keywindow, animated: true)
                        
            if let JSON = response.value {
                let dic = JSON as? [String:Any]
                let array = dic?["results"] as! [Any]
                let results = array[0] as! [String:Any]
                let appleversion = results["version"] as! String
                let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                let storeInt = coverInt(version: appleversion)
                let bundleInt = coverInt(version: bundleVersion)
                if storeInt > bundleInt {
                    //需要去更新
                    result(true)

                }else{
                    //不需要跟新
                    result(false)

                }
            }else{
                result(false)
            }
        }
        
    }
    
      //去更新
    static func updateApp() {
          let updateUrl:URL = URL.init(string: "http://itunes.apple.com/app/id" + AppleAppID)!
        if #available(iOS 10, *) {
            UIApplication.shared.open(updateUrl, options: [:],
                                      completionHandler: {
                                        (success) in
            })
        } else {
            UIApplication.shared.openURL(updateUrl)
        }
      }

}

func coverInt(version:String) -> Int{
    var verStr:String = ""
    for value in version{
        if String(value) != "." {
            verStr.append(value)
        }
    }
    
    for _ in 0...(6-verStr.count) {
        verStr.append("0")
    }
            
    return Int(verStr) ?? 0
    
}
  
