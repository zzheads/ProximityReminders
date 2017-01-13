//
//  Reminder.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 13.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Reminder: Object, TypeHasCell {
    dynamic var title: String = ""
    fileprivate dynamic var latitude: Double = Double.nan
    fileprivate dynamic var longitude: Double = Double.nan
    fileprivate dynamic var inOutValue: String = ""
    dynamic var message: String = ""
}

extension Reminder {
    public var inOut: InOut {
        get {
            guard let type = InOut(rawValue: self.inOutValue) else {
                return .Unknown
            }
            return type
        }
        set {
            self.inOutValue = newValue.rawValue
        }
    }
    
    public func getLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    public func setLocation(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}
