//
//  Reminder.swift
//  My Health
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Reminder {
    
    var title: String
    var dateTime: String
    var adress: String
    var icon : String
    var category: String
    var note: String
    
    init(title: String, dateTime: String, adress: String, icon : String,category: String, note: String){
        self.title = title
        self.dateTime = dateTime
        self.adress = adress
        self.icon = icon
        self.category = category
        self.note = note
    }
}



