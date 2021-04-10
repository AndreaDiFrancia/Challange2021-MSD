//
//  File.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import Foundation

struct ReminderNotificationContent {
    
    // Notification content
    let title: String
    let bodyText: String
    
    // Trigger parameters
    
    let repeating: Bool = false
    
    let categoryIdentifier: String = NotificationCategoryIdentifier.reminder
    
    // Identifiers
    let requestUniqueIdentifier: String
    
    // User information
    var info =  ["title": "","adress": "" ,"category": "" ,"icon": "","dateTimeRem": "" , "note": ""]
    
}

struct ReminderNotificationPills {
    
    let title: String
    
    let bodyText: String
    
    // Trigger parameters
    
    let repeating: Bool = true
    
    let categoryIdentifier: String = NotificationCategoryIdentifier.pills
    
    // Identifiers
    let requestUniqueIdentifier: String
    
    // User information
    
    var info =  ["title": "","dosage": "" ,"category": "" ,"icon": "","time": "" ]
    
    
}



