//
//  CollectionViewCell.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/16/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "cell"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(temp: String, time: String) {
       tempLabel.text = temp
       timeLabel.text = time
    }
}
