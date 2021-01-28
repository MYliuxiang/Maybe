//
//  DemoPlayerVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/9/25.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class DemoPlayerVC: BaseViewController {
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contain1I: UIImageView!
    @IBOutlet weak var containI: UIImageView!
    //    var playerManger:ZFAVPlayerManager?
    //    var player:ZFPlayerController?
    //    var player1:ZFPlayerController?
    //    var playerManger1:ZFAVPlayerManager?
    var assetURLS:[URL] = []
    var cachPlayers:[LxPlayer] = []
    var videoIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.isHidden = true
        
//        let demopath = Bundle.main.path(forResource: "lily@level1_lesson1_here_001.mp4", ofType: nil)
//        let url1 = URL(string: "file://\(demopath!)")!
//        assetURLS.append(url1)
        let array = ["lily@level1_lesson1_all",
                     "lily@level1_lesson1_hello_001","lily@level1_lesson1_here_001","lily@level1_lesson1_teaching_001_01","lily@level1_lesson1_teaching_001_02","lily@level1_lesson1_teaching_001_03","lily@level1_lesson1_teaching_001_04","lily@level1_lesson1_teaching_001_04end","lily@level1_lesson1_yourturn_001","lily@level1_lesson1_wait_001_01","lily@level1_lesson1_wait_001_02","lily@level1_lesson1_wait_001_03","lily@level1_lesson1_great_001","lily@level1_lesson1_teaching_001_01","lily@level1_lesson1_teaching_001_02","lily@level1_lesson1_teaching_001_03","lily@level1_lesson1_teaching_001_04","lily@level1_lesson1_teaching_001_05","lily@level1_lesson1_teaching_001_06","lily@level1_lesson1_teaching_001_st1","lily@level1_lesson1_teaching_001_01","lily@level1_lesson1_teaching_001_02","lily@level1_lesson1_teaching_001_02end","lily@level1_lesson1_notouching_001","lily@level1_lesson1_teaching_001_03","lily@level1_lesson1_teaching_001_04","lily@level1_lesson1_teaching_001_05","lily@level1_lesson1_teaching_001_06","lily@level1_lesson1_teaching_001_st2","lily@level1_lesson1_teaching_001_01","lily@level1_lesson1_teaching_001_02","lily@level1_lesson1_teaching_001_03","lily@level1_lesson1_teaching_001_04","lily@level1_lesson1_teaching_001_05","lily@level1_lesson1_teaching_001_05end","lily@level1_lesson1_yourturn_002","lily@level1_lesson1_teaching_001_01","lily@level1_lesson1_teaching_001_02","lily@level1_lesson1_teaching_001_03","lily@level1_lesson1_teaching_001_04","lily@level1_lesson1_teaching_001_05","lily@level1_lesson1_teaching_001_06","lily@level1_lesson1_byebye_001"]
        for item in array {
            let demopath = Bundle.main.path(forResource: "\(item).mp4", ofType: nil)
            let url1 = URL(string: "file://\(demopath!)")!
            assetURLS.append(url1)
        }
        

        
//        let paths = Bundle.main.paths(forResourcesOfType: nil, inDirectory: "lily_lesson1_mp4_9.25")
//        for item in paths {
//            let url = URL(string:"file://\(item)")!
//            assetURLS.append(url)
//        }
        
        
        cachPlayers.append(LxPlayer(containerView: self.containI))
        cachPlayers.append(LxPlayer(containerView: self.contain1I))
        cachPlayer(assets: assetURLS)
        
        
        
        
    }
    
    func cachPlayer(assets:[URL]){
        
        let firstPlayer = cachPlayers[0]
        let seconedPlayer = cachPlayers[1]
        
        firstPlayer.playerManger?.assetURL = assets[0]
        firstPlayer.playerManger?.prepareToPlay()
        firstPlayer.playerManger?.play()
        self.nameL.text = assets.first?.lastPathComponent
        
                
        if assets.count > 1 {
            seconedPlayer.playerManger?.assetURL = assets[1]
            seconedPlayer.playerManger?.prepareToPlay()
            seconedPlayer.playerManger?.pause()
        }
        
        weak var weakSelf = self

        firstPlayer.player?.playerDidToEnd = {(player) in
            print("第1个播放器播完")
            //判断有为初始化的lxplayer
            if assets.count == weakSelf!.videoIndex + 1 {
                //播放完成
                weakSelf?.videoIndex = 0
                print("播放完了")
                return
            }
//
//            let index = assets.firstIndex(where: { (e) -> Bool in
//                return e.absoluteString == player.assetURL.absoluteString
//            })
//
            
            if assets.count > weakSelf!.videoIndex + 1  {
                seconedPlayer.playerManger?.play()
                weakSelf?.view.bringSubviewToFront((weakSelf?.contain1I)!)
                weakSelf?.nameL.text = assets[weakSelf!.videoIndex + 1].lastPathComponent
                weakSelf?.view.bringSubviewToFront((weakSelf?.nameL)!)
            }
         
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if assets.count > weakSelf!.videoIndex + 2 {
                    
                    firstPlayer.playerManger?.assetURL = assets[weakSelf!.videoIndex + 2]
                    //                    firstPlayer.playerManger?.prepareToPlay()
                    firstPlayer.playerManger?.pause()
                }
                weakSelf?.videoIndex += 1
                
            }
           
            
        }
        seconedPlayer.player?.playerDidToEnd = {(player) in
            //判断有为初始化的lxplayer
            print("第2个播放器播完")

            if assets.count == weakSelf!.videoIndex + 1 {
                //播放完成
                print("播放完了")
                weakSelf?.videoIndex = 0
                return
            }
//            let index = assets.firstIndex(where: { (e) -> Bool in
//                return e.absoluteString == player.assetURL.absoluteString
//            })
            if assets.count > weakSelf!.videoIndex + 1 {
                firstPlayer.playerManger?.play()
                weakSelf?.view.bringSubviewToFront((weakSelf?.containI)!)
                weakSelf?.nameL.text = assets[weakSelf!.videoIndex + 1].lastPathComponent
                weakSelf?.view.bringSubviewToFront(weakSelf!.nameL)
            }
            
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if assets.count > weakSelf!.videoIndex + 2 {
                    
                    seconedPlayer.playerManger?.assetURL = assets[weakSelf!.videoIndex + 2]
                    seconedPlayer.playerManger?.pause()
                }
                weakSelf?.videoIndex += 1

            }

         
        }
        
    }
    deinit {
        
        for item in cachPlayers {
            item.playerManger?.stop()
        }
        cachPlayers.removeAll()
        print("demo释放了")
    }
    
    
    func  findunUsedLxPlayer() ->(LxPlayer?){
        var lxplayer:LxPlayer?
        for cachPlayer in cachPlayers {
            if cachPlayer.playerManger?.playState == .playStatePlayStopped || cachPlayer.playerManger?.playState == .playStateUnknown || cachPlayer.playerManger?.playState == .playStatePlayFailed{
                lxplayer = cachPlayer
                break
            }
        }
        return lxplayer
    }
    
    
    
    
    
    
    
}

