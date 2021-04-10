//
//  NotificationCenterManager.swift
//
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

// - MARK: Setting up the
class NotificationCenterManager: NSObject, UNUserNotificationCenterDelegate {
    
    // Singleton
    
    public static let shared: NotificationCenterManager = NotificationCenterManager()
    
    // Called before a notification is presented to the user
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /*
         1. App needs to be in foreground to call this method.
         2. You can get information from the notification before presenting it.
         - Identifier
         - userInfo dictionary
         
         3. Call completion handler with .alert .sound .badge
         - If you call with nothing, you supress the notification
         */
        
        // Allowing banners to show up in the app.
        completionHandler([.alert, .sound])
    }
    
    
    // Called after the user interacted with the notification
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        /*
         1. Called when the user interacts with the notification
         2. The response has
         - The notification (.notification)
         - The action triggered (.actionIdentifier)
         - UNNotificationDefaultActionIdentifier
         - UNNotificationDismissActionIdentifier
         - Custom action identifier
         */
        
        let notificationContent = response.notification.request.content
        
        let actionIdentifier = response.actionIdentifier
        
        print("[LOG] Notification '\(notificationContent.categoryIdentifier)' with action '\(actionIdentifier)'")
        
        switch notificationContent.categoryIdentifier {
        case NotificationCategoryIdentifier.reminder:
            
            self.handleReminderAction(actionIdentifier, notificationContent)
            
        case NotificationCategoryIdentifier.pills:
            
            
            self.handlePillReminderAction(actionIdentifier, notificationContent)
            
        default:
            
            print("[LOG] Unknown notification category: '\(notificationContent.categoryIdentifier)'")
        }
        
        completionHandler()
    }
    
    func handleReminderAction(_ actionIdentifier: String, _ notificationContent: UNNotificationContent) {
        
        let oldReminder = Reminder(
            title: (notificationContent.userInfo["title"] as! String)
            , dateTime: (notificationContent.userInfo["dateTimeRem"] as! String)
            , adress: (notificationContent.userInfo["adress"] as! String)
            , icon: (notificationContent.userInfo["icon"] as! String)
            , category: (notificationContent.userInfo["category"] as! String)
            , note: (notificationContent.userInfo["note"] as! String)
        )
        let oldDate = getDateObj(dateString: oldReminder.dateTime)
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: 60, to: oldDate)
        let thisReminder = Reminder(title: oldReminder.title , dateTime: getDateString(dateObj: newDate!), adress: oldReminder.adress, icon: "dds", category: "ddd", note: oldReminder.note)
        
        switch actionIdentifier {
            
        case "answer1":
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        case "answer2" :
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            
            
            APIManager.shared.deleteReminder(oldReminder)
            APIManager.shared.createReminder(reminder: thisReminder)
            
            
        default:
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            let alert = UIAlertController(title: oldReminder.title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK, thanks", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Snooze", style: UIAlertActionStyle.default, handler: { (action) in
                APIManager.shared.deleteReminder(oldReminder)
                APIManager.shared.createReminder(reminder: thisReminder)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "foreground"), object: nil)
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)            
        }
    }
    
    func handlePillReminderAction(_ actionIdentifier: String, _ notificationContent: UNNotificationContent) {
        
        let oldReminder = PillReminder(
            title: (notificationContent.userInfo["title"] as! String)
            , time: (notificationContent.userInfo["time"] as! String)
            , dosage: (notificationContent.userInfo["dosage"] as! String)
            , icon: (notificationContent.userInfo["icon"] as! String)
            , category: (notificationContent.userInfo["category"] as! String)
            , note: (notificationContent.userInfo["note"] as! String)
        )
        
        
        let oldDate = getTimeObj(dateString: oldReminder.time)
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: 60, to: oldDate)
        let thisReminder = PillReminder(title: oldReminder.title , time: getTimeString(dateObj: newDate!), dosage: oldReminder.dosage, icon: "dds", category: "ddd", note: oldReminder.note)
        
        switch actionIdentifier {
            
        case "answer1":
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        case "answer2" :
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            APIManager.shared.deletePillReminder(oldReminder)
            APIManager.shared.createPillReminder(reminder: thisReminder)
            
        default:
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            let alert = UIAlertController(title: oldReminder.title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK, thanks", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Snooze", style: UIAlertActionStyle.default, handler: { (action) in
                APIManager.shared.deletePillReminder(oldReminder)
                APIManager.shared.createPillReminder(reminder: thisReminder)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "foreground"), object: nil)
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}

// - MARK: Managing Notifications
extension NotificationCenterManager {
    
