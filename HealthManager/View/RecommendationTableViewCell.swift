//
//  RecommendationTableViewCell.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class RecommendationTableViewCell: FoldingCell {
    @IBOutlet weak var titleMain: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoDescription: UILabel!
    
    @IBOutlet weak var lastVisitLAbel: UILabel!
    @IBOutlet weak var dataPickerOutlet: UIDatePicker!
    @IBAction func dataPickerValueChanged(_ sender: UIDatePicker) {
        
        
        
            let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myString = formatter.string(from: dataPickerOutlet.date)
                    let yourDate = formatter.date(from: myString)
                    formatter.dateFormat = "dd-MMM-yyyy"
                    let myStringafd = formatter.string(from: yourDate!)
            
                    lastVisitLAbel.text = "\(myStringafd)"
        
        
        do {
        for key in DataManager.shared.globalVar {
            if  key.value(forKey: "age") as? Int16 == DataManager.shared.ageFetched && key.value(forKey: "title") as? String == DataManager.shared.titleFetched {
            
            key.setValue(dataPickerOutlet.date, forKey: "visit")
            try PersistenceService.context.save()
            } else {
                print("Cannot save")
            }
            }
            print("Saved")
//            print(DataManager.shared.globalVar)
          
        } catch {
            debugPrint("Cannot change date")
            
        }
        
    }
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sideView: UIView!
    @IBAction func saveRecom(_ sender: UIButton) {
        if DataManager.shared.changingDataInCoreData() == true {
            saveButton.backgroundColor = UIColor(red:0.28, green:0.90, blue:0.74, alpha:1.0)
            sideView.backgroundColor = UIColor(red:0.28, green:0.90, blue:0.74, alpha:1.0)
            titleView.backgroundColor = UIColor(red:0.28, green:0.90, blue:0.74, alpha:1.0)
            saveButton.setTitle("Done", for: .normal)
//            //            icon should  change and allert should appear
//            let alert = UIAlertController(title: "Recommendation Saved", message: "\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
            
//        } else {
////            let alert = UIAlertController(title: "Recommendation not saved", message: "\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
////            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
////                alert.dismiss(animated: true, completion: nil)
////            }))
////            self.present(alert, animated: true, completion: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 18
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.18
        self.layer.shadowRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        dataPickerOutlet.date = NSDate() as Date
//        dataPickerOutlet.isHidden = true
        dataPickerOutlet.datePickerMode = .date
        
        
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}

