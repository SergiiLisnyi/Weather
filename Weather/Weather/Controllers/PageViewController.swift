
//
//  PageViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/16/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import UIKit

class PageViewController: UIPageViewController {
    
    var modelCity = CityModel()
    var controllers = [WeatherController]()
    var arrayWeather = [ModelWeatherProtocol]()
    
    func displayController(index: Int) -> WeatherController? {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController else { return nil }
        if arrayWeather.indices.contains(index) {
            controller.modelWeather = arrayWeather[index]
            controller.delegate = self
        }
        else {
            let modelWeather = modelCity.getModel(type: modelCity.arrayCity[index])
            controller.modelWeather = modelWeather
            controller.delegate = self
            arrayWeather.append(modelWeather)
        }
        return controller
    }

    func update() {
        let city = self.modelCity.arrayCity.last
        let modelWeather = modelCity.getModel(type: city!)
        arrayWeather.append(modelWeather)
        guard let controller = displayController(index: arrayWeather.count - 1) else { return }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelCity.updateView = update
        modelCity.arrayCity.append(TypeInputData.location())
        loadData()
        dataSource = self
    }
    
    fileprivate func loadData() {
        guard let controller = displayController(index: 0) else { return }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    func getIndex(_ city: ModelWeatherProtocol) -> Int? {
        for i in 0..<modelCity.arrayCity.count {
            switch modelCity.arrayCity[i] {
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
            let viewControllerIndex = getIndex(controller.modelWeather)
            else { return nil }
        if viewControllerIndex - 1 < 0  {
            return nil
        }
        return displayController(index: viewControllerIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? WeatherController,
            let viewControllerIndex = getIndex(controller.modelWeather)
            else { return nil }
        if viewControllerIndex + 1 >= modelCity.arrayCity.count {
            return nil
        }
        return displayController(index: viewControllerIndex + 1)
    }
}







