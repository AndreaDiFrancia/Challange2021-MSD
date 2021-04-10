//
//  OnboardingPageViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    var pageControl = UIPageControl()
    var viewControllersArray: [UIViewController] = {
        return [UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController"),
                UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "HealthViewController"),
                UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController"),
                UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "EndViewController"),
                ]}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.6549019608, green: 0.831372549, blue: 0.9058823529, alpha: 1)
        dataSource = self
        delegate = self
        
        if let firstViewController = viewControllersArray.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        configurePageControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = viewControllersArray.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersArray.index(of: viewController) else { return nil }
        guard index > 0 else { return nil }
        return viewControllersArray[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersArray.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard viewControllersArray.count != nextIndex else { return nil }
        guard viewControllersArray.count > nextIndex else { return nil }
        return viewControllersArray[nextIndex]
    }
    
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllersArray.index(of: pageContentViewController)!
    }
    
}
