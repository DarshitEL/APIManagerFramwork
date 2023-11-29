//
//  Api_Manager.swift
//  ApiCalling POD
//
//  Created by macOS on 28/11/23.
//

import Foundation
import Alamofire


public class API_Manager{
    public static let shared:API_Manager = API_Manager()
 
    
    private var alamoFireManager = Alamofire.Session.default
    private var currentDataRequest:DataRequest!
    
    
    public enum RESPONSE_TYPE{
        case SUCCESS
        case ERROR
    }
    
    // METHODS
    init() {
        alamoFireManager.session.configuration.timeoutIntervalForRequest = 180
    }
}

// Common Method
extension API_Manager{
 
    private func getRequiredHTTPHeader(arrHedar:[String:String]) -> HTTPHeaders{
        
        var arrHTTPHeader:HTTPHeaders = [HTTPHeader(name: "Accept", value: "application/json")]
        
        for (key,value) in arrHedar{
            arrHTTPHeader.add(HTTPHeader(name: key, value: value))
        }
        
        return arrHTTPHeader
    }
    
    private func checkInternetConnection() -> Bool{
        let manager = NetworkReachabilityManager()
        let isReachable = manager?.isReachable ?? false
        
        if !isReachable{
            API_ToastMessage.shared.show(msg: "Internet connection appears to be offline.", type: .waring)
        }
    
        return isReachable
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func getMimeType(fileExt:String) -> String{
        var mime = ""
        switch fileExt{
        case "jpeg":
            mime = "image/jpeg"
            break
        case "jpg":
            mime = "image/jpg"
            break
        case "png":
            mime = "image/png"
            break
        case "gif":
            mime = "image/gif"
            break
        case "3gpp":
            mime = "video/3gpp"
            break
        case "3gp":
            mime = "video/3gpp"
            break
        case "ts":
            mime = "video/mp2t"
            break
        case "mp4":
            mime = "video/mp4"
            break
        case "mpeg":
            mime = "video/mpeg"
            break
        case "mpg":
            mime = "video/mpg"
            break
        case "mov":
            mime = "video/quicktime"
            break
        case "webm":
            mime = "video/webm"
            break
        case "flv":
            mime = "video/x-flv"
            break
        case "m4v":
            mime = "video/x-m4v"
            break
        case "mng":
            mime = "video/x-mng"
            break
        case "asx":
            mime = "video/x-ms-asf"
            break
        case "asf":
            mime = "video/x-ms-asf"
            break
        case "wmv":
            mime = "video/x-ms-wmv"
            break
        case "avi":
            mime = "video/x-msvideo"
            break
        case "docx":
            mime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "xlsx":
            mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "pptx":
            mime = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case "doc":
            mime = "application/msword"
        case "pdf":
            mime = "application/pdf"
        case "txt":
            mime = "text/plain"
            
        default:
            break
        }
        
        return mime
    }
    
    private func COMMON_METHOD(requestURL:String,
                               method:HTTPMethod,
                               param:[String: Any],
                               hedar:[String: String],
                               isShowLoader:Bool,
                               responseData:@escaping(_ responseType:RESPONSE_TYPE,
                                                      _ error:Error?,
                                                      _ responseDict:[String: Any]?) -> Void) {
        if checkInternetConnection(){
            if isShowLoader {API_Loader.shared.show()}
            
            if method == .put || method == .post{
                
                currentDataRequest = alamoFireManager.request(requestURL,
                                                              method: method,
                                                              parameters: param,
                                                              encoding: JSONEncoding.default,
                                                              headers: getRequiredHTTPHeader(arrHedar: hedar))
            }else{
                currentDataRequest = alamoFireManager.request(requestURL,
                                                              method: method,
                                                              parameters: param,
                                                              headers: getRequiredHTTPHeader(arrHedar: hedar))
            }
            
            currentDataRequest.responseString(completionHandler: { (responseString) in
                if isShowLoader {API_Loader.shared.hide()}
                
                if let httpStatusCode = responseString.response?.statusCode,
                   let strResponse = responseString.value,strResponse.count > 0{
                    
                    let dict = self.convertToDictionary(text: strResponse)
                    let isSuccess = httpStatusCode == 200 || httpStatusCode == 201
                    responseData(isSuccess ? .SUCCESS : .ERROR,nil,dict)
                    return
                    
                }
                
                API_ToastMessage.shared.show(msg: responseString.error?.localizedDescription ?? "Server Response Error", type: .error)
                responseData(.ERROR,responseString.error,nil)
            })
        }
    }
}

// GET Method
extension API_Manager{
    
