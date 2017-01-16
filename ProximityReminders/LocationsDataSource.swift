//
//  LocationsDataSource.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 16.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class LocationsDataSource: NSObject {
    var locations: Results<Location> {
        print("Creating realm! in locations DataSource")
        let realm = try! Realm()
        return realm.objects(Location.self)
    }
}

extension LocationsDataSource: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locations.count
    }
}

extension LocationsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = self.locations[indexPath.row]
        cell.textLabel?.text = "\(location.title.capitalized) (\(location.address))"
        cell.textLabel?.font = AppFont.Edit.font
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let location = self.locations[indexPath.row]
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(location)
                }
            } catch {
                print("Realm error: \(error)")
            }
        }
    }
}
