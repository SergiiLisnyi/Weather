//
//  ViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/15/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit
import MBProgressHUD

class WeatherController: UIViewController {

    var modelWeather: ModelWeatherProtocol!
    var delegate: PageViewController?
    @IBOutlet weak var dataCollection: UICollectionView!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var navigationButton: UINavigationItem!
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startMBProgress()
        setBackground()
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
    
    func startMBProgress() {
        if !modelWeather.isLoad() {
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .indeterminate
        }
    }
    
    func closeMBProgress() {
        if self.modelWeather.isLoad() {
            self.hud?.hide(animated: true, afterDelay: 0)
        }
    }
    
    func setBackground() {
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = UIImage(named: "img")
        self.view.insertSubview(imageView, at: 0)
    }
    
    func updateScreen() {
        DispatchQueue.main.async {         
            self.cityLabel.text = self.modelWeather.cityName
            self.temperatureLabel.text = self.modelWeather.hourlyWeather?.tempCurrent
            self.dataCollection.reloadData()
            self.dataTable.reloadData()
            self.closeMBProgress()
        }
    }
}

extension WeatherController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableDataViewCell.identifier, for: indexPath) as? TableDataViewCell else  {
            return UITableViewCell()
        }
        cell.configureWith(data: modelWeather.daysWeather[indexPath.row])
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
        return  modelWeather.hourlyWeather?.arrayWeatherHourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else  {
            return UICollectionViewCell()
        }
        cell.configureWith(temp: (modelWeather.hourlyWeather?.arrayWeatherHourly[indexPath.row].temp)!,
                           time: (modelWeather.hourlyWeather?.arrayWeatherHourly[indexPath.row].time)!)
        return cell
    }
}






