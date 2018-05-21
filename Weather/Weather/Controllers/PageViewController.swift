//
//  PageViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/16/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PageViewController: UIPageViewController {
    
    var modelCity = CityModel()
    var controllers = [WeatherController]()
    let locationManager = CLLocationManager()
 
    var pages: [WeatherController] {
        get {
            if controllers.count + 1 == modelCity.arrayCity.count {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController
                    else { return controllers }
                controller.type = modelCity.arrayCity.last!
                controller.delegate = self
                controllers.append(controller)
                return controllers
            }
            return controllers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocation()
        dataSource = self
    }
    
    fileprivate func updateLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func loadData() {
            for i in 0..<modelCity.arrayCity.count {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController else { break }
                controller.type = modelCity.arrayCity[i]
                controller.delegate = self
                controllers.append(controller)
            }
        guard let firstVC = self.pages.first else { return }
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
}

 //MARK: UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! WeatherController) else { return nil }
      
        if viewControllerIndex - 1 < 0  {
            return nil
        }
        return pages[viewControllerIndex - 1]
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! WeatherController) else { return nil }
    
        if viewControllerIndex + 1 >= controllers.count {
            return nil
        }
        return controllers[viewControllerIndex + 1]
    }
}

extension PageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = String(locValue.latitude)
        let longitude = String(locValue.longitude)
        
        modelCity.arrayCity.append(.location(latitude: latitude, longitude: longitude))
        modelCity.arrayCity.append(.location(latitude: latitude, longitude: longitude))//FIXME
        
        loadData()
        
    }
}







