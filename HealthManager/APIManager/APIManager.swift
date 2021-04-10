//
//  APIManager.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import Foundation
import UserNotifications

class APIManager {
    
    static let shared: APIManager = APIManager()
    
    func createPillReminder(reminder: PillReminder) {
        // 1. Create the notification unique identifier
        
        let notificationIdentifier = "\(reminder.title)\(reminder.time)"
        
        // 2. Set up the content of the notification with a custom structure
        
        let notificationSettings =
            ReminderNotificationPills( title: "Pill Reminder",
                                         bodyText: "It is time for \(reminder.title).",
                requestUniqueIdentifier: notificationIdentifier,
                info: ["title": reminder.title ,"dosage": reminder.dosage ,"category": reminder.category ,"icon": reminder.icon, "time": reminder.time , "note": reminder.note] )
        
        // 3. Create a Reminder notification
        NotificationCenterManager.shared
            .createPillReminderNotificationWith(notificationContent: notificationSettings)
    }
    
    
    
    func createReminder(reminder: Reminder) {
        // 1. Create the notification unique identifier
        
        let notificationIdentifier = "\(reminder.title)\(reminder.dateTime)"
        
        // 2. Set up the content of the notification with a custom structure
        
        let notificationSettings =
            ReminderNotificationContent( title: "Next appointment",
                                         bodyText: "It is time for \(reminder.title).",
                
                requestUniqueIdentifier: notificationIdentifier,
                
                info: ["title": reminder.title ,"adress": reminder.adress ,"category": reminder.category ,"icon": reminder.icon, "dateTimeRem": reminder.dateTime , "note": reminder.note] )
        
        
        // 3. Create a Reminder notification
        NotificationCenterManager.shared
            .createReminderNotificationWith(notificationContent: notificationSettings)
    }
    
    
    func getAllPillReminders(completionHandler: @escaping ([PillReminder]) -> Void) {
        
        // 1. Get all the notifications
        //  The completion handler is how you give the information back
        //  because the .getAllNotifications method is asyncronous.
        NotificationCenterManager.shared.getAllNotifications { (notificationRequests) in
            // 2. An array with a custom type CoffeeReminder
            
            var pillReminders: [PillReminder] = []
            // 3. Filter all the notification with the Reminder category identifier
            
            for notification in notificationRequests {
                if notification.content.categoryIdentifier == NotificationCategoryIdentifier.pills {
                    
                    let title = notification.content.userInfo["title"] as? String ?? ""
                    let dosage = notification.content.userInfo["dosage"] as? String ?? ""
                    let icon = notification.content.userInfo["icon"] as? String ?? ""
                    let category = notification.content.userInfo["category"] as? String ?? ""
                    let time = notification.content.userInfo["time"] as? String ?? ""
                    let note = notification.content.userInfo["note"] as? String ?? ""
                    let trigger = notification.trigger as! UNCalendarNotificationTrigger
                    
                    // 4. Creates a CoffeeReminder object
                    
                    let pillReminder = PillReminder(title: title, time: time ,dosage: dosage, icon: icon, category: category, note: note)
                    // 5. Append it to the array we are going to return at the end
                    pillReminders.append(pillReminder)
                    
                }
                
                // 6. Return the array with all the Reminder notifications
                completionHandler(pillReminders)
            }
        }
    }
    
    func getAllReminders(completionHandler: @escaping ([Reminder]) -> Void) {
        
        // 1. Get all the notifications
        //  The completion handler is how you give the information back
        //  because the .getAllNotifications method is asyncronous.
        NotificationCenterManager.shared.getAllNotifications { (notificationRequests) in
            
            // 2. An array with a custom type CoffeeReminder
            var reminders: [Reminder] = []
            // 3. Filter all the notification with the Reminder category identifier
            
            for notification in notificationRequests {
                if notification.content.categoryIdentifier == NotificationCategoryIdentifier.reminder {
                    
                let title = notification.content.userInfo["title"] as? String ?? ""
                let adress = notification.content.userInfo["adress"] as? String ?? ""
                let icon = notification.content.userInfo["icon"] as? String ?? ""
                let category = notification.content.userInfo["category"] as? String ?? ""
                let time = notification.content.userInfo["dateTimeRem"] as? String ?? ""
                let note = notification.content.userInfo["note"] as? String ?? ""
                let trigger = notification.trigger as! UNCalendarNotificationTrigger
                // 4. Creates a CoffeeReminder object
                
                let reminder = Reminder(title: title, dateTime: time ,adress: adress, icon: icon, category: category, note: note)
                // 5. Append it to the array we are going to return at the end
                reminders.append(reminder)
                }
                
            // 6. Return the array with all the Reminder notifications
            completionHandler(reminders)
        }
    }
}
    
    func deletePillReminder(_ reminder: PillReminder) {
        let notificationIdentifier = "\(reminder.title)\(reminder.time)"
        NotificationCenterManager.shared.removeNotification(with: notificationIdentifier)
    }
    
    func deleteReminder(_ reminder: Reminder) {
        let notificationIdentifier = "\(reminder.title)\(reminder.dateTime)"
        NotificationCenterManager.shared.removeNotification(with: notificationIdentifier)
    }
}


