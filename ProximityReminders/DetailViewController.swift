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
    var reminder: Reminder?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var inOutControl: UISegmentedControl!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        guard let reminder = self.reminder else {
            return
        }
        self.titleTextField.text = reminder.title
        self.messageTextField.text = reminder.message
        self.inOutControl.selectedSegmentIndex = reminder.inOut.rawValue
        if let location = reminder.getLocation() {
            self.mapView.centerCoordinate = location.coordinate
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard
            let reminder = self.reminder,
            let title = self.titleTextField.text,
            let message = self.messageTextField.text,
            let inOut = InOut(rawValue: self.inOutControl.selectedSegmentIndex),
            let annotation = mapView.annotations.first
            else {
                return
        }
        
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        reminder.title = title
        reminder.inOut = inOut
        reminder.message = message
        reminder.setLocation(location: location)
        
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
