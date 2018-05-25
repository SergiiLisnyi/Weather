
//
//  PageViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/16/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import UIKit
import CoreLocation

class PageViewController: UIPageViewController {
    
    var modelCity = ModelCity()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataWeather()
        dataSource = self
    }
    
    func isEnableLocation() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
    
    func displayController(index: Int) -> WeatherController? {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController else { return nil }
        controller.delegate = self
        if  modelCity.arrayWeather.indices.contains(index) {
            controller.modelWeather = modelCity.arrayWeather[index]
        }
        else {
            let modelWeather = modelCity.getWeatherModel(type: modelCity.arrayCities[index])
            controller.modelWeather = modelWeather
            modelCity.arrayWeather.append(modelWeather)
        }
        return controller
    }

    func update() {
        let city = self.modelCity.arrayCities.last
        let modelWeather = modelCity.getWeatherModel(type: city!)
        modelCity.arrayWeather.append(modelWeather)
        guard let controller = displayController(index: modelCity.arrayWeather.count - 1) else { return }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func loadDataWeather() {
        modelCity.updateView = update
        isEnableLocation() ? modelCity.arrayCities.append(TypeInputData.location()) :
                            modelCity.arrayCities.append(TypeInputData.city(name: "London"))
        guard let controller = displayController(index: 0) else { return }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    func getIndex(by city: ModelWeatherProtocol) -> Int? {
        for i in 0..<modelCity.arrayCities.count {
            switch modelCity.arrayCities[i] {
            case .city(let name):
                if name == city.hourlyWeather.city {
                    return i
                }
            case .location():
                if city as? ModelWeatherByLocation != nil {
                    return i
                }
            }
        }
        return nil
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? WeatherController,
            let viewControllerIndex = getIndex(by: controller.modelWeather)
            else { return nil }
        if viewControllerIndex - 1 < 0  {
            return nil
        }
        return displayController(index: viewControllerIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? WeatherController,
            let viewControllerIndex = getIndex(by: controller.modelWeather)
            else { return nil }
        if viewControllerIndex + 1 >= modelCity.arrayCities.count {
            return nil
        }
        return displayController(index: viewControllerIndex + 1)
    }
}







