//
//  Recomendations.swift
//  My Health
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//


import Foundation
import UIKit

class Recomendation {
    
    var title: String
    var age: Int
    var gender: String
    var description: String
    var check: Bool
    var category: String
    
    init(title: String,age: Int,gender: String,description: String,check: Bool,category: String) {
        
        self.title = title
        self.age = age
        self.gender = gender
        self.description = description
        self.check = check
        self.category = category
    }
    
    public func printRecom (){
        print(age)
        print(title)
        print(gender)
        print(description)
        print(check)
        print(category)
    }
}


var recomendationsList = [
    
    Recomendation(title: "Prostate Check", age: 40, gender: "M", description: "bla bla", check: false, category: "bla bla"),
    Recomendation(title: "Breast Check", age: 40, gender: "F", description: "bla bla", check: false, category: ""),
    Recomendation(title: "Chervix Check", age: 40, gender: "F", description: "bla bla", check: false, category: "")
    
]



