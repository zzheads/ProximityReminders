//
//  Location.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 15.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation
import MapKit

class Location: Object {
    dynamic var latitude: Double = Double.nan
    dynamic var longitude: Double = Double.nan
    dynamic var title: String = ""
    dynamic var address: String?
    dynamic var placemark: String?
}

extension Location {
    public var coordinate: CLLocationCoordinate2D? {
        get {
            if (self.latitude.isNaN || self.longitude.isNaN) {
                return nil
            }
            return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
        set {
            guard let newValue = newValue else {
                self.latitude = Double.nan
                self.longitude = Double.nan
                return
            }
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
    }
    
    public var pointAnnotation: MKPointAnnotation? {
        guard let coordinate = self.coordinate else {
            return nil
        }
        let point = MKPointAnnotation()
        point.coordinate = coordinate
        point.title = self.title
        return point
    }
}

extension Location {
    
}
