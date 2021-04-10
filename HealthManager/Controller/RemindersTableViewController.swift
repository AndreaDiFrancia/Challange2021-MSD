//
//  RemindersTableViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class RemindersTableViewController: UITableViewController {
    
    var reminders: [Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenterManager.shared.requestAuthorizationForNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getReminders), name:
            NSNotification.Name(rawValue: "foreground"), object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.getReminders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getReminders()
    }
    
    @objc func getReminders() {
        APIManager.shared.getAllReminders { (reminders) in
            self.reminders = reminders
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "foreground"), object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // Empty State
        if self.reminders.count == 0 {
            return 1
        }
        // Ideal State
        return self.reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Empty State
        if self.reminders.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath);
            
            return cell
        }
        // Ideal State
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderIdentifier", for: indexPath)
        
        let reminder = self.reminders[indexPath.row]
        
        cell.textLabel?.text = reminder.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if self.reminders.count > 0 {
            if editingStyle == .delete {
                
                // Delete the row from the data source
                
                let reminderToDelete = self.reminders[indexPath.row]
                
                APIManager.shared.deleteReminder(reminderToDelete)
                
                self.reminders.remove(at: indexPath.row)
                
                // Empty State
                if self.reminders.count == 0 {
                    self.tableView.reloadData()
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    
    //
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        //        check if the row was selected
    //        let reminder = self.reminders[indexPath.row]
    //
    ////        let rem  = Reminder(title: "breuno", dateTime: "ff", adress: "ffd", icon: "erer", category: "ewwe")
    //
    //        performSegue(withIdentifier: "toDetails", sender: rem)
    //
    //    }
    
    
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
    
    //
    ////     Override to support editing the table view.
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    ////             Delete the row from the data source
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        } else if editingStyle == .insert {
    ////             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //        }
    //    }
    
    
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails", let cell = sender as? UITableViewCell {
            
            let indexPath = self.tableView.indexPath(for: cell)
            
            let reminder = self.reminders[(indexPath?.row)!]
            
            DataManager.shared.reminderSegue = reminder
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}


