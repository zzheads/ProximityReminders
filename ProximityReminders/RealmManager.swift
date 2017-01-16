//
//  RealmManager.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 13.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager: NSObject {
    static let sharedInstance = try! Realm()
    
    override init() {
        super.init()
    }
}
