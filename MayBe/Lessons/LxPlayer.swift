//
//  LxPlayer.swift
//  MayBe
//
//  Created by liuxiang on 2020/9/27.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LxPlayer: NSObject {
    var playerManger:ZFAVPlayerManager?
    var player:ZFPlayerController?
    override init() {
        super.init()
    }
    
    convenience init(containerView:UIView) {
        
        self.init()
        self.initPlayer(containerView: containerView)
    }
    
    func initPlayer(containerView:UIView){
        playerManger = ZFAVPlayerManager()
        player = ZFPlayerController.player(withPlayerManager: playerManger!, containerView: containerView)
        player?.pauseWhenAppResignActive = false
        player?.isWWANAutoPlay = true
        playerManger?.scalingMode = .aspectFill
        playerManger?.shouldAutoPlay = false
        
//        let controlView = ZFPlayerControlView()
//        controlView.autoHiddenTimeInterval = 20
//        player?.controlView = controlView
//        playerManger?.loadState
//        playerManger?.prepareToPlay()
//        playerManger?.pause()
    }
    
}
