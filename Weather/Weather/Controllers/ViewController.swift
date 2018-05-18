//
//  ViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/15/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

import CoreLocation
import MapKit

class ViewController: UIViewController {

    var model = WeatherService()
    var delegate: PageViewController?
    var nameCity: String!

    @IBOutlet weak var dataCollection: UICollectionView!
    @IBOutlet weak var dataTable: UITableView!
    var latitude = "51.50998"
    var longitude =  "-0.1337"

    
    var arrayTempHourly = [String]()
    var arrayTimeHourly = [String]()
    var arrayNameDay = [String]()
    var arrayMinTempDay = [String]()
    var arrayMaxTempDay = [String]()
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocation()
    }

    func updateLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectNameViewController") as? CityViewController else { return }
        controller.delegate = delegate
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func updateScreen() {

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
    
    func getWeather(latitude: String, longitude: String) {
        
        print("in getWeather" + latitude + longitude)
        
        model.getWeather(latitude: latitude, longitude: longitude, updateScreen: {
            DispatchQueue.main.sync {
                self.updateScreen()
            }
        })
    }
    
    func getWeatherName(name: String) {
        model.getWeatherName(name: name, updateScreen: {
            DispatchQueue.main.sync {
                self.updateScreen()
            }
        })
    }
    
    
  
}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

//       latitude = String(locValue.latitude)
//       longitude = String(locValue.longitude)
//       getWeather(latitude: latitude, longitude: longitude)
        
    getWeatherName(name: nameCity)
        
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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






