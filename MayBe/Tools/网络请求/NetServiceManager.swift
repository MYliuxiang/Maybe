//
//  NetServiceManager.swift
//  NN110
//
//  Created by 陈亦海 on 2017/5/12.
//  Copyright © 2017年 陈亦海. All rights reserved.
//

import Foundation
import Alamofire
import Moya

let code_succes          = 200   //请求成功


// MARK: - Provider setup系统方法转换json数据
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

private func JSONResponseFormatter(_ data: Data) -> Dictionary<String, Any>? {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        
        return dataAsJSON as? Dictionary<String, Any>
    } catch {
        return nil // fallback to original data if it can't be serialized.
    }
}

// MARK: - 默认的网络提示请求插件
let spinerPlugin = NetworkActivityPlugin { (state,target) in
    if state == .began {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    } else {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
}

// MARK: - 自定义的网络提示请求插件
let myNetworkPlugin = LxCustomPlugin { (state,target) in
    
    //    var api = target as! NetAPIManager
    //
    //
    //    if state == .began {
    //
    //        if api.show{
    //            DispatchQueue.main.async {
    //               MBProgressHUD.showAdded(to: keywindow, animated: true)
    //            }
    //        }
    //
    //
    //    } else {
    //
    //        if api.show{
    //
    //            MBProgressHUD.hideAllHUDs(for: keywindow, animated: true)
    //        }
    //    }
}




// MARK: - 设置请求头部信息
let myEndpointClosure = { (target: NetAPIManager) -> Endpoint in
    
    let sessionId =  ""
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    
    let endpoint = Endpoint.init(url: url, sampleResponseClosure:  { .networkResponse(200, target.sampleData) }, method: target.method, task: target.task, httpHeaderFields: target.headers)
    
    return endpoint.adding(newHTTPHeaderFields: [
        "Content-Type" : "application/x-www-form-urlencoded;charset=UTF-8",
        "Accept": "application/json;application/octet-stream;text/html,text/json;text/plain;text/javascript;text/xml;application/x-www-form-urlencoded;image/png;image/jpeg;image/jpg;image/gif;image/bmp;image/*"
    ])
    
}


// MARK: - 设置请求超时时间
let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<NetAPIManager>.RequestResultClosure) in
    
    do {
        var request: URLRequest = try endpoint.urlRequest()
        request.timeoutInterval = 10    //设置请求超时时间
        done(.success(request))
    } catch  {
        print("错误了 \(error)")
    }
    
    
}

public typealias SuccessCompletion = (_ result: Dictionary<String, Any>?,_ code:Int) -> Void

//let myNetworkLoggerPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: { (data: Data) -> Data in
//    //            return Data()
//    do {
//        let dataAsJSON = try JSONSerialization.jsonObject(with: data)// Data 转 JSON
//        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)// JSON 转 Data，格式化输出。
//        return prettyData
//    } catch {
//        return data
//    }
//})
let myNetworkLoggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration.init(logOptions:[.verbose]))


let session = { () -> Session in
    let manager = ServerTrustManager(allHostsMustBeEvaluated:false,evaluators: [baseIP:DisabledTrustEvaluator()])
    let session = Session(serverTrustManager: manager)
  
    return  session
}

let MyAPIProvider = MoyaProvider<NetAPIManager>(endpointClosure: myEndpointClosure,requestClosure: requestClosure,session: session(), plugins: [myNetworkPlugin])



//let sessionManger = { () -> ServerTrustManager? in
//    let manger = AF.serverTrustManager
////    manger!.allHostsMustBeEvaluated = false
//
//    return manger
//
//}


//let manger = MoyaProvider<NetAPIManager>.defaultAlamofireManager()
//  manager.delegate.sessionDidReceiveChallenge = {
//             session,challenge in
//           
//    return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
//        
//}



// MARK: -取消所有请求
func cancelAllRequest() {
        
    MyAPIProvider.session.cancelAllRequests(completingOnQueue: DispatchQueue.main) {
    }
}


public enum TZMethod {
    case get,post,put,delete
    var method:Moya.Method{
        switch self {
        case .get:
            return .get
        case .put:
            return .put
        case .delete:
            return .delete
        default:
            return .post
        }
    }
}

