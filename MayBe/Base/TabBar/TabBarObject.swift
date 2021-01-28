//
//  TabBarObject.swift
//  JZYZApp
//
//  Created by 李江 on 2020/2/23.
//  Copyright © 2020 李江. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TabBarObject: NSObject {
    
    let tabBarController = ESTabBarController()
    
    static var shareInstance :TabBarObject{
        struct Single{
            static let shareInstance = TabBarObject()
        }
        return Single.shareInstance
    }
    
     /// 1.加载tabbar样式
     ///
     /// - Parameter delegate: 代理
     /// - Returns: ESTabBarController
     func setupTabBarStyle(delegate: UITabBarControllerDelegate?) -> ESTabBarController  {
        
        tabBarController.delegate = delegate
//        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.tabBar.backgroundImage = UIImage(named: "background")
        
        let lessonsVC = LessonsVC()
        let todayVC = TodayVC()
        let diaiogueVC = DiaiogueVC()
        let skillsVC = SkillsVC()
        let meVC = MeVC()
        
        lessonsVC.tabBarItem = ESTabBarItem.init(TabBarIrregularityBasicContentView(), title: "Lessons", image: UIImage(named: "首页 未选中"), selectedImage: UIImage(named: "首页 选中"))
        todayVC.tabBarItem = ESTabBarItem.init(TabBarIrregularityBasicContentView(), title: "Group", image: UIImage(named: "今天 未选中"), selectedImage: UIImage(named: "今天 选中"))
         diaiogueVC.tabBarItem = ESTabBarItem.init(TabBarIrregularityBasicContentView(), title: "Dialogue", image: UIImage(named: "对话 未选中"), selectedImage: UIImage(named: "对话 选中"))
        
//         skillsVC.tabBarItem = ESTabBarItem.init(TabBarIrregularityBasicContentView(), title: "Skills", image: UIImage(named: "技能 未选中"), selectedImage: UIImage(named: "技能 选中"))
         meVC.tabBarItem = ESTabBarItem.init(TabBarIrregularityBasicContentView(), title: "Me", image: UIImage(named: "我的 未选中"), selectedImage: UIImage(named: "我的 选中"))
        
          let homeNav = BaseNavigationController.init(rootViewController: lessonsVC)
        let todayNav = BaseNavigationController.init(rootViewController: todayVC)
          let lifeCircleNav = BaseNavigationController.init(rootViewController: diaiogueVC)
        
//          let skillNav = BaseNavigationController.init(rootViewController: skillsVC)
          let myNav = BaseNavigationController.init(rootViewController: meVC)
        tabBarController.viewControllers = [homeNav,todayNav,lifeCircleNav,myNav]
        
        //当前item是否需要被劫持
        tabBarController.shouldHijackHandler = {
              tabbarController, viewController, index in
              if index == 2 {
                  return true
              }

              return false
          }
        
        //劫持的点击事件
        tabBarController.didHijackHandler = {
             tabbarController, viewController, index in
            if index == 2 {
                let diaiogueAniNav = BaseNavigationController.init(rootViewController: DiaiogueAniVC())
                diaiogueAniNav.modalPresentationStyle = .fullScreen
                tabbarController.present(diaiogueAniNav, animated: true, completion: nil)
            }

        }
        

        
        let rect = CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: 20))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        UIColor.white.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        
//        if #available(iOS 13.0, *) {
//
//            let blankView = UIView(frame: CGRect(x: 0, y: -0.5, width: ScreenWidth, height: 0.5))
//            blankView.backgroundColor = .white
//            tabBarController.tabBar.insertSubview(blankView, at: 0)
//
//        }else{
//            tabBarController.tabBar.shadowImage = image
//            tabBarController.tabBar.backgroundImage = image
//
//        }
//        
//      
       
         
         return tabBarController

     }

}
