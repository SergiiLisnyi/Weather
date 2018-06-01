//
//  UIViewConroller.swift
//  Weather
//
//  Created by Sergii Lisnyi on 6/1/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//


import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITableViewCell {
    class var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
