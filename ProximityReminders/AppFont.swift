//
//  AppFonts.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 14.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

enum AppFont {
    case Labels
    case Edit

    var font: UIFont {
        guard
            let normalFont = UIFont(name: "Futura Medium", size: 14.0),
            let boldFont = UIFont(name: "Futura Bold", size: 14.0)
            else {
            return UIFont.boldSystemFont(ofSize: 14.0)
        }
        
        switch self {
        case .Labels: return normalFont
        case .Edit: return boldFont
        }
    }
}
