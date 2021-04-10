//
//  HomeCollectionViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

private let reuseIdentifier = "HomeCell"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let sections = ["APPOINTMENTS","PILLS REMINDERS","RECOMMENDATIONS"]
    let covers = ["AppointmentsCover","PillsCover","RecommendationsCover"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.titleLabel.text = sections[indexPath.item]
        cell.iconImageView.image = UIImage(named: covers[indexPath.item])
        cell.iconImageView.clipsToBounds = true
        cell.iconImageView.layer.cornerRadius = 18.0
        cell.iconImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Reminder", bundle: nil)
            let appointmentsController = storyBoard.instantiateViewController(withIdentifier: "appointmentsController")
            self.navigationController?.pushViewController(appointmentsController, animated: true)
        } else if indexPath.item == 1 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "PillsReminder", bundle: nil)
            let pillsController = storyBoard.instantiateViewController(withIdentifier: "pillsController")
            self.navigationController?.pushViewController(pillsController, animated: true)
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Recomendation", bundle: nil)
            let recomendationController = storyBoard.instantiateViewController(withIdentifier: "recomendationController")
            self.navigationController?.pushViewController(recomendationController, animated: true)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.size.width-12)
        return CGSize(width: size, height: size-60)
    }

}
