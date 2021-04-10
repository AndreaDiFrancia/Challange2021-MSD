//
//  AppDelegate.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        DataManager.shared.retrieveUserData(onSuccess: {
            debugPrint("User already created")
        }) { (error) in
            debugPrint(error.localizedDescription)
            let birthday = Date(timeIntervalSince1970: 0.0)
            DataManager.shared.user = User(name: "Elena Rossi", gender: .female, birthDay: birthday, height: 175, weight: 70)
            DataManager.shared.storeUserData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(subscribeNotif), name: NSNotification.Name(rawValue: "subscribeNotif"), object: nil)
        
        // Setting up the class that will handle all the notifications
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = NotificationCenterManager.shared
        
        if UserDefaults.standard.bool(forKey: Key.kOnboardingDone) {
            // Request authorization to display notifications
            NotificationCenterManager.shared.requestAuthorizationForNotifications()
            
            // Register with APNs
            self.registerForPushNotifications(application)
            self.registerRemindersNotificationActions()
        }
        
        return true
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "foreground"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        PersistenceService.saveContext()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == Key.kHistoryShortcut {
            if let window = self.window, window.rootViewController is MainTabBarController, UserDefaults.standard.bool(forKey: Key.kOnboardingDone) != false {
                let tabBarController = window.rootViewController as! MainTabBarController
                tabBarController.selectedIndex = 1
            }
            completionHandler(true)
        } else if shortcutItem.type == Key.kProfileShortcut {
            if let window = self.window, window.rootViewController is MainTabBarController, UserDefaults.standard.bool(forKey: Key.kOnboardingDone) != false {
                let tabBarController = window.rootViewController as! MainTabBarController
                tabBarController.selectedIndex = 2
            }
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    // If you want to be able to receive Push Notifications you must
    //  register your application for it.
    func registerForPushNotifications(_ application: UIApplication) {
        application.registerForRemoteNotifications()
    }
    
    @objc func subscribeNotif() {
        // Register with APNs
        self.registerForPushNotifications(UIApplication.shared)
        self.registerRemindersNotificationActions()
    }
    
}

// MARK: - Register notification actions
extension AppDelegate {
    
    // TODO: Explain what it is
    
    func registerRemindersNotificationActions() {
        // 1. Create the actions
        
        let okVisitReminder =
            
            UNNotificationAction(identifier: "answer1",
                                 title: "Ok, thanks" ,
                                 options: [.authenticationRequired])
        
        let snoozeVisitReminder =
            UNNotificationAction(identifier: "answer2",
                                 title: "Snooze",
                                 options: [.authenticationRequired])
        
        // 2. Create the category associated with the actions
        let reminderCategory =
            UNNotificationCategory(identifier: NotificationCategoryIdentifier.reminder,
                                   actions: [okVisitReminder, snoozeVisitReminder],
                                   intentIdentifiers: [],
                                   options: [])
        

        
        let reminderPillCategory =
            UNNotificationCategory(identifier: NotificationCategoryIdentifier.pills,
                                   actions: [okVisitReminder, snoozeVisitReminder],
                                   intentIdentifiers: [],
                                   options: [])
        
        // 3. Register the category in the Notification Center
        UNUserNotificationCenter.current()
            .setNotificationCategories([reminderPillCategory,reminderCategory])
        
    }
    
}
