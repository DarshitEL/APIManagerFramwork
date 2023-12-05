//
//  Api-Loader.swift
//  ApiCalling POD
//
//  Created by macOS on 28/11/23.
//

import Foundation
import Lottie
import AutoChangeColor

public class API_Loader:NSObject{
    static let shared:API_Loader = API_Loader()
    private var bgview = UIView()
    
    // const
    private let float_LoaderHegithWidth:CGFloat = 80 // loader view height width
    private let float_BGViewAlpha:CGFloat = 0.75 // main fullscreen background view alpha
    private let uicolor_LoaderBGColor:UIColor = UIColor.black.withAlphaComponent(0.5) // loader view bg color
    
    private func showHUD(view:UIView){
        self.bgview.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        self.bgview.backgroundColor = UIColor.black.withAlphaComponent(float_BGViewAlpha)
        
        let float_HalfLoaderHegith:CGFloat = float_LoaderHegithWidth / 2
        
        let loaderbgview = AutoChangeColorView()
        loaderbgview.frame = CGRect(x: bgview.frame.width/2 - float_HalfLoaderHegith,
                                    y: bgview.frame.height/2 - float_HalfLoaderHegith,
                                    width:float_LoaderHegithWidth,
                                    height: float_LoaderHegithWidth)
        loaderbgview.isAnimated = true
        loaderbgview.backgroundColor = uicolor_LoaderBGColor
        loaderbgview.layer.cornerRadius = float_HalfLoaderHegith
        loaderbgview.clipsToBounds = true
        
        let bundle = Bundle(for: API_Loader.self)
        var animationView:LottieAnimationView = LottieAnimationView()
        animationView = LottieAnimationView.init(name: "Api-Loader",bundle: bundle)
        animationView.frame = CGRect(x: 0, y: 0, width:float_LoaderHegithWidth, height: float_LoaderHegithWidth)
        animationView.center = loaderbgview.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.stop()
        
        self.bgview.addSubview(loaderbgview)
        self.bgview.addSubview(animationView)
        animationView.play()
        view.addSubview(bgview)
    }
    
    public func show(){
        showHUD(view: UIApplication.shared.windows[0])
    }
  
    public func hide(){
        self.bgview.removeFromSuperview()
    }
}
