//
//  LXPcmUploader.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/22.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit
import Alamofire

private let url = "https://192.168.5.3:8000/dialogues"



public enum PcmError:Swift.Error {
    
    case netError
    case serverError([String:Any])
}



public typealias PcmCompletion = (_  reslut:Result<[String:Any],PcmError>) -> Void



class LXPcmUploader: NSObject {
    
    var outputStream:OutputStream?
    var bodyStream:InputStream?
    var hasSpaceAvailable:Bool = false
    var isEnd:Bool = false
    var isStart:Bool = false
    var canWrite = false

    var timer:Timer?
    var isWriting:Bool = false
    var alreadyRecord:Int64 = 0
    var alreadyUpload:Int64 = 0
    var completion:PcmCompletion?
    var handleCancle:(()->())?

    var loadRequest:UploadRequest?
    var cancleState = false
    var subUrl:String!
    


    
    struct Streams {
           let input: InputStream
           let output: OutputStream
       }
    lazy var boundStreams: Streams = {
        var inputOrNil: InputStream? = nil
        var outputOrNil: OutputStream? = nil
        Stream.getBoundStreams(withBufferSize: 4096,
                               inputStream: &inputOrNil,
                               outputStream: &outputOrNil)
        guard let input = inputOrNil, let output = outputOrNil else {
            fatalError("On return of `getBoundStreams`, both `inputStream` and `outputStream` will contain non-nil streams.")
        }
        // configure and open output stream
//        output.delegate = self
//        output.schedule(in: .current, forMode: .default)
        output.open()
        return Streams(input: input, output: output)
    }()

    
    let session:Session = {
        let manager = ServerTrustManager(allHostsMustBeEvaluated:false,evaluators: ["104.248.148.85": DisabledTrustEvaluator(),"192.168.5.10":DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        let session = Session(configuration: configuration,serverTrustManager: manager)
        return  session
    }()
    
    

    convenience init(_ subUrl:String) {
        self.init()
        self.subUrl = subUrl
        contectSever()
        
    }
    
    func contectSever(){

        let url = BaseUrl + self.subUrl
        
//        let url = "https://192.168.5.10:8000/dialogues"
//        self.loadRequest = session.upload(boundStreams.input, to: url, method: .post, headers: nil).
//        self.loadRequest = session.upload(boundStreams.input, to: url, method: .post, headers: nil).downloadProgress(queue: DispatchQueue.main, closure: { (progress) in
//
//        }).response(queue: DispatchQueue.main, completionHandler: { (PcmRespose) in
//
//        })
//        self.loadRequest = session.upload(url, to: url,method: .post,headers: nil).
        let tmpDir = NSHomeDirectory() + "/tmp"
        let pathStr = "file://" + tmpDir + "333.pcm"
        let pathUrl = URL(string: pathStr)
                
        
        self.loadRequest = session.upload(pathUrl!, to: url, method: .post).uploadProgress(closure: { (progress) in
            print(progress)
            
        }).response(completionHandler: { [weak self](respose) in
            
            if respose.error != nil{
                MBProgressHUD.showError("请求失败,请重试", to: keywindow)
            }
            
            if let data = respose.data{
                print(data)
                if let dic = JSON(data).dictionaryObject,let code = JSON(data)["code"].int{
                    switch code {
                    case code_succes:
                        if self?.completion != nil {
                            self?.completion!(.success(dic))
                            debugPrint("上传成功")
                        }
                        break
                    default:
                        if self?.completion != nil {
                            self?.completion!(.failure(.serverError(dic)))
                            debugPrint("上传失败")
                        }
                        MBProgressHUD.showError((dic["msg"] as? String) ?? "上传失败", to: keywindow)
                        break
                    }
                }else{
                    if self?.completion != nil {
                        self?.completion!(.failure(.netError))
                        debugPrint("上传失败")
                    }
                    MBProgressHUD.showError("请求失败,请重试", to: keywindow)
                }
            }
        })
    
    
                        
//        self.loadRequest = session.upload(boundStreams.input, to: url, method: .post, headers: nil).uploadProgress { (progress) in
//            // 上传进度
//            if self.isEnd && self.alreadyRecord == progress.completedUnitCount{
//                self.stopStream()
//            }
//
//        }.response(queue: DispatchQueue.main) { [weak self](PcmRespose) in
//
//            if self!.cancleState{
//                if self!.handleCancle != nil {
//                    self!.handleCancle!()
//                }
//                return
//            }
//            if PcmRespose.error != nil{
//                if self?.completion != nil {
//                    self?.completion!(.failure(.netError))
//                    debugPrint("上传失败")
//                    MBProgressHUD.showError("请求失败,请重试", to: keywindow)
//                }
//            }
//            if let data = PcmRespose.data{
//                print(String(data: data, encoding: .utf8))
//                if let dic = JSON(data).dictionaryObject,let code = JSON(data)["code"].int{
//                    switch code {
//                    case code_succes:
//                        if self?.completion != nil {
//                            self?.completion!(.success(dic))
//                            debugPrint("上传成功")
//                        }
//                        break
//                    default:
//                        if self?.completion != nil {
//                            self?.completion!(.failure(.serverError(dic)))
//                            debugPrint("上传失败")
//                        }
//                        MBProgressHUD.showError((dic["msg"] as? String) ?? "上传失败", to: keywindow)
//                        break
//                    }
//                }else{
//                    if self?.completion != nil {
//                        self?.completion!(.failure(.netError))
//                        debugPrint("上传失败")
//                    }
//                    MBProgressHUD.showError("请求失败,请重试", to: keywindow)
//                }
//            }
//        }
        
        
    }
    
    func uploadData(_ data:Data){
        
        
        self.alreadyRecord += Int64(data.count)
        var buffer = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &buffer, count: data.count)
        self.boundStreams.output.write(buffer, maxLength: data.count)
        
    }
    
    func endUpload(){
        
       
        self.isEnd = true
        self.boundStreams.output.close()
    }
    
    func cancleLoad(){
        self.cancleState = true
        self.loadRequest?.cancel()
        self.boundStreams.output.close()

    }
    
    func stopStream(){
        self.boundStreams.output.close()
        
    }
    
    deinit {
        print("销毁了")
    }


}

