//
//  NotificationsViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var notificationsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationsButton.layer.cornerRadius = min(notificationsButton.bounds.size.height, notificationsButton.bounds.size.width) / 2
        notificationsButton.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            let gender = try HealthManager.shared.getBiologicalSex()
            DataManager.shared.user?.gender = gender == .male ? .male : .female
            let components = try HealthManager.shared.getBirthday()
            if let birthday = components.date {
                DataManager.shared.user?.birthDay = birthday
            }
            DataManager.shared.storeUserData()
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        HealthManager.shared.getUserHeight { (height) in
            DataManager.shared.user?.height = Float(Int(height))
            DataManager.shared.storeUserData()
        }
        
        HealthManager.shared.getUserWeight { (weight) in
            DataManager.shared.user?.weight = Float(Int(weight))
            DataManager.shared.storeUserData()

        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func allowNotificationsAction(_ sender: UIButton) {
        // Request authorization to display notifications
        NotificationCenterManager.shared.requestAuthorizationForNotifications()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "subscribeNotif"), object: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
