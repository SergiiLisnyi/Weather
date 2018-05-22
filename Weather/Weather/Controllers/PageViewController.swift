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
    
    var pages: [WeatherController] { // FIXME
        get {
            if controllers.count + 1 == modelCity.arrayCity.count {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController else { return controllers }
                let model = WeatherService()
                getWeather(type: modelCity.arrayCity.last!, model: model)
                controller.model = model
                controller.delegate = self
                controllers.append(controller)

                return controllers
            } else if controllers.count == 0 {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController else { return controllers }

                let model = WeatherService()
                controller.model = model
                controller.delegate = self
                controllers.append(controller)
            }
            return controllers
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        guard let firstVC = self.pages.first else { return }
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func getWeather(type: TypeInputData, model: WeatherService) {
        switch type {
        case TypeInputData.location(let latitude, let longitude):
            model.getWeatherByLocation(latitude: latitude, longitude: longitude, updateScreen: {
                DispatchQueue.main.sync {
                   // controller.model = model
                }


            })
        case TypeInputData.city(let name):
            model.getWeatherByCity(name: name, updateScreen: {
                DispatchQueue.main.sync {
                  //  controller.model = model
                }
            })
        }
        print(model.hourlyWeather.city)
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

        modelCity.arrayCity.append(TypeInputData.location(latitude: latitude, longitude: longitude))
        modelCity.arrayCity.append(TypeInputData.location(latitude: latitude, longitude: longitude))

        guard let firstVC = self.pages.first else { return }
        firstVC.model.getWeatherByLocation(latitude: latitude, longitude: longitude, updateScreen: {
            DispatchQueue.main.sync {
                firstVC.updateScreen()
            }
        })
    }
}




