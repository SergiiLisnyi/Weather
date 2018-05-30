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
    var hud: MBProgressHUD?
    @IBOutlet weak var dataCollection: UICollectionView!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(WeatherController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startMBProgress()
        setBackground()
        modelWeather.update {
            self.updateScreen()
        }
        self.dataTable.addSubview(self.refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        updateScreen()
        refreshControl.endRefreshing()
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
            self.temperatureLabel.text = self.modelWeather.nowWeather?.tempCurrent
            self.dataCollection.reloadData()
            self.dataTable.reloadData()
            self.closeMBProgress()
        }
    }
}

extension WeatherController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableDataViewCell.reuseIdentifier, for: indexPath) as? TableDataViewCell else  {
            return UITableViewCell()
        }
        cell.configureWith(data: modelWeather.daysWeather[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelWeather.daysWeather.count
    }
}


extension WeatherController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelWeather.hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else  { return UICollectionViewCell() }
        cell.configureWith(data: modelWeather.hourlyWeather[indexPath.row])
        return cell
    }
}






