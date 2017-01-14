//
//  ViewController.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 12.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {
    let realm = RealmManager.sharedInstance
    
    let dataSource = RemindersDataSource()
    
    let reminders = [
        Reminder(value: ["title":"Reminder1"]),
        Reminder(value: ["title":"Reminder2"]),
        Reminder(value: ["title":"Reminder3"]),
        Reminder(value: ["title":"Reminder4"]),
        Reminder(value: ["title":"Reminder5"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let results = self.realm.objects(Reminder.self)
        if (results.isEmpty) {
            do {
                try self.realm.write {
                    for reminder in self.reminders {
                        self.realm.add(reminder)
                    }
                }
                try self.realm.commitWrite()
            } catch {
                print(error)
            }
        }

        self.tableView.dataSource = self.dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MasterViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DetailViewController
        guard let segueIdentifier = segue.identifier else {
            return
        }
        switch segueIdentifier {
        case "addReminder":
            controller.reminder = Reminder()
        case "editReminder":
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let reminder = self.dataSource.reminders[indexPath.row]
                controller.reminder = reminder
            }
        default: return
        }
    }    
}
