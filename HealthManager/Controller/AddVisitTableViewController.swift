//
//  AddVisitTableViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit
import CoreData
import PDFKit

class AddVisitTableViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! VisitCollectionViewCell
        cell.imageVisit.image =  DataManager.shared.arrayImage[indexPath.row]
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datePickerIndexPath = NSIndexPath(row: 1, section: 0)
        if datePickerIndexPath as IndexPath == indexPath {
            pickerOutlet.isHidden = !pickerOutlet.isHidden
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        } else {
            self.tableView.beginUpdates()
            pickerOutlet.isHidden = true
            self.tableView.endUpdates()
        }
        let categoryPickerIndexPath = NSIndexPath(row: 3, section: 0)
        if categoryPickerIndexPath as IndexPath == indexPath {
            pickerViewCategory.isHidden = !pickerViewCategory.isHidden
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        } else {
            self.tableView.beginUpdates()
            pickerViewCategory.isHidden = true
            self.tableView.endUpdates()
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 2 {
            let height:CGFloat = pickerOutlet.isHidden ? 0.0 : 160.0
            return height
        }
        
        if indexPath.section == 0 && indexPath.row == 4{
            let height:CGFloat = pickerViewCategory.isHidden ? 0.0 : 100.0
            return height
        }
        if indexPath.section == 0 && indexPath.row == 5{
            return 115
        }
        
        
        return super.tableView.rowHeight
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func dismiss(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBOutlet var lblTitle: UITextField!
    @IBOutlet var collectionViewDocument: UICollectionView!
    @IBOutlet var lblData: UITextField!
    @IBOutlet var pickerOutlet: UIDatePicker!
    @IBOutlet var lblCategory: UITextField!
    @IBOutlet var pickerViewCategory: UIPickerView!
    @IBOutlet var descriptionTextView: UITextView!
    var num = 0
    var originalPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewCategory.dataSource = self
        pickerViewCategory.delegate = self
        descriptionTextView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        title = "New Document"
        let rightUIBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveDocument))
        self.navigationItem.rightBarButtonItem = rightUIBarButtonItem
        
        //Add Data in a cell
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: now)
        print(dateString)
        lblData.text = dateString

        pickerOutlet.date = NSDate() as Date
        pickerOutlet.isHidden = true
        pickerOutlet.datePickerMode = .date
        pickerViewCategory.isHidden = true
        
        lblTitle.delegate = self
    }
    
    func appDelegate () -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    @objc func saveDocument() {
        // Data Manager method
        if lblTitle.text == "" {
            let alert = UIAlertController(title: "Attention", message: "you have to insert a title", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if lblCategory.text == ""{
                let alert = UIAlertController(title: "Attention", message: "you have to choose a category", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
          //////////////////Compress and save in memory
                let document = PDFDocument()
                for index in DataManager.shared.arrayImage{
                    guard let cgImage = index.cgImage else { return }
                    let image = UIImage(cgImage: cgImage, scale: index.scale, orientation: .up)
                    let compressImage = UIImageJPEGRepresentation(image, 0.5)
                    let compressedImage = UIImage(data: compressImage!)
                    guard let imagePDF = PDFPage(image: compressedImage!) else { return }
                    document.insert(imagePDF, at: document.pageCount)
                }
                let data = document.dataRepresentation()
                // The url to save the data to
                let fileManager = FileManager.default
                do {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                    let now = Date()
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone.current
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateString = formatter.string(from: now)
                    
                    let fileURL = documentDirectory.appendingPathComponent("HealtMenager-\(lblCategory)-\(dateString).pdf")
                    originalPath = "HealtMenager-\(lblCategory)-\(dateString).pdf"
                    DataManager.shared.pathImage  = fileURL.absoluteString
                    print("Path: \(DataManager.shared.pathImage)")
                    try data?.write(to: fileURL)
                    
                } catch {
                    print(error)
                }
         /////////////////////////////////////////////////////
                
                DataManager.shared.saveNewDocument(title: lblTitle.text!, date: pickerOutlet.date, category:  Config.category[num], notes: descriptionTextView.text, pdfPath: originalPath! )
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func actionPicker(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: pickerOutlet.date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy/MM/dd"
        let myStringafd = formatter.string(from: yourDate!)
        lblData.text = "\(myStringafd)"
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.text == "Note" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if descriptionTextView.text == "" {
            descriptionTextView.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
            descriptionTextView.text = "Note"
        } else {
            descriptionTextView.textColor = UIColor.black
    }
        
        return true
}
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
            return false
        }
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
    
    //Calls this function when the tap is recognized.
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
