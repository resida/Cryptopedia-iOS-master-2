//  AppDelegate.swift
//  Cryptonomy
//
//

import UIKit
import Firebase
import OneSignal
import SwiftWebVC
import SwiftyUserDefaults

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver {

    var window: UIWindow?
    @IBOutlet weak var tabBarController: UITabBarController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.swiftRaterSettings()
        self.tabbarSettings()
        self.searchBarSettings()
        self.navigationBarAttributeSettings()
        self.currencySettings()
        self.oneSignalSettings(launchOptions: launchOptions)

        return true
    }

    func oneSignalSettings(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            print("Received Notification: \(notification!.payload.notificationID ?? "")")
            print("launchURL = \(notification?.payload.launchURL ?? "None")")
            print("content_available = \(notification?.payload.contentAvailable ?? false)")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            
            print("Message = \(payload!.body ?? "")")
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "None")")
            
            if let category = payload?.category {
                if category.lowercased() == "news" {
                    if let data = result!.notification.payload!.additionalData {
                        if let actionID = result?.action.actionID {
                            if actionID.lowercased() == "view", let url = data["url"] as? String {
                                self.openNews(url: url)
                            }
                        } else {
                            if let url = data["url"] as? String {
                                self.openNews(url: url)
                            }
                        }
                    }
                }
            }
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true, kOSSettingsKeyInAppLaunchURL: true]
        OneSignal.initWithLaunchOptions(launchOptions, appId: Global.OneSignalAppID, handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        
        OneSignal.add(self as OSPermissionObserver)
        OneSignal.add(self as OSSubscriptionObserver)
    }
    
    func openNews(url: String) {
        let tabController = self.window?.rootViewController as! UITabBarController
        let navInTab: UINavigationController = tabController.selectedViewController as! UINavigationController
        
        let webVC = SwiftModalWebVC(urlString: url)
        webVC.title = "News"
        navInTab.present(webVC, animated: true, completion: nil)
    }
    
    static func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
            self.checkForNotification(status: stateChanges.to.status)
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(String(describing: stateChanges))")
    }

    func checkForNotification(status: OSNotificationPermission) {
        guard let _ = Defaults[.pushNotification] else {
            return
        }
        Defaults[.pushNotification] = status == .authorized
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(tabBarController.selectedIndex)
        
        if tabBarController.selectedIndex == 0 {
            let navController = tabBarController.selectedViewController as? UINavigationController
            let homeController = navController?.viewControllers[0] as? HomeVC
            homeController?.updateHomeHeaderData()
            
            //let homeHeaderVC = homeController?.headerViewController as? HomeHeaderVC
            //homeHeaderVC?.viewModel.fetchHomeHeaderDataPro()
        }
    }    
}

extension AppDelegate : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: HomeVC.self) || viewController.isKind(of: PortfolioVC.self) {
            navigationController.navigationBar.barTintColor = UIColor.c_Blue
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        } else if viewController.isKind(of: MarketDetailVC.self) {
            navigationController.navigationBar.barTintColor = UIColor.c_CommonDarkColor
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        } else if viewController.isKind(of: MarketVC.self) || viewController.isKind(of: EducationVC.self) {
            navigationController.navigationBar.barTintColor = UIColor.white
            navigationController.navigationBar.tintColor = UIColor.black
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        }
    }
}
