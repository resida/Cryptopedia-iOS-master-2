//
//  MessageUtil.swift
//  ICOCO
//
//  Created by 구홍석 on 2017. 9. 2..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit

class MessageUtil {
    class func showAlert(targetVc: UIViewController?, title: String?, message: String?, completion: (() -> Void)?) {
        if let vc = targetVc ?? UiUtil.topViewController() {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { (action) in
                completion?()
            })
            alertController.addAction(okAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showConfirmAlert(targetVc: UIViewController?, title: String?, message: String?, completion: ((Bool) -> Void)?) {
        if let vc = targetVc ?? UiUtil.topViewController() {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { (action) in
                completion?(true)
            })
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: { (action) in
                completion?(false)
            })
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}
