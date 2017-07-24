//
//  Alamofire+Extension.swift
//  EagleFastSwift
//
//  Created by ggx on 2017/7/18.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
//import SwiftyJSON

//public enum ZWTServiceCode:Int {
//    case normal             = 0         //正常
//    case noPermission       = 403       //无权限
//    case warming            = 418       //警告
//    case serverException    = 500       //服务器异常
//    case channelException   = 204       //该渠道和版本异常
//    case error              = 1001      //失败
//    case unknown            = 99999     //未知错误
//    case outTime            = -1        //用户失效
//    case parameterError     = -2        //参数有误
//    var description:String {
//        get{
//            switch self {
//            case .normal:
//                return "正常"
//            case .noPermission:
//                return "无权限"
//            case .warming:
//                return "警告"
//            case .serverException:
//                return "服务器异常"
//            case .error:
//                return "失败"
//            case .outTime:
//                return "用户失效"
//            case .parameterError:
//                return "参数有误"
//            case .channelException:
//                return "该渠道和版本异常"
//            default:
//                return "未知错误"
//            }
//        }
//    }
//}
//extension NSError{
//    func msg() -> String {
//        var str = ""
//        for (key,value) in self.userInfo {
//            
//            
//            if ("\(key)".lowercased().contains("description") && !"\(value)".isEmpty) || ("\(key)".lowercased().contains("reason") && !"\(value)".isEmpty) {
//                str.append("\(value)")
//            }
//        }
//        return str
//    }
//}
//
//
//var k_AlamofireDataResponseCode = "k_AlamofireDataResponseCode"
//extension DataResponse{
//    var code:ZWTServiceCode?{
//        get{
//            return objc_getAssociatedObject(self, &k_AlamofireDataResponseCode) as? ZWTServiceCode
//        }
//        set{
//            objc_setAssociatedObject(self, &k_AlamofireDataResponseCode, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    var message:String?{
//        get{
//            if self.result.isFailure {
//                return (self.result.error! as NSError).msg()
//            }else{
//                var json = JSON(self.result.value as! NSDictionary)
//                return json["msg"].stringValue
//            }
//        }
//    }
//}
//
//extension DataRequest {
//    open static let defaultHTTPHeaders: HTTPHeaders = {
//        var header:HTTPHeaders = SessionManager.defaultHTTPHeaders
////        header["version_code"] = Config.device.version
//        return header
//    }()
//    @discardableResult
//    public func responseZWTJSON(
//        queue: DispatchQueue? = nil,
//        options: JSONSerialization.ReadingOptions = .allowFragments,
//        completionHandler: @escaping (DataResponse<Any>) -> Void)
//        -> Self
//    {
//        
//        let myCompletionHandler: (DataResponse<Any>) -> Void = {response in
//            var myResponse = response
//            var errorString:String?
//            var code:ZWTServiceCode = .unknown
//            if response.result.isSuccess {
//                var json = JSON(myResponse.result.value!)
//                if let t = ZWTServiceCode(rawValue: json["code"].intValue) {
//                    code = t
//                }
//                if json["result"]["userquit"].boolValue{
//                    code = .outTime
//                }
//                if !json["success"].boolValue {
//                    
//                    let errorMsg = json["Message"].stringValue
//                    let errorMsg2 = json["msg"].stringValue
//                    if !errorMsg.isEmpty {
//                        errorString = errorMsg
//                    }
//                    if !errorMsg2.isEmpty {
//                        errorString = errorMsg2
//                    }
//                }else{
//                    debugPrint(json)
//                }
//                
//                if errorString != nil {
//                    let testResponse: DataResponse<Any> = {
//                        let error: NSError = {
//                            return NSError(domain:"hostName", code: code.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: errorString ?? ""])
//                        }()
//                        return DataResponse(request: response.request, response: response.response, data: response.data, result: .failure(error))
//                    }()
//                    myResponse = testResponse
//                }
//            }else{
//                let testResponse: DataResponse<Any> = {
//                    let error: NSError = {
//                        var failureReason:String = ""
//                        
//                        let error:NSError = response.result.error! as NSError
//                        if error.userInfo["NSDebugDescription"] != nil{
//                            failureReason = error.userInfo["NSDebugDescription"]! as! String
//                        }
//                        if error.userInfo["NSLocalizedDescription"] != nil{
//                            failureReason = error.userInfo["NSLocalizedDescription"]! as! String
//                        }
//                        
//                        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
//                        return NSError(domain: "hostName", code: error.code, userInfo: userInfo)
//                    }()
//                    return DataResponse(request: response.request, response: response.response, data: response.data, result: .failure(error))
//                }()
//                myResponse = testResponse
//            }
//            
//            if myResponse.result.isFailure{
//                debugPrint("error description:\(String(describing: myResponse.message))")
//                debugPrint(myResponse.request!)
//                if myResponse.request?.httpBody != nil{
//                    let data = myResponse.request?.httpBody
//                    debugPrint(String(data: data!, encoding: String.Encoding.utf8)!)
//                }
//                if myResponse.data != nil {
//                    if let str = String(data: myResponse.data!, encoding: String.Encoding.utf8){
//                        debugPrint(str)
//                    }else{
//                        if let str = String(data: myResponse.data!, encoding: String.Encoding.utf8){
//                            debugPrint(str)
//                        }else{
//                            if let str = String(data: myResponse.data!, encoding: String.Encoding.utf8){
//                                debugPrint(str)
//                            }
//                        }
//                    }
//                }
//                
//            }
//            
////            if #available(iOS 9.0, *) {
////                let cellularData = CTCellularData()
////                if Int(Preference().loadCount!)!<Config.systemSetting.launchNetworkCount{
////                    Preference().loadCount = "\(Int(Preference().loadCount!)!+1)"
////                }
////                if Int(Preference().loadCount!)! > Config.systemSetting.launchNetworkCount{
////                    cellularData.cellularDataRestrictionDidUpdateNotifier = {state in
////                        if state == .restricted{
////                            UIAlertController.alertMessage("请前往 iPhone中的设置>\(Config.device.displayName!)>无线数据 并开启网络权限", title: "您的'\(Config.device.displayName!)'app访问网络受限", btnTitles: ["我知道了"], action: { (index) in
////                                
////                            })
////                        }
////                    }
////                }
////            } else {
////                // Fallback on earlier versions
////            }
//            
//            if myResponse.code == .noPermission {
////                UIAlertController.alertMessage(response.message!, title: "", btnTitles: ["确定"], action: { (index) in
////                    NotificationCenter.default.post(name: .noPermission, object: nil)
////                })
//            }else if code == .outTime{
////                NotificationCenter.default.post(name: .userLogout, object: nil)
//            }
//            completionHandler(myResponse);
//        }
//        return response(
//            queue: queue,
//            responseSerializer: DataRequest.jsonResponseSerializer(options: options),
//            completionHandler: myCompletionHandler
//        )
//    }
//    
//    
//}
