//
//  MbRecorder.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/29.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit



class MbRecorder: NSObject {
    
    var audioSession:AVAudioSession?
    var auGraph:AUGraph?
    var remoteIOUnit:AudioUnit? = nil
    var remoteIONode:AUNode? = nil
    var inputProc:AURenderCallbackStruct?
    var creat_on:String?
    var pathStr:String?
    var file:FileHandle?
    var playerQueen:DispatchQueue?
    private var startStamp: Int?
    private var endStamp: Int?
  
    
    @objc public var callback:((Data) -> (Void))?
    @objc public var callCancleback:(()->())?
    
    
    
    var currentMusicDataFormat = AudioStreamBasicDescription(
        mSampleRate: 16000,
        mFormatID: kAudioFormatLinearPCM,
        mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
        mBytesPerPacket: 2,
        mFramesPerPacket: 1,
        mBytesPerFrame: 2,
        mChannelsPerFrame: 1,
        mBitsPerChannel: 16,
        mReserved: 0)
    
    
    convenience init(_ creat_on:String) {
        
        self.init()
        self.creat_on = creat_on
        
        
        self.playerQueen = DispatchQueue(label: "com.lx.mbrecoder")
        
        self.playerQueen?.async {
            self.audioSession = AVAudioSession.sharedInstance()
            do {
                try self.audioSession!.setCategory(AVAudioSession.Category.playAndRecord, options: .allowBluetoothA2DP)
                try! self.audioSession?.setPreferredIOBufferDuration(0.04)
            }
            catch { print("session config failed") }
            do {
                try self.audioSession!.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
                try AVAudioSession.sharedInstance().setActive(true)
            }
            catch { print("session active failed") }
        }
        
        audioUnitInit()
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancleRecored), name: AVAudioSession.interruptionNotification, object: nil)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    func startRecored(){
        self.playerQueen?.async { [self] in
            assert(AUGraphStart(auGraph!) == noErr,"couldn't AUGraphStart")
            self.startStamp = Int(Date().timeIntervalSince1970)
        }
      
    }
    
    func stopRecored(){
        
        self.endStamp = Int(Date().timeIntervalSince1970)
        if (endStamp ?? 0) - (startStamp ?? 0) < 1{
            if self.callCancleback != nil {
                self.callCancleback!()
            }
        }else{
            let data = Data()
            if self.callback != nil{
                self.callback!(data)
            }
            
        }
        self.playerQueen?.async { [self] in
            assert(AUGraphStop(auGraph!) == noErr,"couldn't AUGraphStop")
        }
    }
    
    @objc func cancleRecored(){
        if self.callCancleback != nil {
            self.callCancleback!()
        }
        assert(AUGraphStop(auGraph!) == noErr,"couldn't AUGraphStop")
        
    }
    
    
    
    private func audioUnitInit(){
        let tmpDir = NSHomeDirectory() + "/tmp"
        //    let ducumentPath2 = NSHomeDirectory() + "/Documents"
//        let path = tmpDir + "/\(self.creat_on ?? "MbRecoder").pcm"
        self.pathStr = "file://" + tmpDir + "/\(self.creat_on ?? "MbRecoder").pcm"
        let pathUrl = URL(string: self.pathStr!)
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: pathUrl!.path)
           if !exist {
            _ = manager.createFile(atPath: pathUrl!.path,contents:nil,attributes:nil)
//               print("文件创建结果: \(createSuccess)")
        }
        
       
       
        
     
        
        assert(NewAUGraph(&auGraph) == noErr, "AudioUnitSetProperty SetRenderCallback failed")
        assert(AUGraphOpen(auGraph!)  == noErr, "couldn't AUGraphOpen")
        
        var componentDesc = AudioComponentDescription()
        componentDesc.componentType = kAudioUnitType_Output
        componentDesc.componentSubType = kAudioUnitSubType_RemoteIO
        componentDesc.componentManufacturer = kAudioUnitManufacturer_Apple
        componentDesc.componentFlags = 0
        componentDesc.componentFlagsMask = 0
        
        self.remoteIONode = AUNode()
        assert(AUGraphAddNode(auGraph!, &componentDesc, &remoteIONode!) == noErr, "couldn't add remote io node")
        assert(AUGraphNodeInfo(auGraph!, remoteIONode!, nil, &remoteIOUnit) == noErr, "couldn't get remote io unit from node")
        
        
        var oneFlag:UInt32 = 1
        let dataSize = MemoryLayout<UInt32>.size
               assert(AudioUnitSetProperty(remoteIOUnit!, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, AudioUnitElement(kOutputBus), &oneFlag, UInt32(dataSize)) == noErr, "couldn't kAudioOutputUnitProperty_EnableIO with kAudioUnitScope_Output")
               assert(AudioUnitSetProperty(remoteIOUnit!, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, AudioUnitElement(kInputBus), &oneFlag, UInt32(dataSize)) == noErr, "couldn't kAudioOutputUnitProperty_EnableIO with kAudioUnitScope_Output")
        
 
         let size = MemoryLayout<AudioStreamBasicDescription>.size
            assert(AudioUnitSetProperty(remoteIOUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, AudioUnitElement(kInputBus), &currentMusicDataFormat, UInt32(size)) == noErr, "couldn't set kAudioUnitProperty_StreamFormat with kAudioUnitScope_Output")
        
           assert(AudioUnitSetProperty(remoteIOUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, AudioUnitElement(kOutputBus), &currentMusicDataFormat, UInt32(size)) == noErr, "couldn't set kAudioUnitProperty_StreamFormat with kAudioUnitScope_Output")
        

        var renderCallbackStruct = AURenderCallbackStruct(inputProc: inputCallBack ,
                                                                     inputProcRefCon: Unmanaged.passUnretained(self).toOpaque())
                
        assert(AUGraphSetNodeInputCallback(auGraph!, remoteIONode!, 0, &renderCallbackStruct) == noErr,"Error setting io input callback")
            assert(AUGraphInitialize(auGraph!) == noErr, "couldn't AUGraphInitialize")
            assert(AUGraphUpdate(auGraph!, nil) == noErr, "couldn't AUGraphUpdate")
        
  

        
    }
    
    func write(data:Data){
        do {
            let writeHan = try FileHandle(forWritingTo: URL(string: self.pathStr!)!)
            writeHan.seekToEndOfFile()
            writeHan.write(data)
            if #available(iOS 13.0, *) {
                try writeHan.close()
            } else {
                // Fallback on earlier versions
            }
        } catch (let erroe) {
            print(erroe)
        }
    }
    
}

