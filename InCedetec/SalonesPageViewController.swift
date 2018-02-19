//
//  SalonesPageViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 19/02/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit

class SalonesPageViewController: UIPageViewController, UIPageViewControllerDataSource {


    lazy var viewControllerList: [UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: "salon1")
        let vc2 = sb.instantiateViewController(withIdentifier: "salon2")
        let vc3 = sb.instantiateViewController(withIdentifier: "salon3")
        
        return [vc1,vc2,vc3]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        if let firstViewController = viewControllerList.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else{return nil}
        return viewControllerList[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else {return nil}
        guard viewControllerList.count > nextIndex else {return nil}
        return viewControllerList[nextIndex]
        
        
    }

}
