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
    var modelCity = CityModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
      //  guard let data = self.delegate else { return }
        let nameCity = nameLabel.text!
       // print(nameCity)
        isValidate(nameCity: nameCity)
        print("tapped button")
//        print(nameCity)
//        data.arrayCity.append(nameCity)
//        self.dismiss(animated: true)
    }
    
    
    func isValidate(nameCity: String) {
        guard let data = self.delegate else { return }
        print(nameCity)
        modelCity.getCityName(name: nameCity, updateScreen: { isValidateName in
            DispatchQueue.main.sync {
                if isValidateName {
                    
                    data.arrayCity.append(nameCity)
                    self.dismiss(animated: true)
                }
                else {
                    self.enterLabel.text = "No correct name"
                    self.enterLabel.textColor = .red
                    print("false")
                }
            }
        })
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
