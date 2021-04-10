//
//  MainTabBarController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: Key.kOnboardingDone) == false {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
            let tutorial = storyboard.instantiateViewController(withIdentifier: "OnboardingPageController") as! OnboardingPageViewController
            present(tutorial, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