    // Providing access to the application Notification Center
    private var notificationCenter: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
    func requestAuthorizationForNotifications() {
        // Request authorization.
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                fatalError("failed to get authorization for notifications with \(error)")
            }
        }
    }
    
    // Get all the current scheduled notifications
    func getAllNotifications(completionHandler: @escaping ([UNNotificationRequest]) -> Void) {
        self.notificationCenter.getPendingNotificationRequests { notificationRequests in
            print("[LOG] Got \(notificationRequests.count) notifications.")
            completionHandler(notificationRequests)
        }
    }
    
    // Remove a schedule notification
    func removeNotification(with identifier: String) {
        self.notificationCenter
            .removePendingNotificationRequests(withIdentifiers: [identifier])
        print("[LOG] Removed notification '\(identifier)'")
    }
    
    // Clear the notification history and all the schedule notifications
    func removeAllNotifications() {
        // 1.
        self.notificationCenter
            .removeAllDeliveredNotifications()
        // 2.
        self.notificationCenter
            .removeAllPendingNotificationRequests()
    }
    
    // Re-schedule a notification
    func rescheduleNotification(with identifier: String, to date: Date) {
        // 1. Get a copy of the notification
        // 2. Remove the notification
        // 3. Modify the notification copy
        // 4. Add the notification copy
    }
    
    private func scheduleNotification(requestIdentifier: String, content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content,
                                            trigger: trigger )
        
        self.notificationCenter.add(request) { (error) in
            if let error = error {
                print("[LOG] Not possible to schedule the notification due to error: \(error.localizedDescription)")
            } else {
                print("[LOG] Notification \(requestIdentifier) schedule successfully")
            }
        }
    }
}

// - MARK: Custom API
extension NotificationCenterManager {
    
    func createReminderNotificationWith(notificationContent: ReminderNotificationContent) {
        
        let content = UNMutableNotificationContent()
        
        // 1. Set up th notification content
        
        content.title = notificationContent.title
        
        content.body = notificationContent.bodyText
        
        content.userInfo = notificationContent.info
        
        content.categoryIdentifier = notificationContent.categoryIdentifier
        
        let dateTime = notificationContent.info["dateTimeRem"]
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        // Default properties
        
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        var dateCompo = DateComponents()
        
        if let dateTimeFromInfo = dateFormatter.date(from: dateTime!) {
            dateCompo.day = Calendar.current.component(.day, from: dateTimeFromInfo)
            dateCompo.month = Calendar.current.component(.month, from: dateTimeFromInfo)
            dateCompo.year = Calendar.current.component(.year, from: dateTimeFromInfo)
            dateCompo.hour = Calendar.current.component(.hour, from: dateTimeFromInfo)
            dateCompo.minute = Calendar.current.component(.minute, from: dateTimeFromInfo)
            
            //            print (Calendar.current.component(.minute, from: dateTimeFromInfo))
            
        } else {
            
            debugPrint("Found nil")
            
        }
        
        // 2. Get the trigger
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateCompo, repeats: notificationContent.repeating)
        
        // 3. Schedule the notification
        self.scheduleNotification(requestIdentifier: notificationContent.requestUniqueIdentifier,
                                  content: content,
                                  trigger: trigger)
        
    }
    
    func createPillReminderNotificationWith(notificationContent: ReminderNotificationPills) {
        
        let content = UNMutableNotificationContent()
        
        // 1. Set up th notification content
        
        content.title = notificationContent.title
        
        content.body = notificationContent.bodyText
        
        content.userInfo = notificationContent.info
        
        content.categoryIdentifier = notificationContent.categoryIdentifier
        
        let dateTime = notificationContent.info["time"]
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        
        // Default properties
        
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        var dateCompo = DateComponents()
        
        if let dateTimeFromInfo = dateFormatter.date(from: dateTime!) {
            dateCompo.hour = Calendar.current.component(.hour, from: dateTimeFromInfo)
            dateCompo.minute = Calendar.current.component(.minute, from: dateTimeFromInfo)
            
            //            print (Calendar.current.component(.minute, from: dateTimeFromInfo))
            
        } else {
            
            debugPrint("Found nil")
            
        }
        
        // 2. Get the trigger
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateCompo, repeats: notificationContent.repeating)
        
        // 3. Schedule the notification
        self.scheduleNotification(requestIdentifier: notificationContent.requestUniqueIdentifier,
                                  content: content,
                                  trigger: trigger)
        
    }
    
    
    func getDateObj(dateString: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        var dateCompo = DateComponents()
        
        if let dateTimeFromInfo = dateFormatter.date(from: dateString) {
            
            dateCompo.day = Calendar.current.component(.day, from: dateTimeFromInfo)
            dateCompo.month = Calendar.current.component(.month, from: dateTimeFromInfo)
            dateCompo.year = Calendar.current.component(.year, from: dateTimeFromInfo)
            dateCompo.hour = Calendar.current.component(.hour, from: dateTimeFromInfo)
            dateCompo.minute = Calendar.current.component(.minute, from: dateTimeFromInfo)
            
        }
        
        let calendar = Calendar.current
        let datee = calendar.date(from: dateCompo)
        return datee!
    }
    
    func getTimeObj(dateString: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var dateCompo = DateComponents()
        
        if let dateTimeFromInfo = dateFormatter.date(from: dateString) {
            
            dateCompo.hour = Calendar.current.component(.hour, from: dateTimeFromInfo)
            dateCompo.minute = Calendar.current.component(.minute, from: dateTimeFromInfo)
            
        }
        
        let calendar = Calendar.current
        let datee = calendar.date(from: dateCompo)
        return datee!
    }
    
    
    func getDateString(dateObj: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let finalString = formatter.string(from: dateObj)
        return finalString
    }
    
    func getTimeString(dateObj: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        let finalString = formatter.string(from: dateObj)
        return finalString
    }
    
}



