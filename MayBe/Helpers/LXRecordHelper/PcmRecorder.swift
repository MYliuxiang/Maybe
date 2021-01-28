//
//  PcmAlwaysManger.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/18.
//  Copyright © 2020 liuxiang. All rights reserved.
//



import Foundation
import AudioToolbox

class PcmRecorder {
    
    private var dataFormat: AudioStreamBasicDescription!

    private var audioQueue: AudioQueueRef!

    private var buffers: [AudioQueueBufferRef]

    private var audioFile: AudioFileID!
    
    private var bufferByteSize: UInt32

    private var currentPacket: Int64

    private var isRunning: Bool
    
    private var startStamp: Int?
    private var endStamp: Int?

    
    var callback:((_ pcmData:Data)->())?
    var callCancleback:(()->())?
   
       
    init(_ created_on:String){

        AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            if !allowed {
                return
            }
        }
        let session = AVAudioSession.sharedInstance()
        do { try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker) }
        catch { print("session config failed") }
        do { try AVAudioSession.sharedInstance().setActive(true) }
        catch { print("session active failed") }
        
        buffers = []
        bufferByteSize = 0
        currentPacket = 0
        isRunning = false
        prepare(created_on)
        prepareQueue()
        setupBuffer()

       

    }
    
    var currentMusicDataFormat = AudioStreamBasicDescription(
        mSampleRate: 16000,
        mFormatID: kAudioFormatLinearPCM,
        mFormatFlags: kLinearPCMFormatFlagIsSignedInteger|kLinearPCMFormatFlagIsPacked,
        mBytesPerPacket: 2,
        mFramesPerPacket: 1,
        mBytesPerFrame: 2,
        mChannelsPerFrame: 1,
        mBitsPerChannel: 16,
        mReserved: 0)
    
    let myAudioCallback: AudioQueueInputCallback = { (
        inUserData:Optional<UnsafeMutableRawPointer>,
        inAQ:AudioQueueRef,
        inBuffer:UnsafeMutablePointer<AudioQueueBuffer>,
        inStartTime:UnsafePointer<AudioTimeStamp>,
        inNumPackets:UInt32,
        inPacketDesc:Optional<UnsafePointer<AudioStreamPacketDescription>>) -> ()  in
        
        guard let userData = inUserData else{
            assert(false, "no user data...")
            return
        }
        
        //通过指针获取self对象
        let unManagedUserData = Unmanaged<PcmRecorder>.fromOpaque(userData)
        let receivedUserData = unManagedUserData.takeUnretainedValue()
        
//        receivedUserData.writeToFile(
//            buffer: inBuffer,
//            numberOfPackets: inNumPackets ,
//            inPacketDesc: inPacketDesc)

        
        let pcmData = Data(bytes: inBuffer.pointee.mAudioData, count: Int(inBuffer.pointee.mAudioDataByteSize))
            if receivedUserData.callback != nil {
                receivedUserData.callback!(pcmData)
            }
        
        if !(receivedUserData.isRunning) {

            return
        }
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil)
        
    }
    
    func prepare(_ created_on:String){
        
//        dataFormat = currentMusicDataFormat
//        var aAudioFileID: AudioFileID?
//        let documentDirectories = FileManager.default.urls(
//            for: FileManager.SearchPathDirectory.documentDirectory,
//            in: FileManager.SearchPathDomainMask.userDomainMask)
//        let docDirectory = (documentDirectories.first)!
//        var audioFilePathURL = docDirectory.appendingPathComponent(created_on)
//        audioFilePathURL.appendPathExtension("wav")
//
//        AudioFileCreateWithURL(audioFilePathURL as CFURL,
//                               kAudioFileAIFFType,
//                               &currentMusicDataFormat,
//                               AudioFileFlags.eraseFile,
//                               &aAudioFileID)
//        audioFile = aAudioFileID!
    }
    
    func prepareQueue(){
        var aQueue:AudioQueueRef!
        AudioQueueNewInput(
            &currentMusicDataFormat,
            myAudioCallback,
            unsafeBitCast(self, to: UnsafeMutableRawPointer.self),
            .none,
            CFRunLoopMode.commonModes.rawValue,
            0,
            &aQueue)
        
        if let aQueue = aQueue{
            audioQueue = aQueue
        }
    }
    
    deinit {
        print("pcmrecoder销毁了")
    }
    
    func startRecored(){
//        if self.isRunning{
//            print("上一个还没停止")
//        }
        currentPacket = 0
        isRunning = true
        self.startStamp = Int(Date().timeIntervalSince1970)
        AudioQueueStart(audioQueue, nil)
        
    }
    
    func stopRecored(){
        
        isRunning = false
        self.endStamp = Int(Date().timeIntervalSince1970)

        AudioQueueStop(audioQueue, true)
        AudioQueueDispose(audioQueue, true)
        
        if endStamp! - startStamp! < 1{
            if self.callCancleback != nil {
                self.callCancleback!()
            }
            MBProgressHUD.showError("录制时间太短", to: keywindow)
            closeFile()
        }else{
            let data = Data()
            if self.callback != nil {
                self.callback!(data)
            }
            closeFile()
        }
        
        
        
    }
    
    func cancleRecored(){
          
          isRunning = false
          AudioQueueStop(audioQueue, true)
          AudioQueueDispose(audioQueue, true)
        if self.callCancleback != nil {
            self.callCancleback!()
        }
         closeFile()
          
      }
    
  private  func writeToFile(buffer: UnsafeMutablePointer<AudioQueueBuffer>,numberOfPackets:UInt32,inPacketDesc:Optional<UnsafePointer<AudioStreamPacketDescription>>){
        
        guard let audioFile = audioFile else{
            assert(false, "no audio data...")
            return
        }
        
        var newNumPackets: UInt32 = numberOfPackets
        if (numberOfPackets == 0 && dataFormat.mBytesPerPacket != 0){
            newNumPackets = buffer.pointee.mAudioDataByteSize / dataFormat.mBytesPerPacket
        }
        
        let inNumPointer = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        inNumPointer.initialize(from: &newNumPackets, count: 1)
        
        let writeResult = AudioFileWritePackets(audioFile,
                              false,
                              buffer.pointee.mAudioDataByteSize,
                              inPacketDesc,
                              currentPacket,
                              inNumPointer,
                              buffer.pointee.mAudioData)
        
        currentPacket += Int64(numberOfPackets)
        
        if writeResult != noErr{
            // handle error
        }
        
    }
    
    func closeFile(){
        
        if let audioFile = audioFile{
            AudioFileClose(audioFile)
        }
    }
    
    func setupBuffer(){
        
        // typically 3
        let kNumberBuffers: Int = 3

        // typically 0.5
        bufferByteSize = deriveBufferSize(audioQueue: audioQueue, audioDataFormat: currentMusicDataFormat, seconds: 0.01)

        for i in 0..<kNumberBuffers{
            
            var newBuffer: AudioQueueBufferRef? = nil
            
            AudioQueueAllocateBuffer(
                audioQueue,
                bufferByteSize,
                &newBuffer)
            
            if let newBuffer = newBuffer{
                buffers.append(newBuffer)
            }
            
            AudioQueueEnqueueBuffer(
                audioQueue,
                buffers[i],
                0,
                nil)
            
        }
        
    }

    func deriveBufferSize(audioQueue: AudioQueueRef, audioDataFormat: AudioStreamBasicDescription, seconds: Float64) -> UInt32{
        
        let maxBufferSize:UInt32 = 0x50000
        var maxPacketSize:UInt32 = audioDataFormat.mBytesPerPacket
        
        if (maxPacketSize == 0) {
            
            var maxVBRPacketSize = UInt32(MemoryLayout<UInt32>.size)
            AudioQueueGetProperty(audioQueue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize, &maxVBRPacketSize)
            
        }
        
        let numBytesForTime = UInt32(Float64(audioDataFormat.mSampleRate) * Float64(maxPacketSize) * Float64(seconds))
        let outBufferSize = UInt32(numBytesForTime < maxBufferSize ? numBytesForTime : maxBufferSize)
        
        return outBufferSize
    }
}






