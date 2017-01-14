//
//  DetailViewController.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 13.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController {
    let realm = RealmManager.sharedInstance
    let locationManager = LocationManager.sharedInstance
    let geocoder = CLGeocoder()
    var reminder: Reminder?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var inOutControl: UISegmentedControl!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        if (!self.locationManager.isAuthorized) {
            self.locationManager.requestAlwaysAuthorization()
        }
        self.mapView.delegate = self
        self.addressTextField.addTarget(self, action: #selector(self.addressEntered), for: .editingDidEnd)
    }
    
    private func configureView() {
        guard let reminder = self.reminder else {
            return
        }
        self.titleTextField.text = reminder.title
        self.messageTextField.text = reminder.message
        self.inOutControl.selectedSegmentIndex = reminder.inOut.rawValue
        if let location = reminder.getLocation() {
            self.mapView.setCenter(location: location.coordinate)
        }
    }
    
    @objc private func addressEntered() {
        guard let address = self.addressTextField.text else {
            return
        }
        self.geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard
            let placemarks = placemarks,
            let placemark = placemarks.first,
            let location = placemark.location
                else {
                    if let error = error {
                        print("Geocoding error: \(error)")
                        return
                    } else {
                        print("Unresolved geocoding problem")
                        return
                    }
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = address
            self.mapView.addAnnotation(annotation)
            self.mapView.setCenter(location: annotation.coordinate)
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard
            let reminder = self.reminder,
            let title = self.titleTextField.text,
            let message = self.messageTextField.text,
            let inOut = InOut(rawValue: self.inOutControl.selectedSegmentIndex),
            let annotation = mapView.annotations.last
            else {
                return
        }
        
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        self.realm.beginWrite()
        reminder.title = title
        reminder.inOut = inOut
        reminder.message = message
        reminder.setLocation(location: location)
        try! self.realm.commitWrite()
        
        print("Saving reminder: \(self.reminder)")
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension DetailViewController {
    func dismiss(animated: Bool) {
        _ = navigationController?.popViewController(animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension DetailViewController: MKMapViewDelegate {
    
}
