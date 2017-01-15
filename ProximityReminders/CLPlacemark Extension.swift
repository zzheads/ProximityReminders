//
//  CLPlacemark Extension.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 15.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var address: String {
        var result = ""
        if let thoroughfare = self.thoroughfare {
            result += thoroughfare + ","
        }
        if let subThoroughfare = self.subThoroughfare {
            result += subThoroughfare + ","
        }
        if let locality = self.locality {
            result += locality + ","
        }
        if let subLocality = self.subLocality {
            result += subLocality + ","
        }
        if let isoCountryCode = self.isoCountryCode {
            result += isoCountryCode + ","
        }
        result = String(result.characters.dropLast()) + "."
        return result
    }
}
