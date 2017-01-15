//
//  MapViewController.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 15.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController {
    let realm = RealmManager.sharedInstance
    let locationManager = LocationManager.sharedInstance
    let geocoder = CLGeocoder()

    var locations: Results<Location> {
        get {
            return self.realm.objects(Location.self)
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var placemarkTextField: UITextField!
    @IBOutlet weak var coordinateTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        self.locationManager.delegate = self

        if (!self.locationManager.isAuthorized) {
            locationManager.requestAlwaysAuthorization()
        }
        
        for location in self.locations {
            if let pointAnnotation = location.pointAnnotation {
                self.mapView.addAnnotation(pointAnnotation)
            }
        }
        if let lastLocation = self.locations.last {
            self.mapView.setCenter(location: lastLocation)
        }
        self.addressTextField.addTarget(self, action: #selector(self.addressEntered(sender:)), for: [.editingDidEnd, .editingDidEndOnExit])
        self.placemarkTextField.addTarget(self, action: #selector(self.addressEntered(sender:)), for: [.editingDidEnd, .editingDidEndOnExit])
        self.coordinateTextField.addTarget(self, action: #selector(self.coordinatesEntered), for: [.editingDidEnd, .editingDidEndOnExit])
    }
    
    func addressEntered(sender: UITextField) {
        guard let address = sender.text else {
            return
        }
        self.geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.processGeocodingResults(placemarks: placemarks, error: error)
        }
    }
    
    func coordinatesEntered() {
        guard let coordinates = self.coordinateTextField.text else {
            return
        }
        let coordinateComponents = coordinates.characters.split(separator: ",").map { (subsequense) -> String in
            return String(subsequense).replacingOccurrences(of: " ", with: "")
        }
        guard
            let latitudeString = coordinateComponents.first,
            let longitudeString = coordinateComponents.last
            else {
                return
        }
        
        guard let latitude = Double(latitudeString),
            let longitude = Double(longitudeString)
            else {
                print("Coordinates error: \(latitudeString), \(longitudeString) can not covert to \(Double(latitudeString)), \(Double(longitudeString))")
                return
        }
        print("\(latitude), \(longitude)")
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.processGeocodingResults(placemarks: placemarks, error: error)
        }
    }
    
    private func processGeocodingResults(placemarks: [CLPlacemark]?, error: Error?) {
        guard
            let placemarks = placemarks,
            let placemark = placemarks.first,
            let location = placemark.location
            else {
                if let error = error {
                    print("Geocoding error: \(error)")
                } else {
                    print("Unresolved error of geocoding")
                }
                return
        }
        self.coordinateTextField.text = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
        self.placemarkTextField.text = placemark.name
        self.addressTextField.text = placemark.address
        let annotation = MKPointAnnotation()
        annotation.title = self.titleTextField.text
        annotation.coordinate = location.coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(coordinate: location.coordinate)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            print("Unable retrieve current location!")
            return
        }
        self.coordinateTextField.text = "\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)"
        self.geocoder.reverseGeocodeLocation(currentLocation) {(placemarks, error) in
            guard
                let placemarks = placemarks,
                let placemark = placemarks.first
                else {
                    if let error = error {
                        print("Geocode error: \(error)")
                    } else {
                        print("Unresolved geocode error")
                    }
                    return
            }
            self.placemarkTextField.text = placemark.name
            self.addressTextField.text = placemark.thoroughfare! + "," + placemark.locality! + "," + placemark.country!
            let annotation = MKPointAnnotation()
            annotation.title = self.titleTextField.text
            annotation.coordinate = currentLocation.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.setCenter(annotation: annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Retrieving current position failed with error: \(error)")
    }
}

extension MapViewController {
    @IBAction func currentLocationPressed() {
        self.locationManager.requestLocation()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard
            let title = self.titleTextField.text,
            let address = self.addressTextField.text,
            let placemark = self.placemarkTextField.text,
            let lastAnnotation = self.mapView.annotations.last
            else {
                print("Error: can't save location, additioanl information required, all fields must be filled.")
                return
        }

        let newLocation = Location()
        newLocation.title = title
        newLocation.address = address
        newLocation.placemark = placemark
        newLocation.coordinate = lastAnnotation.coordinate
        
        do {
            try self.realm.write {
                self.realm.add(newLocation)
            }
        } catch {
            print("Error of saving location: \(error)")
            return
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func zoomMapStepperChanged(_ sender: UIStepper) {
        let previousValue = sender.tag
        let delta = Int(sender.value) - previousValue
        if (delta < 0) {
            self.mapView.zoomMap(byFactor: 1.5)
        } else {
            self.mapView.zoomMap(byFactor: 1.0/1.5)
        }
        sender.tag = Int(sender.value)
    }
    
    func dismiss(animated: Bool) {
        _ = navigationController?.popViewController(animated: animated)
    }
}