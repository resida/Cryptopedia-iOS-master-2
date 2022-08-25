//
//  UIApplicationExtension.swift
//  Cryptonomy
//

import Foundation
import UIKit
import SwiftyUserDefaults
import SwiftRater

extension AppDelegate {
    func navigationBarAttributeSettings() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.circularMedium(17.0)]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()

        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularBook(15.0)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularBook(15.0)], for: .highlighted)
    }

    func swiftRaterSettings() {
        SwiftRater.daysUntilPrompt = 7
        SwiftRater.usesUntilPrompt = 10
        SwiftRater.significantUsesUntilPrompt = 3
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = true
        SwiftRater.appLaunched()
    }
    
    func tabbarSettings() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularBook(11.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularBook(11.0)], for: .highlighted)
        
        UITabBar.appearance().tintColor = UIColor.c_Blue
    }
    
    func searchBarSettings() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.circularBook(15.0)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.lightGray
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularBook(15.0),NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
    }
    
    func currencySettings() {
        guard let _ = Defaults[.currentCurrency] else {
            Defaults[.currentCurrency] = "USD"
            return
        }
    }
}
