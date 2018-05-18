//
//  PageViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/16/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
     var arrayCity = ["London", "Kiev"]
    // var arrayCity = [String]()
    var controllers: [WeatherController] = []
    var model = CityModel()
    
    var pages: [WeatherController] {
        get {
            if controllers.count == arrayCity.count {
                    return controllers
            } else if controllers.count + 1 == arrayCity.count {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController
                    else { return controllers }
                controller.type = TypeInputData.city(name: arrayCity.last!)
                controller.modelCity = self.model
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
        loadData()
        guard let firstVC = self.pages.first else { return }
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    func loadData() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController else { return }
        controller.type = TypeInputData.location()
        controller.delegate = self
        controller.modelCity = self.model
        controllers.append(controller)
        
        if arrayCity.count>0 {
            for _ in 1..<arrayCity.count {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController else { break }
                controller.type = TypeInputData.city(name: arrayCity.last!)
                controller.delegate = self
                controller.modelCity = self.model
                controllers.append(controller)
            }
        }
    }
    
    func updateData(array: [String]) {
        arrayCity = array
    } 
}

 //MARK: UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! WeatherController) else { return nil }
      
        if viewControllerIndex - 1 < 0  {
            return nil
        }
        return pages[viewControllerIndex-1]
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! WeatherController) else { return nil }
    
        if viewControllerIndex+1 >= controllers.count {
            return nil
        }
        return controllers[viewControllerIndex+1]
    }
}










