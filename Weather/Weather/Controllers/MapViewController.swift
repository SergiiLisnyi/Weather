//
//  MapViewController.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/29/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {

    @IBOutlet weak var navigationItems: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    private var latitude: String!
    private var longitude: String!
    var delegate: PageViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItems.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(done))
        navigationItems.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cansel)),
                                          UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: #selector(search))]
        }

    @objc func search() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @objc func done() {
        (latitude != nil || longitude != nil) ? addToArrayCities(latitude: latitude, longitude: longitude) : cansel()
    }
    
    @objc func cansel() {
        self.dismiss(animated: true)
    }
    
    private func addToArrayCities (latitude: String, longitude: String) {
        guard let data = self.delegate else { return }
        data.modelCities.getCityNameByLocation(latitude: latitude, longitude: longitude, complete: { name in
            DispatchQueue.main.async {
                data.modelCities.arrayCities.append(City(name: name))
                self.dismiss(animated: true)
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeAnnotation()
            let touchPoint = touch.location(in: self.mapView)
            let location = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            self.pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = location
            longitude = String(location.longitude)
            latitude = String(location.latitude)
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    private func removeAnnotation() {
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        removeAnnotation()
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude,
                                                                     longitude: localSearchResponse!.boundingRegion.center.longitude)
            self.latitude = String(localSearchResponse!.boundingRegion.center.latitude)
            self.longitude = String(localSearchResponse!.boundingRegion.center.longitude)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
}
