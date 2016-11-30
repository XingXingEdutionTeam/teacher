//
//  RuningXX.swift
//  teacher
//
//  Created by codeDing on 16/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//


import UIKit

public class RuningXX: UIView {//加载动画效果
    class var sharedInstance: RuningXX {
        struct Singleton {
            static let instance = RuningXX()
        }
        return Singleton.instance
    }
    
    let kScreenWidth = UIScreen.main.bounds.width
    let kScreenHeight = UIScreen.main.bounds.height
    
    var runingBackView: RuningView!
    let backWh: CGFloat = 75
    func showRuning(){
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear
        if self.runingBackView == nil{
            runingBackView = RuningView(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight - 64))
            runingBackView.backgroundColor = UIColor.white
//            runingBackView = RuningView(frame: CGRect(x: (UIScreen.main.bounds.width - backWh)/2, y: (UIScreen.main.bounds.height - backWh)/2, width: backWh, height: backWh))
//            runingBackView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
//            runingBackView.setWane(12)
            self.addSubview(runingBackView)
        }
        self.runingBackView.runingImgView.startAnimating()
        let window: AnyObject? = UIApplication.shared.windows[1]
        window?.addSubview(self)
    }
    
    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
//            self.backgroundColor = UIColor.gr
        }) { (finished) -> Void in
            if finished{
                if self.runingBackView != nil{
                    self.runingBackView.runingImgView.stopAnimating()
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    func dismissWithAnimation(succeed: @escaping ()->Void){
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.backgroundColor = UIColor.gray
        }) { (finished) -> Void in
            succeed()
            if finished{
                if self.runingBackView != nil{
                    self.runingBackView.runingImgView.stopAnimating()
                    self.removeFromSuperview()
                }
            }
        }
    }
    
}


