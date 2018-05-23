//
//  ViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/15/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

class WeatherController: UIViewController {

    var modelWeather: ModelWeatherProtocol!
    var delegate: PageViewController?
    @IBOutlet weak var dataCollection: UICollectionView!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var navigationButton: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationButton.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(add))
        modelWeather.update {
            self.updateScreen()
        }
    }
    
    @objc func add() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectNameViewController") as? CityViewController else { return }
        controller.delegate = delegate
        self.present(controller, animated: true, completion: nil)
    }

    func updateScreen() {
        DispatchQueue.main.async { 
            self.cityLabel.text = self.modelWeather.hourlyWeather.city
            self.temperatureLabel.text = self.modelWeather.hourlyWeather.tempCurrent
            self.dataCollection.reloadData()
            self.dataTable.reloadData()
        }
    }
}

extension WeatherController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableDataViewCell.identifier, for: indexPath) as? TableDataViewCell else  {
            return UITableViewCell()
        }
        cell.configureWith(forecast: modelWeather.daysWeather[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelWeather.daysWeather.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension WeatherController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  modelWeather.hourlyWeather.arrayTemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else  {
            return UICollectionViewCell()
        }
        cell.configureWith(temp: modelWeather.hourlyWeather.arrayTemp[indexPath.row].temp, time: modelWeather.hourlyWeather.arrayTemp[indexPath.row].time)
        return cell
    }
}






