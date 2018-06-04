
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
    var isLocationEnabled: Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        dataSource = self
    }

    private func loadData() {
        modelCities.updateView = updateCities
        isLocationEnabled ? loadWeatherByLocation() : loadMapView()
    }
    
    @objc func addCity() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MapViewController.reuseIdentifier) as? MapViewController else { return }
        controller.delegate = modelCities
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func edit() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CitiesViewController.reuseIdentifier) as? CitiesViewController else { return }
        controller.delegate = modelCities
        self.present(controller, animated: true, completion: nil)
    }

    private func displayController(index: Int) -> UIViewController? {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WeatherController.reuseIdentifier) as? WeatherController else { return nil }
        if modelCities.modelsWeather.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: MapViewController.reuseIdentifier) as? MapViewController else { return nil }
            controller.delegate = modelCities
            return controller
        } else {
            controller.modelWeather = modelCities.modelsWeather[index]
            guard (toolBar) != nil else { showToolBar(); return controller }
            return controller
        }
    }

    private func updateCities(type: Operation) {
        switch type {
        case .add:
            guard let city = self.modelCities.cities.last else { return }
            let modelWeather = modelCities.getWeatherModel(name: city)
            modelCities.modelsWeather.append(modelWeather)
            guard let controller = displayController(index: modelCities.modelsWeather.count - 1) else { return }
            setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        case .edit:
            dataSource = nil
            if let controller = displayController(index: 0) {
                setViewControllers([controller], direction: .reverse, animated: true, completion: nil)
            } else {
                loadMapView()
            }
            dataSource = self
        }
    }

     private func loadMapView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: MapViewController.reuseIdentifier) as? MapViewController else { return }
        controller.delegate = modelCities
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    private func loadWeatherByLocation() {
        showToolBar()
        modelCities.addCity(cityName: "")
        guard let controller = displayController(index: 0) as? WeatherController else { return }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    private func getIndex(by city: ModelWeatherProtocol) -> Int? {
        for i in 0..<modelCities.cities.count {
            if modelCities.modelsWeather[i].cityName == city.cityName {
                return i
            }
        }
        return nil
    }
    
    private func showToolBar() {
        toolBar = UIToolbar()
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addCity)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(edit)))
        toolBar.setItems(items, animated: true)
        toolBar.tintColor = .blue
        view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: toolBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
        if viewControllerIndex + 1 >= modelCities.cities.count {
            return nil
        }
        return displayController(index: viewControllerIndex + 1)
    }
}

enum Operation {
    case add
    case edit
}





