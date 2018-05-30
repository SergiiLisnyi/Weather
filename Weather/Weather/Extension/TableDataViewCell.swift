//
//  TableDataViewCell.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/16/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

class TableDataViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(data: ForecastWeatherOnDays) {
        dayLabel.text = data.nameDay
        tempMaxLabel.text = data.maxTempDay
        tempMinLabel.text = data.minTempDay
    }
}

extension TableDataViewCell {
    class var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}






