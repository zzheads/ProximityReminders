//
//  LocationManager.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 13.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager {
    static let sharedInstance = LocationManager()
    
    var isAuthorized: Bool {
        switch (CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse: return true
        case .denied, .notDetermined, .restricted: return false
        }
    }
}
