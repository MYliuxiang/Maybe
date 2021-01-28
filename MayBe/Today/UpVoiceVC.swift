//
//  UpVoiceVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/9/22.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class UpVoiceVC: BaseViewController {

    @IBOutlet weak var textL: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    
    /// 录音框
    private var chatHUD: MCRecordHUD!
    
    /// 录音器
    private var recorder: AVAudioRecorder!
    
    var recordplayer:AVAudioPlayer? //播放器
    
    /// 录音器设置
    private let recorderSetting = [AVSampleRateKey : NSNumber(value: Float(16000.0)),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatLinearPCM)),//编码格式
        AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//声音质量
    /// 录音计时器
    private var timer: Timer?
    /// 波形更新间隔
    private let updateFequency = 0.05
    /// 声音数据数组
    private var soundMeters: [Float]!
    /// 声音数据数组容量
    private let soundMeterCount = 10
    /// 录音时间
    private var recordTime = 0.00
    var recordUrl:URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        chatHUD = MCRecordHUD(type: .bar)
        self.recordBtn.layer.cornerRadius = 45
              self.recordBtn.layer.masksToBounds = true

        // Do any additional setup after loading the view.
        recordBtn.addTarget(self, action: #selector(beginRecordVoice), for: .touchDown)
        recordBtn.addTarget(self, action: #selector(endRecordVoice), for: .touchUpInside)
        recordBtn.addTarget(self, action: #selector(cancelRecordVoice), for: .touchUpOutside)
        recordBtn.addTarget(self, action: #selector(cancelRecordVoice), for: .touchCancel)
        recordBtn.addTarget(self, action: #selector(remindDragExit), for: .touchDragExit)
        recordBtn.addTarget(self, action: #selector(remindDragEnter), for: .touchDragEnter)
    }


   

}

// MARK: - Record handlers
extension UpVoiceVC: AVAudioRecorderDelegate {
    
    /// 开始录音
    @objc private func beginRecordVoice() {
        configRecord()

        if recorder == nil {
            return
        }
        view.addSubview(chatHUD)
        view.isUserInteractionEnabled = false  //录音时候禁止点击其他地方
    
        
        chatHUD.startCounting()
        soundMeters = [Float]()
        recorder.record()
        timer = Timer.scheduledTimer(timeInterval: updateFequency, target: self, selector: #selector(updateMeters), userInfo: nil, repeats: true)
    }
    
    /// 停止录音
    @objc private func endRecordVoice() {
        recorder.stop()
        timer?.invalidate()
        chatHUD.removeFromSuperview()
        view.isUserInteractionEnabled = true  //录音完了才能点击其他地方
        chatHUD.stopCounting()
        soundMeters.removeAll()
        

        let path = Bundle.main.path(forResource: "1.wav", ofType: nil)
        let url = URL(string: "file://\(path!)")!
        
        MBuploadFile("voice", filePath:self.recordUrl!.absoluteString, fileType: "application/wav", progress: {(progress) in
            
        }) { (result, code) in
            
        }
        
                
                
        
     
    }
    
    /// 取消录音
    @objc private func cancelRecordVoice() {
        endRecordVoice()
        recorder.deleteRecording()
    }
    
    /// 上划取消录音
    @objc private func remindDragExit() {
        chatHUD.titleLabel.text = "Release to cancel"
    }
    
    /// 下滑继续录音
    @objc private func remindDragEnter() {
        chatHUD.titleLabel.text = "Slide up to cancel"
    }
    
    @objc private func updateMeters() {
        recorder.updateMeters()
        recordTime += updateFequency
        addSoundMeter(item: recorder.averagePower(forChannel: 0))
//        if recordTime >= 60.0 {
//            endRecordVoice()
//        }
    }
    
    private func addSoundMeter(item: Float) {
              
        if soundMeters.count < soundMeterCount {
            soundMeters.append(item)
        } else {
            for (index, _) in soundMeters.enumerated() {
                if index < soundMeterCount - 1 {
                    soundMeters[index] = soundMeters[index + 1]
                }
            }
            // 插入新数据
            soundMeters[soundMeterCount - 1] = item
            NotificationCenter.default.post(name: NSNotification.Name.init("updateMeters"), object: soundMeters)
        }
    }
}

// MARK: - Setup
extension UpVoiceVC {
    
   
    private func configAVAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do { try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker) }
        catch { print("session config failed") }
    }
    
    private func configRecord() {
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
        //定义并构建一个url来保存音频，音频文件名为recording-yyyy-MM-dd-HH-mm-ss.m4a
        //根据时间来设置存储文件名
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        //
        
        let currentFileName = "recording-\(format.string(from: Date())).wav"
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        self.recordUrl = soundFileURL

        
        return soundFileURL
    }
    
}

