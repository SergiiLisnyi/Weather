//
//  ViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/15/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

//import CoreLocation
//import MapKit

class WeatherController: UIViewController {

    var model = WeatherService()
    var delegate: PageViewController?
    var arrayTempHourly = [String]()
    var arrayTimeHourly = [String]()
    var arrayNameDay = [String]()
    var arrayMinTempDay = [String]()
    var arrayMaxTempDay = [String]()
    var type: TypeInputData!

    
    @IBOutlet weak var dataCollection: UICollectionView!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectNameViewController") as? CityViewController else { return }
        controller.delegate = delegate
        self.present(controller, animated: true, completion: nil)
    }
    
    fileprivate func getWeather() {
        guard let type = type else { return }
        switch type {
        case TypeInputData.location(let latitude, let longitude):
            getWeatherByLocation(latitude: latitude, longitude: longitude)
        case TypeInputData.city(let name):
            getWeatherByCity(name: name)
        }
    }
    
    fileprivate func updateScreen() {

        cityLabel.text = model.hourlyWeather.city
        temperatureLabel.text = model.hourlyWeather.tempCurrent
        arrayTempHourly = model.hourlyWeather.arrayTempHourly
        arrayTimeHourly = model.hourlyWeather.arrayTimeHourly
        
        arrayNameDay = model.daysWeather.arrayNameDay
        arrayMinTempDay = model.daysWeather.arrayMinTempDay
        arrayMaxTempDay = model.daysWeather.arrayMaxTempDay
        
        dataCollection.reloadData()
        dataTable.reloadData()
    }
    
    fileprivate func getWeatherByLocation(latitude: String, longitude: String) {
        model.getWeatherByLocation(latitude: latitude, longitude: longitude, updateScreen: {
            DispatchQueue.main.sync {
                self.updateScreen()
            }
        })
    }
    
    fileprivate func getWeatherByCity(name: String) {
        model.getWeatherByCity(name: name, updateScreen: {
            DispatchQueue.main.sync {
                self.updateScreen()
            }
        })
    }
}

extension WeatherController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableDataViewCell.identifier, for: indexPath) as? TableDataViewCell else  {
            return UITableViewCell()
        }
        cell.configureWith(nameDay: arrayNameDay[indexPath.row], tempMax: arrayMaxTempDay[indexPath.row], tempMin: arrayMinTempDay[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNameDay.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


extension WeatherController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrayTempHourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else  {
            return UICollectionViewCell()
        }
        cell.configureWith(temp: arrayTempHourly[indexPath.row], time: arrayTimeHourly[indexPath.row])
        return cell
    }
}






