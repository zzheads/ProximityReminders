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
    weak var annotation: MapAnnotation? {
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
    
    override func viewDidLoad() {
        self.locationManager.delegate = self
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
        self.annotation = MapAnnotation(coordinate: location.coordinate, radius: 50.0)
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
            self.annotation = MapAnnotation(coordinate: currentLocation.coordinate, radius: 50.0)
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

        if let location = self.location {
            do {
                self.realm.beginWrite()
                location.title = title
                location.address = address
                location.placemark = placemark
                location.coordinate = lastAnnotation.coordinate
                try self.realm.commitWrite()
            } catch {
                print("Error of saving location: \(error)")
                return
            }
            
        } else {
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
