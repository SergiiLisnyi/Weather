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
    @IBOutlet weak var cityNameTextField: UITextField!
    var delegate: PageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        let nameCity = cityNameTextField.text!
        isValid(nameCity: nameCity)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    fileprivate func isValid(nameCity: String) {
        guard let data = self.delegate else { return }
        data.modelCities.getCityName(name: nameCity, updateScreen: { isValidateName, name in
            DispatchQueue.main.async {
                if isValidateName {
                    data.modelCities.arrayCities.append(name) 
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
