//
//  StreamPost.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/24.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit
import Foundation

public enum PostError:Swift.Error {
    
    case netError
    case serverError([String:Any])
}


public typealias PostCompletion = (_  reslut:Result<[String:Any],PostError>,_ created_on:String) -> Void

class StreamPost: NSObject {
    struct Streams {
        let input: InputStream
        let output: OutputStream
    }
    lazy var boundStreams: Streams = {
        var inputOrNil: InputStream? = nil
        var outputOrNil: OutputStream? = nil
        Stream.getBoundStreams(withBufferSize: 16000*16,
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
    
    var alreadyRecord:Int64 = 0
    var isEnd:Bool = false
    var completion:PostCompletion?
    var created_on:String!
    var cancleState = false
    var handleCancle:((_ created_on:String)->())?
    var serverStop:(()->())?


    
//    var session: URLSession = URLSession(configuration: .default,
//    delegate: self,
//    delegateQueue: .main)
    var session:URLSession?
    
    var canWrite = false
    
    var responseData:Data = Data()
    
    var uploadTask:URLSessionUploadTask?
    
    var subUrl:String?

    
    convenience init(_ created_on:String ,subUrl:String) {
        self.init()
        self.created_on = created_on
        //192.168.5.10
//        let url = URL(string: "https://52.163.48.60:8000/dialogues")!
//        let url = URL(string: "https://192.168.5.10:8000/course/1/dialog")!
//        subUrl = "/stream"
//        let urlStr = BaseUrl + "/stream"
        let urlStr = BaseUrl + subUrl
        self.subUrl = subUrl
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        
        var request = URLRequest(url: URL(string: urlStr)!,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 60)
//        request.allHTTPHeaderFields?.updateValue("keep-alive", forKey: "Connection")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
//        request.setValue("timeout=60", forHTTPHeaderField: "Keep-Alive")

        request.httpMethod = "POST"
        uploadTask = self.session?.uploadTask(withStreamedRequest: request)

        uploadTask!.resume()
        
//        var session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
//
//
//               var task = session.uploadTask(with: request as URLRequest, from: Data())
//               task.resume()
        
      
        
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
        cancleState = true
        self.boundStreams.output.close()
        self.uploadTask?.cancel()
    }
    
    deinit {
          print("streamPost销毁了")
      }
    
   
      
}


extension StreamPost:Foundation.URLSessionDelegate,Foundation.URLSessionTaskDelegate,Foundation.URLSessionDataDelegate{
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask,
                       needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
           completionHandler(boundStreams.input)
       }

    //上传进度
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        print("StreamPost=>已上传：\(bytesSent),总上传:\(totalBytesSent)，期望上传:\(totalBytesExpectedToSend)")
        if self.isEnd && self.alreadyRecord == totalBytesSent{
            self.boundStreams.output.close()

        }
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        let protectionSpace = challenge.protectionSpace
        if protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let serverTrust = protectionSpace.serverTrust
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust!))

        }else{
           completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil);
        }
    }


    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void){

         completionHandler(.allow)
    }


    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){

        self.responseData.append(data)
        if self.subUrl?.contains("/dialogs") ?? false{
            //获取数据长度
            let lenthByte = [UInt8](self.responseData);
            let lenBytes : [UInt8] = [lenthByte[0],lenthByte[1],lenthByte[2],lenthByte[3]]
            let len = UInt32(bitPattern: Data(bytes: lenBytes, count: 4).withUnsafeBytes { $0.pointee})
//            if len > 1000{
//                self.boundStreams.output.delegate = nil
//                self.boundStreams.output.close()
//            }
//            //获取数据类型
            
//            print("===总长度：\(len),====实际长度：\(self.responseData.count)")
            
            let typeBytes:[UInt8] = [lenthByte[4],lenthByte[5],lenthByte[6],lenthByte[7]]
            let type = UInt32(bitPattern: Data(bytes: typeBytes, count: 4).withUnsafeBytes { $0.pointee})
            if type == 0{
                self.boundStreams.output.delegate = nil
                self.boundStreams.output.close()

                if self.serverStop != nil{
                    self.serverStop!()
                }
            }
            if self.responseData.count == len + 8 {
                //收完
                self.responseData.removeFirst(8)
                if let dic = JSON(self.responseData).dictionaryObject,let code = JSON(self.responseData)["code"].int{
                    switch code {
                    case code_succes:
                        if self.completion != nil {
                            self.completion!(.success(dic),self.created_on)
                        }
                        break
                    default:
                        if self.completion != nil {
                            self.completion!(.failure(.serverError(dic)),self.created_on)
                            debugPrint("上传失败")
                        }
                        MBProgressHUD.showError((dic["msg"] as? String) ?? "上传失败", to: keywindow)
                        break
                    }
                }
                self.responseData.removeAll()
            }
        }
    }
    

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.boundStreams.output.delegate = nil
        self.boundStreams.output.close()
                
//        if self.subUrl?.contains("/dialogs") ?? false{
//            return
//        }
        
        if cancleState{
            if self.handleCancle != nil {
                self.handleCancle!(self.created_on)
            }
            return
        }
        
        if error != nil {
            if self.subUrl?.contains("/dialogs") ?? false{
                       return
                   }
            if self.completion != nil {
                self.completion!(.failure(.netError),self.created_on)
                debugPrint("上传失败")
            }
            MBProgressHUD.showError("请求失败,请重试", to: keywindow)
            return
        }
                
        if self.responseData.count != 0{
            if self.subUrl?.contains("/dialogs") ?? false{
                self.responseData.removeFirst(8)
            }
            
            if let dic = JSON(self.responseData).dictionaryObject,let code = JSON(self.responseData)["code"].int{
                switch code {
                case code_succes:
                    if self.completion != nil {
                        self.completion!(.success(dic),self.created_on)
                        debugPrint("上传成功")
                    }
                    break
                default:
                    
                    if self.completion != nil {
                        self.completion!(.failure(.serverError(dic)),self.created_on)
                        debugPrint("上传失败")
                    }
                    MBProgressHUD.showError((dic["msg"] as? String) ?? "上传失败", to: keywindow)
                    break
                }
            }else{
                if self.completion != nil {
                    self.completion!(.failure(.netError),self.created_on)
                    debugPrint("上传失败")
                }
                MBProgressHUD.showError("请求失败,请重试", to: keywindow)
            }
            return
        }
                    
    }

}
