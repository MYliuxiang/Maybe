//
//  AppDelegate.swift
//  MayBe
//
//  Created by liuxiang on 09/04/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isForceLandscape = false//是否允许横屏
  
    static let app: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        
        
     
        //取出downloader单例
        let downloader = KingfisherManager.shared.downloader
        //信任ip为106的
        //13.67.52.192
        //
        downloader.trustedHosts = Set([baseIP])
              
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tabBar = TabBarObject.shareInstance.setupTabBarStyle(delegate: self as? UITabBarControllerDelegate)
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        
        //注册相关服务
        AppService.shareInstance.registerAppService(application: application, launchOptions: launchOptions)
        
        let ctype = UserDefaultsStandard.object(forKey: CType)
        if (ctype == nil){
            UserDefaultsStandard.set(CourseWareType.PinyinEnglish.rawValue, forKey: CType)
        }
        
        UserDefaultsStandard.set(true, forKey: isLogin)
        if !UserDefaultsStandard.bool(forKey: isLogin) {
            let nav = BaseNavigationController(rootViewController: LoginVC())
            nav.modalPresentationStyle = .fullScreen
            tabBar.present(nav, animated: false, completion: nil)
        }
        
        return true
    }
    
    
  
    
}

