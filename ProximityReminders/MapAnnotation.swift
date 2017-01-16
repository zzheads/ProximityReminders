//
//  MapAnnotation.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 16.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius: Double
    
    init(coordinate: CLLocationCoordinate2D, radius: Double) {
        self.coordinate = coordinate
        self.radius = radius
        super.init()
    }
}

extension MapAnnotation {
    var circle: MKCircle {
        return MKCircle(center: self.coordinate, radius: self.radius)
    }
}
