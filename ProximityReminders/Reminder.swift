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
import UIKit
import UserNotifications

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
        region.notifyOnEntry = (self.inOut == .In)
        region.notifyOnExit = (self.inOut == .Out)
        return region
    }
}

extension Reminder {
    var timeTrigger: UNTimeIntervalNotificationTrigger {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        return trigger
    }
    
    var locationTrigger: UNLocationNotificationTrigger? {
        guard let region = self.region else {
            return nil
        }
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        return trigger
    }
    
    var content: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = self.title
        content.body = self.message
        content.categoryIdentifier = "OkAction"
        content.sound = UNNotificationSound.default()
        return content
    }
    
    var request: UNNotificationRequest? {
        let request = UNNotificationRequest(identifier: self.uuid, content: self.content, trigger: self.timeTrigger)
        return request
    }
    
    func push(completionHandler: ((Error?) -> Void)?) {
        guard let request = self.request else {
            ErrorHandler.show(title: "Notification error", message: "Reminder \(self) detected location event, but can not send notification.", completionHandler: nil)
            return
        }
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completionHandler)
    }
}
