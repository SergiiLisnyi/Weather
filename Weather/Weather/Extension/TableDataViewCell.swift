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
    
    func configureWith(nameDay: String, tempMax: String, tempMin: String) {
        dayLabel.text = nameDay
        tempMaxLabel.text = tempMax
        tempMinLabel.text = tempMin
    }
}
