//
//  NetAPIManager.swift
//  NN110
//
//  Created by 陈亦海 on 2017/5/12.
//  Copyright © 2017年 陈亦海. All rights reserved.
//

import Foundation
import Moya

#if DEBUG
//    let HOSTURL = "https://52.163.48.60:8000"
//      let HOSTURL = "https://h2check.org/deploy/"
//let HOSTURL = "https://52.163.48.60:8000"
//let HOSTURL = "https://192.168.5.23:8000"
let HOSTURL = BaseUrl




//#else
//    let HOSTURL = "https://192.168.5.3:8000"
#endif


enum NetAPIManager {
    case upload(APIName: String , body:[String: Any]?,filePath: String,fileType: String,isShow: Bool)
    case request(APIName: String ,method:Moya.Method, body: Dictionary<String, Any>? ,isShow: Bool,encoding:ParameterEncoding = JSONEncoding.default)
}


extension NetAPIManager: TargetType {
    var headers: [String : String]? {


        return [
            "Content-Type" : "application/x-www-form-urlencoded;charset=UTF-8",
            "Accept": "application/json;application/octet-stream;text/html,text/json;text/plain;text/javascript;text/xml;application/x-www-form-urlencoded;image/png;image/jpeg;image/jpg;image/gif;image/bmp;image/*",
        ]
    }

    
//    var headers: [String : String]? {
//        switch self {
//        case .upload(_, _, _, _, _):
//            return ["Connection":"keep-alive"]
//        default:
//             return [:]
//        }
//
//    }
    var baseURL: URL {
        
        switch self {
        case .upload(_, _, _, _, _):
            return URL(string: "https://\(baseIP):3001")!
        default:
            return URL(string: HOSTURL)!

        }
        
    }
    
    var path: String {
        switch self {
        
        case .upload(let apiName, _, _, _, _):
            return apiName
      
        case  .request(let apiName, _, _, _,_):
            return apiName
        }
    }
    
    var method: Moya.Method {
        switch self {
       
       
        case .request(_, let method, _, _,_):
            return method
           
            
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        
        case .upload(_, let postDict,_, _, _):
            return postDict
       
        case .request(_, _, let postDict, _,_):
            return postDict
            
       
        
        }
    }
    
    var sampleData: Data {
       return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
            

        case .upload(_, let postDic, let filePath, let fileType, _):
            let url = URL(string: filePath)
                        
            let fileName = url?.lastPathComponent
           
            do {
                let data = try Data(contentsOf: url!)
                if postDic == nil {
                    return .uploadFile(url!)
                   
                }else{
                    var datas = [MultipartFormData(provider: .data(data), name: "file", fileName: fileName, mimeType: fileType)]
                    for (key, value) in postDic! {
                        let vStr = value as! String
                        let vData = vStr.data(using: String.Encoding.utf8)!
                        let mData = MultipartFormData(provider: .data(vData), name: key)
                        datas.append(mData)
                    }
                    return .uploadMultipart(datas)
                }
                
            } catch {
                return .requestPlain
            }
            
      
        case  .request(_, let method, let postDict, _,let encoding):
            
            guard postDict != nil else {
                return .requestPlain
            }
            if method == .get{
                return .requestParameters(parameters: postDict!, encoding: URLEncoding.default)

            }
            return .requestParameters(parameters: postDict!, encoding: encoding)

            
            
      
       }

     }
    

    
    //MARK:是否执行Alamofire验证
       private var validationType: Bool {
            return false
       }
  
    
    var show: Bool { //是否显示转圈提示
        
        switch self {
        case .request(_, _, _, let isShow,_):
            return isShow
        case .upload(_, _, _, _, let isShow):
            return isShow
        default:
            return true
        }
        
    }
    
   
}
