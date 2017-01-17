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
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var annotation: MapAnnotation? {
        willSet {
            guard let annotation = self.annotation else {
                return
            }
            self.mapView.remove(mapAnnotation: annotation)
        }
        didSet {
            guard let annotation = self.annotation else {
                return
            }
            self.mapView.add(mapAnnotation: annotation)
            self.mapView.setCenter(coordinate: annotation.coordinate, coordinatesDelta: AppMap.DELTA_FOR_COORDINATES)
        }
    }
    
    var location: Location?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var placemarkTextField: UITextField!
    @IBOutlet weak var coordinateTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusTextField: UITextField!
    
    override func viewDidLoad() {
        self.mapView.delegate = self

        if (!self.locationManager.isAuthorized) {
            locationManager.requestAlwaysAuthorization()
        }
        
        self.addressTextField.addTarget(self, action: #selector(self.addressEntered(sender:)), for: [.editingDidEnd, .editingDidEndOnExit])
        self.placemarkTextField.addTarget(self, action: #selector(self.addressEntered(sender:)), for: [.editingDidEnd, .editingDidEndOnExit])
        self.coordinateTextField.addTarget(self, action: #selector(self.coordinatesEntered), for: [.editingDidEnd, .editingDidEndOnExit])
        
        self.configureView()
    }
    
    private func configureView() {
        guard let location = self.location else {
            return
        }
        self.titleTextField.text = location.title
        self.addressTextField.text = location.address
        self.placemarkTextField.text = location.placemark
        if let coordinate = location.coordinate {
            self.coordinateTextField.text = "\(coordinate.latitude), \(coordinate.longitude)"
            self.annotation = MapAnnotation(coordinate: coordinate, radius: location.radius)
        }
        self.radiusTextField.text = "\(location.radius)"
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
                ErrorHandler.show(title: "Coordinates error", message: "\(latitudeString), \(longitudeString) unable covert to latitude, longitude numbers", completionHandler: nil)
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
                    ErrorHandler.show(title: "Geocoding error", message: "\(error)", completionHandler: nil)
                } else {
                    ErrorHandler.show(title: "Geocoding error", message: "Unresolved geocoding error", completionHandler: nil)
                }
                return
        }
        self.coordinateTextField.text = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
        self.placemarkTextField.text = placemark.name
        self.addressTextField.text = placemark.address
        self.annotation = MapAnnotation(coordinate: location.coordinate, radius: 50.0)
    }
}

extension MapViewController {
    @IBAction func currentLocationPressed() {
        guard let location = self.locationManager.location else {
            ErrorHandler.show(title: "Location error", message: "Can not retrieve location", completionHandler: nil)
            return
        }
        self.coordinateTextField.text = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
        self.geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
            guard
                let placemarks = placemarks,
                let placemark = placemarks.first
                else {
                    if let error = error {
                        ErrorHandler.show(title: "Geocoding error", message: "\(error)", completionHandler: nil)
                    } else {
                        ErrorHandler.show(title: "Geocoding error", message: "Unresolved geocoding error", completionHandler: nil)
                    }
                    return
            }
            self.placemarkTextField.text = placemark.name
            self.addressTextField.text = placemark.thoroughfare! + "," + placemark.locality! + "," + placemark.country!
            self.annotation = MapAnnotation(coordinate: location.coordinate, radius: 50.0)
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard
            let title = self.titleTextField.text,
            let address = self.addressTextField.text,
            let placemark = self.placemarkTextField.text,
            let lastAnnotation = self.mapView.annotations.last,
            let radiusString = self.radiusTextField.text,
            let radius = Double(radiusString)
            else {
                ErrorHandler.show(title: "Error saving location", message: "Additional information required, all fields must be filled.", completionHandler: nil)
                return
        }
        if (title.isEmpty) {
            ErrorHandler.show(title: "Error saving location", message: "Location must have a title.", completionHandler: nil)
            return
        }

        if let location = self.location {
            do {
                let realm = try Realm()
                realm.beginWrite()
                location.title = title
                location.address = address
                location.placemark = placemark
                location.coordinate = lastAnnotation.coordinate
                location.radius = radius
                try realm.commitWrite()
            } catch {
                ErrorHandler.show(title: "Error saving location", message: "\(error)", completionHandler: nil)
                return
            }
            
        } else {
            let newLocation = Location()
            newLocation.title = title
            newLocation.address = address
            newLocation.placemark = placemark
            newLocation.coordinate = lastAnnotation.coordinate
            newLocation.radius = radius
        
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(newLocation)
                }
            } catch {
                ErrorHandler.show(title: "Error saving location", message: "\(error)", completionHandler: nil)
                return
            }
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.lineWidth = 2.0
        circleView.strokeColor = AppColor.BlueDark.color
        circleView.fillColor = AppColor.BlueLighten.color.with(alpha: 0.2)
        return circleView
    }
}
