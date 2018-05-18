//
//  PageViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/16/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var arrayCity: [String] = ["London", "Milano"]
    var controllers: [ViewController] = []
  
    var pages: [ViewController] {
        get {
            print(arrayCity)
            print(controllers.count)
            print(arrayCity.count)
            
            if controllers.count == arrayCity.count {
                    return controllers
            } else if controllers.count + 1 == arrayCity.count {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? ViewController
                    else { return controllers }
                
                    controller.nameCity = arrayCity.last!//TO DO
                    controller.delegate = self
                    controllers.append(controller)
                
                    return controllers
           }
            return controllers
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        for i in 0..<arrayCity.count {
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? ViewController else { return }
            controller.nameCity = arrayCity[i]
            controller.delegate = self
            controllers.append(controller)
        }
        guard let firstVC = self.pages.first else { return }
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
}

// MARK: UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! ViewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0          else { return pages.last }
        guard pages.count > previousIndex else { return nil        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! ViewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil         }
        return pages[nextIndex]
    }
}












