//
//  User.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class User: NSObject, Codable {
    
    var name: String
    var gender: GenderType
    var birthDay: Date
    var height: Float
    var weight: Float
    var bmi: Float?
    
    init(name: String, gender: GenderType, birthDay: Date, height: Float, weight: Float) {
        self.name = name
        self.gender = gender
        self.birthDay = birthDay
        self.height = height
        self.weight = weight
    }
    
}

enum GenderType: String, Codable {
    case male = "Male", female = "Female"
}
