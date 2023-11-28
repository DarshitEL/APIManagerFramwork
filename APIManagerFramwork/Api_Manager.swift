//
//  Api_Manager.swift
//  ApiCalling POD
//
//  Created by macOS on 28/11/23.
//

import Foundation
import Alamofire


class API_Manager{
    static let shared:API_Manager = API_Manager()
 
    
    private var alamoFireManager = Alamofire.Session.default
    private var currentDataRequest:DataRequest!
    
    
    enum RESPONSE_TYPE{
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
}

// GET Method
extension API_Manager{
    
    func GET_METHOD(requestURL:String,
                    param:[String: Any] = [:],
                    hedar:[String: String] = [:],
                    isShowLoader:Bool = true,
                    responseData:@escaping(_ responseType:RESPONSE_TYPE,
                                           _ error:Error?,
                                           _ responseDict:[String: Any]?) -> Void) {
        if checkInternetConnection(){
            if isShowLoader {API_Loader.shared.show()}
            
            currentDataRequest = alamoFireManager.request(requestURL,
                                                          method: .get,
                                                          parameters: param,
                                                          headers: getRequiredHTTPHeader(arrHedar: hedar)).responseString(completionHandler: { (responseString) in
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

// POST Method
extension API_Manager{
    
}

// PUT Method
extension API_Manager{
    
}

// DELETE Method
extension API_Manager{
    
}

// Cancel Running Request Method
extension API_Manager{
    func cancelAllAlamofireRequests(responseData:@escaping ( _ status: Bool?) -> Void) {
        alamoFireManager.session.getTasksWithCompletionHandler {
            dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
            responseData(true)
        }
    }
}
