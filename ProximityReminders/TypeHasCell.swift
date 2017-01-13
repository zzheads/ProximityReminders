//
//  TypeHasCell.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 13.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import RealmSwift

protocol TypeHasCell {
    static var cellReuseIdentifier: String { get }
}

extension TypeHasCell {
    static var cellReuseIdentifier: String {
        return String(describing: type(of: self))
    }
}
