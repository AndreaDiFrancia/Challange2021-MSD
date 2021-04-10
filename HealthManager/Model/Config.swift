//
//  Config.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import Foundation
import UIKit

enum CategoryType: Int {
    case bloodtest = 0, cardiology, dentistry, dermatology, gastroenterology, general, neurology, ophtalmology, pulmonology
}

struct Config {
    static let category: [CategoryType] = [.bloodtest, .cardiology, .dentistry, .dermatology, .gastroenterology, .general, .neurology, .ophtalmology, .pulmonology]
    
    static func getCategoryNameFrom(type: CategoryType) -> String {
        switch type {
        case .bloodtest: return "Blood Test"
        case .cardiology: return "Cardiology"
        case .dentistry: return "Dentistry"
        case .dermatology: return "Dermatology"
        case .gastroenterology: return  "Gastroenterology"
        case .general: return "General"
        case .neurology: return "Neurology"
        case .ophtalmology: return "Ophtalmology"
        case .pulmonology: return "Pulmonology"
        }
    }
    
}
