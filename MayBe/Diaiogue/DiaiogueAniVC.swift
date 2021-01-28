//
//  DiaiogueAniVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/12/16.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class DiaiogueAniVC: BaseViewController {
    
    lazy var videoPreImg:UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        img.backgroundColor = .red
        return img
    }()
    
    lazy var videoPlayer:LxPlayer = {
        let player = LxPlayer(containerView: videoPreImg)
        player.player?.containerView.layer.backgroundColor = UIColor.white.cgColor
        return player
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navBar.isHidden = true
        bottomView.isHidden = true
        
        navBar.wr_setBackgroundAlpha(0)
        bottomView.backgroundColor = .clear
        //视频预览
        view.insertSubview(videoPreImg, at: 0)
        videoPreImg.frame = CGRect(x: 0, y: 0, width: ScreenWidth , height: ScreenHeight)
        playerPlay()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func playerPlay(){
        //获取播放路径
        let videoPath = Bundle.main.path(forResource: "5334293-a86507ae671ca8740fa3bf6d25f7304e.mp4", ofType: nil)
        let url = URL(fileURLWithPath: videoPath!)
        videoPlayer.playerManger?.assetURL = url
        videoPlayer.playerManger?.prepareToPlay()
        videoPlayer.playerManger?.play()
        //设置时间回调的间隔
        videoPlayer.playerManger?.timeRefreshInterval = 0.01
        //时间改变回调
//        videoPlayer.playerManger?.playerPlayTimeChanged = {[weak self](asset,  currentTime, duration) in
//            
//        }
//        
//     
//        //播放完成回调
//        videoPlayer.playerManger?.playerDidToEnd = {(asset) in
//            
//            
//        }
        
        
        
    }
    
    
    @IBAction func dismissAC(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushDiaioList(_ sender: Any) {
        
       
        let diaioListView = DiaioListView()
        diaioListView.pushBlock = {
            self.navigationController?.pushViewController(BaseViewController(), animated: true)
        }
        diaioListView.present(in: view)

    }
    
}
