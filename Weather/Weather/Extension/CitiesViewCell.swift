//
//  CitiesViewCell.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/31/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

class CitiesViewCell: UITableViewCell {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(city: (name: String, temp: String)) {
        cityLabel.text = city.name
        tempLabel.text = city.temp
    }
}

extension CitiesViewCell {
    class var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

