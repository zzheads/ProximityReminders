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
import RealmSwift

class DetailViewController: UIViewController {
    let locationManager = LocationManager.sharedInstance
    let geocoder = CLGeocoder()
    let locationsDataSource = LocationsDataSource()
    var reminder: Reminder?
    var notificationToken: NotificationToken?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var inOutControl: UISegmentedControl!
    @IBOutlet weak var locationPickerView: UIPickerView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var runSwitch: UISwitch!
    
    deinit {
        self.notificationToken?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationPickerView.dataSource = self.locationsDataSource
        self.locationPickerView.delegate = self

        self.configureView()

        self.notificationToken = self.locationsDataSource.locations.addNotificationBlock({ (changes) in
            self.locationPickerView.reloadAllComponents()
        })
    }
    
    private func configureView() {
        if (!self.locationManager.isAuthorized) {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        guard let reminder = self.reminder else {
            return
        }
        self.titleTextField.text = reminder.title
        self.messageTextField.text = reminder.message
        self.inOutControl.selectedSegmentIndex = reminder.inOut.rawValue
        self.runSwitch.isOn = reminder.isRun
        
        if let location = reminder.location, let index = self.locationsDataSource.locations.index(of: location) {
            self.locationPickerView.selectRow(index, inComponent: 0, animated: true)
            self.locationLabel.text = location.desc
        } else {
            
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard
            let title = self.titleTextField.text,
            let message = self.messageTextField.text,
            let inOut = InOut(rawValue: self.inOutControl.selectedSegmentIndex)
            else {
                return
        }
        let location = self.locationsDataSource.locations[self.locationPickerView.selectedRow(inComponent: 0)]
        
        if let reminder = self.reminder {
            do {
                let realm = try Realm()
                realm.beginWrite()
                reminder.title = title
                reminder.inOut = inOut
                reminder.message = message
                reminder.location = location
                reminder.isRun = self.runSwitch.isOn
                try realm.commitWrite()
            } catch {
                print("Error saving reminder: \(error)")
            }
        } else {
            let reminder = Reminder()
            reminder.title = title
            reminder.inOut = inOut
            reminder.message = message
            reminder.location = location
            reminder.isRun = self.runSwitch.isOn
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(reminder)
                }
            } catch {
                print("Error saving reminder: \(error)")
            }
        }
        
        //print("Saving reminder: \(self.reminder)")
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
}

extension DetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let location = self.locationsDataSource.locations[row]
        let title = "\(location.title) at \(location.address)(\(location.coordinate))"
        if (view == nil) {
            let label = UILabel()
            label.text = title
            label.font = AppFont.Edit.font
            label.textColor = AppColor.BlueDarken.color
            return label
        } else {
            let label = view as! UILabel
            label.text = "reused"
            return label
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let location = self.locationsDataSource.locations[row]
        self.locationLabel.text = location.desc
    }
}
