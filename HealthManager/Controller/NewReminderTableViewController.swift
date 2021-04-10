
//
//  NewReminderTableViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class NewReminderTableViewController: UITableViewController ,UITextFieldDelegate,UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    
    @IBOutlet weak var adressOutlet: UITextField!
    
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var noteLabel: UITextField!
    
 
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var pikerViewCategory: UIPickerView!
    
    
    var num = 0

    var myStringafd: String = ""
    
    @IBAction func lastVisitPicker(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        myStringafd = formatter.string(from: sender.date)
        dateLabel.text = "\(myStringafd)"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Config.category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Config.getCategoryNameFrom(type: Config.category[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        num = row
        lblCategory.text = Config.getCategoryNameFrom(type: Config.category[row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerOutlet.date = NSDate() as Date
        datePickerOutlet.isHidden = true
        datePickerOutlet.datePickerMode = .dateAndTime
        datePickerOutlet.timeZone = TimeZone.current
        
        datePickerOutlet.minimumDate = Date()
        
        titleLabel.text = ""
        adressOutlet.text = ""
        
        titleLabel.delegate = self
        adressOutlet.delegate = self
        noteLabel.delegate = self
        
        pikerViewCategory.dataSource = self
        pikerViewCategory.delegate = self
        pikerViewCategory.isHidden = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func appDelegate () -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    @IBAction func createReminder(_ sender: Any) {
        if myStringafd != "" && titleLabel.text != "" {
            var categ = ""
            
            if let x = lblCategory.text {
                categ = x
            }
            
            let thisReminder = Reminder(title: titleLabel.text!, dateTime: myStringafd, adress: adressOutlet.text!, icon: "dds", category: categ, note: noteLabel.text!)
            
            APIManager.shared.createReminder(reminder: thisReminder)
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 4 {
            let height:CGFloat = datePickerOutlet.isHidden ? 0.0 : 216.0
            return height
        }
        
        if indexPath.section == 0 && indexPath.row == 6 {
            let height:CGFloat = pikerViewCategory.isHidden ? 0.0 : 200.0
            return height
        }
        
        return super.tableView.rowHeight
    }
    
    
    override func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datePickerIndexPath = NSIndexPath(row: 3, section: 0)
        
        if datePickerIndexPath as IndexPath == indexPath {
            
            datePickerOutlet.isHidden = !datePickerOutlet.isHidden
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            } )
            
        } else {
            
            self.tableView.beginUpdates()
            datePickerOutlet.isHidden = true
            self.tableView.endUpdates()
            
        }
        let categoryPickerIndexPath = NSIndexPath(row: 5, section: 0)
        if categoryPickerIndexPath as IndexPath == indexPath {
            pikerViewCategory.isHidden = !pikerViewCategory.isHidden
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        } else {
            self.tableView.beginUpdates()
            pikerViewCategory.isHidden = true
            self.tableView.endUpdates()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}



