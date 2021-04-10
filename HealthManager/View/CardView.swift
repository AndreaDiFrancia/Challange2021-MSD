//
//  CardView.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class CardView: UIView {

    override func awakeFromNib() {
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.18
        self.layer.shadowRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

}
