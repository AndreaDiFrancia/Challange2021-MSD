//
//  Category.swift
//  My Health
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var title: String
    var arrayVisits: [String]
    var icon: String
    
    init(title: String,arrayVisits: [String],icon: String) {
        self.title = title
        self.icon = icon
        self.arrayVisits = arrayVisits
    }
}