@discardableResult
public func MBuploadFile(_ name:String,show:Bool = true,logError:Bool = true,postDic:Dictionary<String, Any>? = nil,filePath: String,fileType: String,progress:@escaping (Double)->(),completion: @escaping SuccessCompletion) -> Cancellable?{
    
    let target = NetAPIManager.upload(APIName: name, body: postDic, filePath: filePath, fileType: fileType, isShow: show)
        
    let request = MyAPIProvider.request(target, callbackQueue: DispatchQueue.main, progress: { (moyaprogress) in
        progress(moyaprogress.progress)
        
    }) { (result) in
        switch result {
        case let .success(moyaResponse):
//            LLog("\n[REQUEST PATH]:\n  \(target.method):\(moyaResponse.request?.url?.absoluteString ?? "")\n[REQUEST HEADERS]:\n  \(target.headers!)\n[REQUEST BODY]:\n  \(target.task)\n[REQUEST CALLBACK]:\n  [RESULT:\(moyaResponse.statusCode)]\n  \((JSON(moyaResponse.data).dictionary) ?? [:])\n")
//            LLog(moyaResponse.data.st)
//            print(filePath)
//           LLog(String(data: moyaResponse.data, encoding: .utf8))
            
            if moyaResponse.statusCode == 200, let code = JSON(moyaResponse.data)["code"].int {
                switch code {
                case code_succes:
                    if let  dic = JSON(moyaResponse.data).dictionaryObject {
                        completion(dic,code)
                    }
                default:
                    if let  dic = JSON(moyaResponse.data).dictionaryObject {
                        completion(dic,code)
                        if logError {
                            MBProgressHUD.showError(JSON(moyaResponse.data)["msg"].stringValue, to: keywindow)
                        }
                    }
                }
            }else {
                completion(nil,-1)
                MBProgressHUD.showError("请求失败,请重试", to: keywindow)
            }
            break
        case .failure(_):
            MBProgressHUD.showError("系统异常,请重试", to: keywindow)
            completion(nil,-1)
            break
        }
        
    }
    
    
    
    return request
        
}


@discardableResult
public func MBRequest(_ name: String, method:TZMethod = .post, bodyDict: [String: Any]? = nil, show: Bool = true,logError:Bool = true,encoding:ParameterEncoding = JSONEncoding.default,completion: @escaping SuccessCompletion)-> Cancellable? {
    
    let target = NetAPIManager.request(APIName: name, method: method.method, body: bodyDict, isShow: show,encoding: encoding)
    let request = MyAPIProvider.request(target) { result in
        switch result {
        case let .success(moyaResponse):
//            LLog("\n[REQUEST PATH]:\n  \(method):\(moyaResponse.request?.url?.absoluteString ?? "")\n[REQUEST HEADERS]:\n  \(target.headers!)\n[REQUEST BODY]:\n  \(target.task)\n[REQUEST CALLBACK]:\n  [RESULT:\(moyaResponse.statusCode)]\n  \((JSON(moyaResponse.data).dictionary) ?? [:])\n")
            
            if moyaResponse.statusCode == 200, let code = JSON(moyaResponse.data)["code"].int {
                switch code {
                case code_succes:
                    if let  dic = JSON(moyaResponse.data).dictionaryObject {
                        completion(dic,code)
                    }
                default:
                    if let  dic = JSON(moyaResponse.data).dictionaryObject {
                        completion(dic,code)
                        if logError {
                            MBProgressHUD.showError(JSON(moyaResponse.data)["msg"].stringValue, to: keywindow)
                        }
                    }
                }
            }else {
                completion(nil,-1)
                MBProgressHUD.showError("请求失败,请重试", to: keywindow)
            }
            break
        case .failure(let error):
            print(error.errorUserInfo)
            MBProgressHUD.showError("系统异常,请重试", to: keywindow)
            completion(nil,-1004)
            
            break
        }
        
    }
    return request
    
}



//获取客户端证书相关信息
func extractIdentity() -> IdentityAndTrust {
    var identityAndTrust:IdentityAndTrust!
    var securityError:OSStatus = errSecSuccess
    
    let path: String = Bundle.main.path(forResource: "mykey", ofType: "p12")!
    let PKCS12Data = NSData(contentsOfFile:path)!
    let key : NSString = kSecImportExportPassphrase as NSString
    let options : NSDictionary = [key : "123456"] //客户端证书密码
    //create variable for holding security information
    //var privateKeyRef: SecKeyRef? = nil
    
    var items : CFArray?
    
    securityError = SecPKCS12Import(PKCS12Data, options, &items)
    
    if securityError == errSecSuccess {
        let certItems:CFArray = (items as CFArray?)!;
        let certItemsArray:Array = certItems as Array
        let dict:AnyObject? = certItemsArray.first;
        if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
            // grab the identity
            let identityPointer:AnyObject? = certEntry["identity"];
            let secIdentityRef:SecIdentity = (identityPointer as! SecIdentity?)!
            print("\(String(describing: identityPointer))  :::: \(secIdentityRef)")
            // grab the trust
            let trustPointer:AnyObject? = certEntry["trust"]
            let trustRef:SecTrust = trustPointer as! SecTrust
            print("\(String(describing: trustPointer))  :::: \(trustRef)")
            // grab the cert
            let chainPointer:AnyObject? = certEntry["chain"]
            identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                trust: trustRef, certArray:  chainPointer!)
        }
    }
    return identityAndTrust;
}

//定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}
