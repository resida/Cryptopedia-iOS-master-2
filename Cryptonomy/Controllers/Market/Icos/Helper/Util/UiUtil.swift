//
//  UiUtil.swift
//  ICOCO
//
//  Created by 구홍석 on 2017. 9. 2..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit

class UiUtil {
    class func topViewController() -> UIViewController? {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        if true == vc?.isKind(of: UINavigationController.self) {
            let naviController = vc as! UINavigationController
            return naviController.topViewController
        } else if true == vc?.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return tabBarController.selectedViewController
        } else if true == vc?.isKind(of: UISplitViewController.self) {
            let splitVC = vc as! UISplitViewController
            return splitVC.viewControllers.last
        } else if true == vc?.isKind(of: UIViewController.self) {
            return vc
        } else {
            return vc?.presentedViewController
        }
    }
    
    class func makeActivityIndicator(parentView: UIView?) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        if nil != parentView {
            indicator.center = parentView!.center
            parentView!.addSubview(indicator)
        }
        return indicator
    }
}
