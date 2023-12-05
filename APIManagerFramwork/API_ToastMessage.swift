//
//  API_ToastMessage.swift
//  ApiCalling POD
//
//  Created by macOS on 28/11/23.
//

import Foundation
import Toast_Swift

public class API_ToastMessage : NSObject{
    static let shared:API_ToastMessage = API_ToastMessage()
    
    public enum MSG_TYPE{
        case success
        case error
        case waring
        
        func getInfo() -> (txtColor:UIColor,bgColor:UIColor){
            switch self{
            case .success:
                return (UIColor.black,UIColor.systemGreen)
            case .error:
                return (UIColor.white,UIColor.systemRed)
            case .waring:
                return (UIColor.black,UIColor.systemYellow)
            }
        }
    }
    
    public func show(msg:String,
              type:MSG_TYPE,
              duration:Double = 2.0,
              position:ToastPosition = .top){
        
        hideAll()
        
        var style = ToastStyle()
        style.messageColor = type.getInfo().txtColor
        style.backgroundColor = type.getInfo().bgColor
        style.fadeDuration = 0.5
        
        UIApplication.shared.windows[0].makeToast(msg,duration: duration,position: position,style: style)
    }
    
    public func hideAll(){
        UIApplication.shared.windows[0].hideAllToasts()
    }
}
