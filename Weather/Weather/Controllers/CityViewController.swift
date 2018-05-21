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
    @IBOutlet weak var nameLabel: UITextField!
    var delegate: PageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        let nameCity = nameLabel.text!
        isValid(nameCity: nameCity)
    }
    
    fileprivate func isValid(nameCity: String) {
        guard let data = self.delegate else { return }
        data.modelCity.getCityName(name: nameCity, updateScreen: { isValidateName in
            DispatchQueue.main.sync {
                if isValidateName {
                    data.modelCity.arrayCity.append(TypeInputData.city(name: nameCity)) //FIX NAME
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
