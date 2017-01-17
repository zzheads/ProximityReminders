//
//  Errors.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 17.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler {
    static func show(title: String, message: String, completionHandler: ((Bool) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if let handler = completionHandler {
                handler(true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            if let handler = completionHandler {
                handler(false)
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
