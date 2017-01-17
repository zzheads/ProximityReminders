//
//  RemindersDataSource.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 16.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class RemindersDataSource: NSObject {
    let realm = try! Realm()
    
    var reminders: Results<Reminder> {
        return self.realm.objects(Reminder.self)
    }
}

extension RemindersDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        let reminder = self.reminders[indexPath.row]
        cell.textLabel?.text = reminder.title
        cell.textLabel?.font = AppFont.Edit.font
        if (reminder.isRun) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let reminder = self.reminders[indexPath.row]
            do {
                try self.realm.write {
                    self.realm.delete(reminder)
                }
            } catch {
                print("Realm error: \(error)")
            }
        }
    }
}
