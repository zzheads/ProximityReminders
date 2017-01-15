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
    dynamic var location: Location?
    fileprivate dynamic var inOutValue: Int = 2
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
    
//    public func getLocation() -> CLLocation? {
//        if (self.latitude.isNaN || self.longitude.isNaN) {
//            return nil
//        }
//        return CLLocation(latitude: self.latitude, longitude: self.longitude)
//    }
//    
//    public func setLocation(location: CLLocation?) {
//        guard let location = location else {
//            self.latitude = Double.nan
//            self.longitude = Double.nan
//            return
//        }
//        self.latitude = location.coordinate.latitude
//        self.longitude = location.coordinate.longitude
//    }
}
