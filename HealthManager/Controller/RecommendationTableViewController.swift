//
//  RecommendationTableViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class RecommendationsTableViewController: UITableViewController{
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 528
        static var rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    var exampleArray:[FilteredRecommendation] = []
    var arrayGeneral: [FilteredRecommendation] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       number = arrayGeneral.count
        self.navigationItem.title = "Recommendations"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        do {
            exampleArray = try DataManager.shared.fetchRecomFromCoreData()
            if exampleArray.isEmpty
            {
                for item in DataManager.shared.readRecommendations() {
                    arrayGeneral.append(item)
                }
            } else {
                for item in exampleArray {
                    arrayGeneral.append(item)
                }
            }
            print(arrayGeneral.count)
            DataManager.shared.deletingArray = arrayGeneral
            DataManager.shared.globalVar = arrayGeneral
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        
        
        setup()
        

    }
    
    private func setup() {
        var number = arrayGeneral.count
        print(number)
        cellHeights = Array(repeating: Const.closeCellHeight, count: number)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayGeneral.count
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as RecommendationTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        //        cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! RecommendationTableViewCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
       
        let x = arrayGeneral[indexPath.row]
         cell.titleLabel.text = x.title
        cell.categoryLabel.text = x.category
        cell.infoDescription.text = x.descriptionR
        cell.titleMain.text = x.title
        
        cell.sideView.backgroundColor = UIColor(red:0.58, green:0.73, blue:0.80, alpha:1.0)
        cell.titleView.backgroundColor = UIColor(red:0.58, green:0.73, blue:0.80, alpha:1.0)
        cell.saveButton.backgroundColor = UIColor(red:0.58, green:0.73, blue:0.80, alpha:1.0)
        
        

        
        
         DataManager.shared.checkedFetched = arrayGeneral[indexPath.row].check
        if DataManager.shared.checkedFetched! == true as Bool  {
            cell.saveButton.backgroundColor = UIColor(red:0.28, green:0.90, blue:0.74, alpha:1.0)
            cell.sideView.backgroundColor = UIColor(red:0.28, green:0.90, blue:0.74, alpha:1.0)
            cell.titleView.backgroundColor = UIColor(red:0.28, green:0.90, blue:0.74, alpha:1.0)
            cell.saveButton.setTitle("Done", for: .normal)
            
            
        }
        
        
       
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let _thingToDelete_ = self.arrayGeneral[indexPath.row]
                PersistenceService.context.delete(_thingToDelete_)
                try PersistenceService.context.save()
                print ("Deleted")
            }
            catch {
                print("Fail")
            }
            self.arrayGeneral.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! RecommendationTableViewCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
        DataManager.shared.ageFetched = Int16(arrayGeneral[indexPath.row].age)
        DataManager.shared.titleFetched = arrayGeneral[indexPath.row].title
        DataManager.shared.descriptionFetched = arrayGeneral[indexPath.row].descriptionR
        DataManager.shared.categoryFetched = arrayGeneral[indexPath.row].category
        DataManager.shared.visitFetched = arrayGeneral[indexPath.row].visit
        
        if DataManager.shared.visitFetched != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: DataManager.shared.visitFetched!)
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "dd-MMM-yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            
            cell.lastVisitLAbel.text = "\(myStringafd)"
            
        } else {
            cell.lastVisitLAbel.text = "Set your visit date"
        }
        
       
    }
    
}

