
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
    
    let modelCities = ModelCities()
    var toolBar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataWeather()
        dataSource = self
    }

    
    private func createToolBar() {
        toolBar = UIToolbar()
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addCity)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil))
        
        toolBar.setItems(items, animated: true)
        toolBar.tintColor = .blue
        view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: toolBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: toolBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        
        toolBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
    
    @objc func addCity() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    //    @objc func add() {
    //        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectNameViewController") as? CityViewController else { return }
    //        controller.delegate = delegate
    //        self.present(controller, animated: true, completion: nil)
    //    }
    
    
    
    
    var isLocationEnabled: Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
    
    func displayController(index: Int) -> WeatherController? {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as? WeatherController else { return nil }
        controller.delegate = self
        controller.modelWeather = modelCities.arrayWeather[index]
        guard (toolBar) != nil else { createToolBar(); return controller }
        return controller
    }

    func updateArrayCities() {
        guard let city = self.modelCities.arrayCities.last else { return }
        let modelWeather = modelCities.getWeatherModel(name: city)
        modelCities.arrayWeather.append(modelWeather)
        guard let controller = displayController(index: modelCities.arrayWeather.count - 1) else { return }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    private func loadMapView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        controller.delegate = self
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    private func loadWeatherByLocation() {
        createToolBar()
        modelCities.arrayCities.append("")
        guard let controller = displayController(index: 0) else { return }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func loadDataWeather() {
        modelCities.updateView = updateArrayCities
        isLocationEnabled ? loadWeatherByLocation() : loadMapView()
    }
    
    func getIndex(by city: ModelWeatherProtocol) -> Int? {
        for i in 0..<modelCities.arrayCities.count {
            if modelCities.arrayCities[i] == city.nowWeather?.city {
                return i
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
        if viewControllerIndex + 1 >= modelCities.arrayCities.count {
            return nil
        }
        return displayController(index: viewControllerIndex + 1)
    }
}







