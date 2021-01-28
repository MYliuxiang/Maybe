//
//  Recorder.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/29.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class Recorder: NSObject {

    @objc public var callback:((Data) -> (Void))?
    var graph:AUGraph?
    var remoteIOUnit:AudioUnit?
    var streamFormat = AudioStreamBasicDescription(
    mSampleRate: 16000,
    mFormatID: kAudioFormatLinearPCM,
    mFormatFlags: kLinearPCMFormatFlagIsSignedInteger|kLinearPCMFormatFlagIsPacked,
    mBytesPerPacket: 2,
    mFramesPerPacket: 1,
    mBytesPerFrame: 2,
    mChannelsPerFrame: 1,
    mBitsPerChannel: 16,
    mReserved: 0)
    override init() {
        
        super.init()
        setUp()
        
    }
    
    func startRecored(){
        setupSession()
        assert(AUGraphInitialize(graph!) == noErr,"AUGraphInitialize failed");
        assert(AUGraphStart(graph!) == noErr, "AUGraphStart failed");
        AudioOutputUnitStart(remoteIOUnit!);
 
       }
    
    func stopRecored(){
        assert(AUGraphUninitialize(graph!) == noErr, "AUGraphInitialize failed");
        assert(AUGraphStop(graph!) == noErr, "AUGraphStop failed");
        AudioOutputUnitStop(remoteIOUnit!);
                
        let data = Data()
        if self.callback != nil{
            self.callback!(data)
        }
    }
    
    func setupSession(){
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            
        }
        catch { print("session config failed") }
        
        do { try AVAudioSession.sharedInstance().setActive(true) }
        catch { print("session active failed") }
        

    }
    
    func setUp(){
        
        
        assert(NewAUGraph(&graph) == noErr, "NewAUGraph failed")
        var remoteIONode = AUNode()
        var componentDesc = AudioComponentDescription()
        componentDesc.componentType = kAudioUnitType_Output
        componentDesc.componentSubType = kAudioUnitSubType_RemoteIO
        componentDesc.componentManufacturer = kAudioUnitManufacturer_Apple
        componentDesc.componentFlags = 0
        componentDesc.componentFlagsMask = 0
        assert(AUGraphAddNode(graph!, &componentDesc, &remoteIONode) == noErr, "AUGraphAddNode failed")
        assert(AUGraphOpen(graph!)  == noErr, "AUGraphOpen failed")

        assert(AUGraphNodeInfo(graph!, remoteIONode, nil, &remoteIOUnit) == noErr, "AUGraphNodeInfo failed")

           
        var echoCancellation:UInt32 = 1
        let size = MemoryLayout.size(ofValue: echoCancellation)
        assert(AudioUnitSetProperty(remoteIOUnit!, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, AudioUnitElement(kOutputBus), &echoCancellation, UInt32(size)) == noErr, "couldn't kAudioOutputUnitProperty_EnableIO with kAudioUnitScope_Output")
                  
         //启用录音功能
        
        var inputEnableFlag:UInt32 = 1
        let size1 = MemoryLayout.size(ofValue: inputEnableFlag)

        assert(AudioUnitSetProperty(remoteIOUnit!, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &inputEnableFlag, UInt32(size1)) == noErr, "Open input of bus 1 failed")
        
          
        //    Open output of bus 0(output speaker)
            //禁用播放功能
        
        var outputEnableFlag:UInt32 = 1
        let size2 = MemoryLayout.size(ofValue: outputEnableFlag)

         assert(AudioUnitSetProperty(remoteIOUnit!, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, 0, &outputEnableFlag, UInt32(size2)) == noErr, "Open output of bus 0 failed")
            
        let dsize = MemoryLayout.size(ofValue: streamFormat)
        assert(AudioUnitSetProperty(remoteIOUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamFormat, UInt32(dsize)) == noErr, "kAudioUnitProperty_StreamFormat of bus 0 failed")
        
        assert(AudioUnitSetProperty(remoteIOUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &streamFormat, UInt32(dsize)) == noErr, "kAudioUnitProperty_StreamFormat of bus 1 failed")
             
           
            
            //音频采集结果回调
        var renderCallbackStruct = AURenderCallbackStruct(inputProc: inputCallBack ,
                                                                        inputProcRefCon: Unmanaged.passUnretained(self).toOpaque())
                   
        let rsize = MemoryLayout.size(ofValue: renderCallbackStruct)
        assert(AudioUnitSetProperty(remoteIOUnit!, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Output,1, &renderCallbackStruct, UInt32(rsize)) == noErr, "couldnt set remote i/o render callback for output")
              
         
    }
    
    
    deinit {
    }

}

private func inputCallBack(inRefCon: UnsafeMutableRawPointer,
                                   ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                                   inTimeStamp: UnsafePointer<AudioTimeStamp>,
                                   inBusNumber: UInt32,
                                   inNumberFrames: UInt32,
                                   ioData: UnsafeMutablePointer<AudioBufferList>? ) -> OSStatus {
           
      
    let recorder = Unmanaged<Recorder>.fromOpaque(inRefCon).takeUnretainedValue()
    var bufferList = AudioBufferList()
    
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers.mData = nil
    bufferList.mBuffers.mDataByteSize = 0
   
       
   
    AudioUnitRender(recorder.remoteIOUnit!, ioActionFlags, inTimeStamp, 1, inNumberFrames, &bufferList)
       //    AudioBuffer buffer = bufferList.mBuffers[0];
       
       //将采集到的声音，进行回调
       
    let buffer = bufferList.mBuffers
    let data = Data(bytes: buffer.mData!, count: Int(buffer.mDataByteSize))
    

       
       if let callback:((Data)->(Void)) = recorder.callback {
           callback(data)
       }
  
    return noErr

           
           
       
}

