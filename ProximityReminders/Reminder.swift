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

class Reminder: Object {
    dynamic var uuid = UUID().uuidString
    dynamic var title: String = ""
    dynamic var location: Location?
    fileprivate dynamic var inOutValue: Int = 2
    dynamic var message: String = ""
    dynamic var isRun: Bool = false
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
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
}

extension Reminder {
    var region: CLRegion? {
        guard
            let location = self.location,
            let coordinate = location.coordinate
            else {
            return nil
        }
        let region = CLCircularRegion(center: coordinate, radius: location.radius, identifier: self.uuid)
        return region
    }
}
