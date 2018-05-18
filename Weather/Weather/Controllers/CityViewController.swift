//
//  SelectName.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/17/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import UIKit

class CityViewController: UIViewController {
 
    @IBOutlet weak var enterLabel: UILabel!
    var delegate: PageViewController?
    @IBOutlet weak var nameLabel: UITextField!
    
    var modelCity: CityModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        let nameCity = nameLabel.text!
        isValidate(nameCity: nameCity)
    }
    
    func isValidate(nameCity: String) {
        guard let data = self.delegate else { return }
        modelCity.getCityName(name: nameCity, updateScreen: { isValidateName in
            DispatchQueue.main.sync {
                if isValidateName {
                    self.modelCity.arrayCity.append(nameCity)
                    data.updateData(array: self.modelCity.arrayCity)
                    self.dismiss(animated: true)
                }
                else {
                    self.enterLabel.text = "No correct name"
                    self.enterLabel.textColor = .red
                }
            }
        })
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
