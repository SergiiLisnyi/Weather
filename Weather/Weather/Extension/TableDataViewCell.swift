//
//  TableDataViewCell.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/16/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

class TableDataViewCell: UITableViewCell {
    
    static let identifier = "customCell"

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(forecast: ForecastWeatherOnDays) {
        dayLabel.text = forecast.nameDay
        tempMaxLabel.text = forecast.maxTempDay
        tempMinLabel.text = forecast.minTempDay
    }
    
}
