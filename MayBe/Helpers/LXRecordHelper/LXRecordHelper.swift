//
//  LXRecordHelper.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/16.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit


public typealias Completion = (_ time:Double,_ path:String) -> Void


class LXRecordHelper: NSObject {
  
//    static let shared = LXRecordHelper()
    public var completion:Completion?
    private var recorder: AVAudioRecorder!
    private var recordTime = 0.00
    /// 波形更新间隔
    private let updateFequency = 0.05

    /// 录音计时器
    private var timer: Timer?

    /// 录音器设置
    private let recorderSetting = [AVSampleRateKey : NSNumber(value: Float(16000.0)),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatLinearPCM)),//编码格式
        AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//声音质量
   
    
    func startRecord(){
        self.prepareAudioRecorder()
        recorder.record()
        timer = Timer.scheduledTimer(timeInterval: updateFequency, target: self, selector: #selector(updateMeters), userInfo: nil, repeats: true)

    }
    
    @objc private func updateMeters() {
            recordTime += updateFequency
    //        if recordTime >= 60.0 {
    //            endRecordVoice()
    //        }
        
    }
    
    func endRecord(){
        
        recorder.stop()
        timer?.invalidate()


    }
    
    func cancleRecord(){
        endRecord()
        recorder.deleteRecording()
    }
    
    
    override init() {
        super.init()
        self.prepareAudioRecorder()
        
    }
    
    private func configAVAudioSession() {
           let session = AVAudioSession.sharedInstance()
           do { try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker) }
           catch { print("session config failed") }
    }
    
    private func prepareAudioRecorder() {
        // Get document directory
      AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            if !allowed {
                return
            }
        }
        let session = AVAudioSession.sharedInstance()
        do { try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker) }
        catch { print("session config failed") }
        do {
            self.recorder = try AVAudioRecorder(url: self.directoryURL()!, settings: self.recorderSetting)
            self.recorder.delegate = self
            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true
        } catch {
            print(error.localizedDescription)
        }
        do { try AVAudioSession.sharedInstance().setActive(true) }
        catch { print("session active failed") }
    }
    
    
    private func directoryURL() -> URL? {
            
            
        let currentFileName = "diaiogue.wav"
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
            let fileManger = FileManager.default
            if  fileManger.fileExists(atPath: soundFileURL.absoluteString) {
                do{
                    try fileManger.removeItem(atPath: soundFileURL.absoluteString)
                } catch{
                    print("creat false")
                }
            }
            
            return soundFileURL
        }
    
}

//MARK: - AVAudioRecorderDelegate
extension LXRecordHelper:AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
       
        
        if recordTime > 1.0 {
            if flag {
                do {
                    let exists = try recorder.url.checkResourceIsReachable()
                    if exists {
                        if self.completion != nil{
                            self.completion!(self.recordTime,self.recorder.url.absoluteString)
                        }
                    }
                }
                catch { print("fail to load record")}
            } else {
                print("record failed")
            }
        }
        recordTime = 0
    }
}
