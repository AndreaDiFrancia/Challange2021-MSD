//
//  PillReminder.swift
//  My Health
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PillReminder {
    
    var title: String
    var time: String
    var dosage: String
    var icon : String
    var category: String
    var note: String
    
    init(title: String, time: String, dosage: String, icon : String,category: String, note: String){
        self.title = title
        self.time = time
        self.dosage = dosage
        self.icon = icon
        self.category = category
        self.note = note
    }
}




