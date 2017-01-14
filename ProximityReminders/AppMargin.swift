//
//  AppMargin.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 14.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

enum AppMargin {
    case x
    case y
    
    var margin: CGFloat {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        switch self {
        case .x: return width * 8 / 340
        case .y: return height * 8 / 500
        }
    }
}
