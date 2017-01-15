//
//  setCenter+MKMapView.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 15.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension MKMapView {
    func setCenter(location: Location) {
        guard let coordinate = location.coordinate else {
            return
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.setRegion(region, animated: true)
    }
    
    func setCenter(annotation: MKPointAnnotation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        self.setRegion(region, animated: true)
    }

    func setCenter(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.setRegion(region, animated: true)
    }
    
    func zoomMap(byFactor delta: Double) {
        var region: MKCoordinateRegion = self.region
        var span: MKCoordinateSpan = self.region.span
        span.latitudeDelta *= delta
        span.longitudeDelta *= delta
        region.span = span
        self.setRegion(region, animated: true)
    }
}
