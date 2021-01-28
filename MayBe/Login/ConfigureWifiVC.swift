//
//  ConfigureWifiVC.swift
//  MayBe
//
//  Created by liuxiang on 22/04/2020.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreLocation

class ConfigureWifiVC: BaseViewController {

    
    let locationMagager = CLLocationManager()
    var player:XBPCMPlayer? = nil
    var avplayer:AVAudioPlayer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadLocation()
        
    }
    
    private func encodeWifiSsid(){
        
        let wifiInfo = getWifiInfo()
        let ssid = wifiInfo.ssid
        if ssid == "未知" {
            //获取失败
        }else{
            
            let cssid = UnsafeMutablePointer<Int8>(mutating: (ssid as NSString).utf8String)

            let userPtr = Unmanaged<ConfigureWifiVC>.passRetained(self).toOpaque()
            encoudec_date(cssid, { (pcmBuffer, length, SampleRate, FormatSize, owner) in
                   
                 let myower = Unmanaged<ConfigureWifiVC>.fromOpaque(owner!).takeRetainedValue()
                let data = NSData(bytes: pcmBuffer, length: Int(length))
                myower.setVolum()
                myower.playPcm(data: data as Data)
                
            }, userPtr)

        }
        
    }
    
    func setVolum() {
//        VolumeCongit.
        VolumeCongit.changeVolumeToMax()
        VolumeCongit.volumeBig()
    }
    
   
        
    private func playPcm(data:Data){
        
        self.avplayer = AVAudioPlayer.sp_createPlayer(with: data)
        self.avplayer?.play()
        self.avplayer?.delegate = self
        self.avplayer?.volume = 1
//        self.player = XBPCMPlayer.init(pcmData: data as Data, rate: XBVoiceRate_16k, channels: XBVoiceChannel(rawValue: 1), bit: XBVoiceBit(rawValue: 16))
//        self.player?.delegate = self;
//        self.player?.play()
        
    }
    
    private func loadLocation(){
        locationMagager.delegate = self
        if #available(iOS 13.0, *){
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {//开启了权限，直接搜索
                encodeWifiSsid()
                    
            } else if CLLocationManager.authorizationStatus() == .denied{//如果用户没给权限，则提示

                let alertVC = UIAlertController(title: "定位权限关闭提示", message: "你关闭了定位权限，导致无法使用WIFI功能", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (alert) in
                        
                }))
                self.present(alertVC, animated: true, completion: nil)
                      
            } else {//请求权限
        
                locationMagager.requestWhenInUseAuthorization()
                       
            }
        
        } else {
               
            encodeWifiSsid()
        }

        
    }
    
    func getWifiInfo() -> (ssid: String, mac: String) {
       if let cfas: NSArray = CNCopySupportedInterfaces() {
         for cfa in cfas {
            
           if  let dict = CFBridgingRetain(
           CNCopyCurrentNetworkInfo(cfa as! CFString)
            ){
             if let ssid = dict["SSID"] as? String,
               let bssid = dict["BSSID"] as? String {
               return (ssid, bssid)
             }
           }
         }
       }
       return ("未知", "未知")
     }


}

extension ConfigureWifiVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            encodeWifiSsid()
        }
    }
    
}

extension ConfigureWifiVC: AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //播放完成
        
    }
    
}


extension ConfigureWifiVC: XBPCMPlayerDelegate{
    
    func play(toEnd player: XBPCMPlayer!) {
        print("播放结束")
    }
    
}