private func inputCallBack(inRefCon: UnsafeMutableRawPointer,
                           ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                           inTimeStamp: UnsafePointer<AudioTimeStamp>,
                           inBusNumber: UInt32,
                           inNumberFrames: UInt32,
                           ioData: UnsafeMutablePointer<AudioBufferList>? ) -> OSStatus {
    
    
     
    let recorder = Unmanaged<MbRecorder>.fromOpaque(inRefCon).takeUnretainedValue()
    AudioUnitRender(recorder.remoteIOUnit!, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData!)
    let data = Data(bytes: ioData!.pointee.mBuffers.mData!, count: Int((ioData?.pointee.mBuffers.mDataByteSize)!))
    
//    recorder.write(data: data)
    
    if let callback:((Data)->(Void)) = recorder.callback {
        callback(data)
    }
    
    //              [THIS writePCMData:ioData->mBuffers->mData size:ioData->mBuffers->mDataByteSize];
    //              AudioBufferList bufferList;
    //              bufferList.mNumberBuffers = 1;
    //              bufferList.mBuffers[0].mData = NULL;
    //              bufferList.mBuffers[0].mDataByteSize = 0;
    //
    //              AudioUnitRender(THIS->remoteIOUnit,
    //                              ioActionFlags,
    //                              inTimeStamp,
    //                              1,
    //                              inNumberFrames,
    //                              &bufferList);
    //
    //              AudioBuffer buffer = bufferList.mBuffers[0];
    //                 NSData *pcmBlock =[NSData dataWithBytes:ioData->mBuffers->mData length:ioData->mBuffers->mDataByteSize];
    //                 if (THIS.recordBack) {
    //                     THIS.recordBack(pcmBlock);
    //                 }
    //
    //
    //              return renderErr;
    //          }
    //
    //
    //
    //
    //
    //        let data = Data(bytes: ioData!.pointee.mBuffers.mData!, count: Int((ioData?.pointee.mBuffers.mDataByteSize)!))
    //         if let callback:((Data)->(Void)) = recorder.callback {
    //
    //
    //            callback(data)
    //            }
    
    
    return noErr
    
}


