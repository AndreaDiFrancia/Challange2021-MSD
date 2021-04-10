//
//  ProfileTableViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    var headerView: UIView!
    private let kTableHeaderHeight: CGFloat = UIScreen.main.bounds.height/3 - 16
    private let heightsArray: [Int] = (100...250).map { Int($0) }
    private let weightsArray: [Int] = (1...200).map { Int($0) }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setHeaderView()
        let formatter = DateFormatter()
        formatter.dateStyle = .short

        if let user = DataManager.shared.user {
            avatarImageView.image = user.gender == .male ? #imageLiteral(resourceName: "MaleAvatar") : #imageLiteral(resourceName: "FemaleAvatar")
            headerTitleLabel.text = user.name
            genderLabel.text = user.gender.rawValue
            birthdayLabel.text = formatter.string(from: user.birthDay)
            heightLabel.text = "\(user.height) cm"
            weightLabel.text = "\(user.weight) kg"
        } else {
            headerTitleLabel.text = "User"
            genderLabel.text = "-"
            birthdayLabel.text = "-"
            heightLabel.text = "-"
            weightLabel.text = "-"
        }
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.isHidden = true
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        heightPickerView.isHidden = true
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        weightPickerView.isHidden = true
        
        birthdayDatePicker.date = NSDate() as Date
        birthdayDatePicker.isHidden = true
        
        if let user = DataManager.shared.user {
            let index = user.gender == .male ? 0 : 1
            genderPickerView.selectRow(index, inComponent: 0, animated: false)
        }
        if let user = DataManager.shared.user, let index = heightsArray.index(of: Int(user.height)) {
            heightPickerView.selectRow(index, inComponent: 0, animated: false)
        }
        if let user = DataManager.shared.user, let index = weightsArray.index(of: Int(user.weight)) {
            weightPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findHairline()?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        findHairline()?.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Header view methods
    
    private func findHairline() -> UIImageView? {
        return navigationController?.navigationBar.subviews
            .flatMap { $0.subviews }
            .compactMap { $0 as? UIImageView }
            .filter { $0.bounds.size.width == self.navigationController?.navigationBar.bounds.size.width }
            .filter { $0.bounds.size.height <= 2 }
            .first
    }
    
    private func setHeaderView() {
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    private func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    // MARK: - Actions
    
    @IBAction func birthdayDateChanged(_ sender: UIDatePicker) {
        if let user = DataManager.shared.user {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            user.birthDay = sender.date
            birthdayLabel.text = formatter.string(from: user.birthDay)
            DataManager.shared.storeUserData()
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            return genderPickerView.isHidden ? 0.0 : 122.0
        } else if indexPath.section == 0 && indexPath.row == 3 {
            return birthdayDatePicker.isHidden ? 0.0 : 184.0
        } else if indexPath.section == 0 && indexPath.row == 5 {
            return heightPickerView.isHidden ? 0.0 : 122.0
        } else if indexPath.section == 0 && indexPath.row == 7 {
            return weightPickerView.isHidden ? 0.0 : 122.0
        }
        return 46.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 8 {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }
        if indexPath.section == 0 && indexPath.row == 0 {
            genderPickerView.isHidden = !genderPickerView.isHidden
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        } else {
            self.tableView.beginUpdates()
            genderPickerView.isHidden = true
            self.tableView.endUpdates()
            
        }
        if indexPath.section == 0 && indexPath.row == 2 {
            birthdayDatePicker.isHidden = !birthdayDatePicker.isHidden
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        } else {
            self.tableView.beginUpdates()
            birthdayDatePicker.isHidden = true
            self.tableView.endUpdates()
        }
        if indexPath.section == 0 && indexPath.row == 4 {
            heightPickerView.isHidden = !heightPickerView.isHidden
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        } else {
            self.tableView.beginUpdates()
            heightPickerView.isHidden = true
            self.tableView.endUpdates()
        }
        if indexPath.section == 0 && indexPath.row == 6 {
            weightPickerView.isHidden = !weightPickerView.isHidden
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        } else {
            self.tableView.beginUpdates()
            weightPickerView.isHidden = true
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - Scroll view delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 0 ? "" : ""
    }
    
}


extension ProfileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == genderPickerView ? 2 : pickerView == heightPickerView ? heightsArray.count : weightsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerView {
            return row == 0 ? "Male" : "Female"
        } else if pickerView == heightPickerView {
            let pickerViewValues: [String] = heightsArray.map { Int($0).description }
            return pickerViewValues[row]+".0"
        } else {
            let pickerViewValues: [String] = weightsArray.map { Int($0).description }
            return pickerViewValues[row]+".0"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPickerView {
            if let user = DataManager.shared.user {
                user.gender = row == 0 ? .male : .female
                avatarImageView.image = user.gender == .male ? #imageLiteral(resourceName: "MaleAvatar") : #imageLiteral(resourceName: "FemaleAvatar")
                genderLabel.text = user.gender.rawValue
                DataManager.shared.storeUserData()
            }
        } else if pickerView == heightPickerView {
            if let user = DataManager.shared.user {
                user.height = Float(heightsArray[row])
                heightLabel.text = "\(user.height) cm"
                DataManager.shared.storeUserData()
            }
        } else {
            if let user = DataManager.shared.user {
                user.weight = Float(weightsArray[row])
                weightLabel.text = "\(user.weight) kg"
                DataManager.shared.storeUserData()
            }
        }
    }
    
}
