//
//  AppColors.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 13.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

enum AppColor {
    case BlueLighten
    case BlueLight
    case BlueNormal
    case BlueDark
    case BlueDarken
    
    var color: UIColor {
        switch self {
        case .BlueLighten: return UIColor(red: 170/255.0, green: 220/255.0, blue: 240/255.0, alpha: 1.0)
        case .BlueLight: return UIColor(red: 99/255.0, green: 192/255.0, blue: 230/255.0, alpha: 1.0)
        case .BlueNormal: return UIColor(red: 59/255.0, green: 163/255.0, blue: 208/255.0, alpha: 1.0)
        case .BlueDark: return UIColor(red: 8/255.0, green: 114/255.0, blue: 160/255.0, alpha: 1.0)
        case .BlueDarken: return UIColor(red: 1/255, green: 74/255.0, blue: 104/255.0, alpha: 1.0)
        }
    }
}

extension UIColor {
    func with(alpha: CGFloat) -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var oldAlpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &oldAlpha)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