    public func GET_METHOD(requestURL:String,
                           param:[String: Any] = [:],
                           hedar:[String: String] = [:],
                           isShowLoader:Bool = true,
                           responseData:@escaping(_ responseType:RESPONSE_TYPE,
                                                  _ error:Error?,
                                                  _ responseDict:[String: Any]?) -> Void) {
        
        COMMON_METHOD(requestURL: requestURL,
                      method: .get,
                      param: param,
                      hedar: hedar,
                      isShowLoader: isShowLoader) { responseType, error, responseDict in
            responseData(responseType,error,responseDict)
        }
    }
    
}

// POST/PUT Method
extension API_Manager{
    public func POST_METHOD(requestURL:String,
                           param:[String: Any] = [:],
                           hedar:[String: String] = [:],
                           isShowLoader:Bool = true,
                           responseData:@escaping(_ responseType:RESPONSE_TYPE,
                                                  _ error:Error?,
                                                  _ responseDict:[String: Any]?) -> Void) {
        
        COMMON_METHOD(requestURL: requestURL,
                      method: .post,
                      param: param,
                      hedar: hedar,
                      isShowLoader: isShowLoader) { responseType, error, responseDict in
            responseData(responseType,error,responseDict)
        }
    }
    
    public func PUT_METHOD(requestURL:String,
                           param:[String: Any] = [:],
                           hedar:[String: String] = [:],
                           isShowLoader:Bool = true,
                           responseData:@escaping(_ responseType:RESPONSE_TYPE,
                                                  _ error:Error?,
                                                  _ responseDict:[String: Any]?) -> Void) {
        
        COMMON_METHOD(requestURL: requestURL,
                      method: .put,
                      param: param,
                      hedar: hedar,
                      isShowLoader: isShowLoader) { responseType, error, responseDict in
            responseData(responseType,error,responseDict)
        }
    }
}

// MULTIPART Method
extension API_Manager{
    
    public func MULTIPART_METHOD(requestURL:String,
                                 param:[String: Any] = [:],
                                 hedar:[String: String] = [:],
                                 isShowLoader:Bool = true,
                                 responseData:@escaping (_ responseType:RESPONSE_TYPE,
                                                         _ error:Error?,
                                                         _ responseDict:[String: Any]?) -> Void){
        
        if checkInternetConnection(){
            if isShowLoader {API_Loader.shared.show()}
            
            alamoFireManager.upload(multipartFormData: { multipartFormData in
                for (key, value) in param {
                    
                    if let imgVal = value as? UIImage{
                        
                        multipartFormData.append(imgVal.jpegData(compressionQuality: 0.75)!,
                                                 withName: key,
                                                 fileName: "\(Date().timeIntervalSince1970).jpeg",
                                                 mimeType: self.getMimeType(fileExt: "jpeg"))
                        
                    }else if let dataVal = value as? Data{
                        
                        multipartFormData.append(dataVal,
                                                 withName: key,
                                                 fileName: "\(Date().timeIntervalSince1970).jpeg",
                                                 mimeType: self.getMimeType(fileExt: "jpeg"))
                        
                    }else if let urlVal = value as? URL{
                        let fileExt = (urlVal.lastPathComponent.components(separatedBy: ".").last!).lowercased()
                        var fileData:Data? = nil
                        do{
                            fileData = try Data.init(contentsOf: urlVal)
                            multipartFormData.append(fileData!,
                                                     withName: key,
                                                     fileName: "\(Date().timeIntervalSince1970).\(fileExt)",
                                                     mimeType: self.getMimeType(fileExt: fileExt))
                        }catch let error{
                            print("\(error.localizedDescription)")
                        }
                    }else if let strVal = value as? String{
                        multipartFormData.append(strVal.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            },to: requestURL,method:.post,headers:getRequiredHTTPHeader(arrHedar: hedar)).responseString(completionHandler: {(responseString) in
                
                if isShowLoader {API_Loader.shared.hide()}
                
                if let httpStatusCode = responseString.response?.statusCode,
                   let strResponse = responseString.value,strResponse.count > 0{
                    
                    let dict = self.convertToDictionary(text: strResponse)
                    let isSuccess = httpStatusCode == 200 || httpStatusCode == 201
                    responseData(isSuccess ? .SUCCESS : .ERROR,nil,dict)
                    return
                    
                }
                
                API_ToastMessage.shared.show(msg: responseString.error?.localizedDescription ?? "Server Response Error", type: .error)
                responseData(.ERROR,responseString.error,nil)
            })
        }
    }
}

// DELETE Method
extension API_Manager{
    
    public func DELETE_METHOD(requestURL:String,
                              param:[String: Any] = [:],
                              hedar:[String: String] = [:],
                              isShowLoader:Bool = true,
                              responseData:@escaping(_ responseType:RESPONSE_TYPE,
                                                     _ error:Error?,
                                                     _ responseDict:[String: Any]?) -> Void){
        COMMON_METHOD(requestURL: requestURL,
                      method: .delete,
                      param: param,
                      hedar: hedar,
                      isShowLoader: isShowLoader) { responseType, error, responseDict in
            responseData(responseType,error,responseDict)
        }
    }
}

// Cancel Running Request Method
extension API_Manager{
    public func cancelAllAlamofireRequests(responseData:@escaping ( _ status: Bool?) -> Void) {
        alamoFireManager.session.getTasksWithCompletionHandler {
            dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
            responseData(true)
        }
    }
    
    public func cancelCurrentAlamofireRequests(){
        if let req = currentDataRequest{
            req.cancel()
            currentDataRequest = nil
        }
    }
}
