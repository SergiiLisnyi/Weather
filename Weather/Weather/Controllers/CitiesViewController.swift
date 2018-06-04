//
//  CitiesViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/31/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {

    @IBOutlet weak var dataTable: UITableView!
    var cityData = [(name: String, temp: String)]()
    var delegate: CitiesViewControllerDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        guard let data = self.delegate, let cityData = data.getCity() else { return }
        self.cityData = cityData
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
       dataTable.isEditing = !dataTable.isEditing
    }
    
    private func setBackground() {
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = UIImage(named: "city")
        self.view.insertSubview(imageView, at: 0)
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitiesViewCell.reuseIdentifier, for: indexPath) as? CitiesViewCell else  {
            return UITableViewCell()
        }
        cell.configureWith(city: cityData[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityData.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cityData.remove(at: indexPath.row)
            guard let data = self.delegate else { return }
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let data = self.delegate else { return }
        data.editOrder(from: sourceIndexPath.row, to: destinationIndexPath.row)
        let item = cityData[sourceIndexPath.row]
        cityData.remove(at: sourceIndexPath.row)
        cityData.insert(item, at: destinationIndexPath.row)
    }
}








