//
//  DocumentTableViewCell.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
