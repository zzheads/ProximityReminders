//
//  LocationManager.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 13.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class LocationManager: CLLocationManager {
    static let sharedInstance = LocationManager()
    
    var isAuthorized: Bool {
        switch (CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse: return true
        case .denied, .notDetermined, .restricted: return false
        }
    }
    
    func stopAllNotifications() {
        for region in self.monitoredRegions {
            self.stopMonitoring(for: region)
            print("Region: \(region) stopped monitoring...")
        }
    }
    
    func refreshNotifications(with reminders: Results<Reminder>) {
        stopAllNotifications()
        for reminder in reminders {
            if (reminder.isRun) {
                if let region = reminder.region {
                    self.startMonitoring(for: region)
                    print("Region: \(region) started monitoring...")
                }
            }
        }
    }
}
