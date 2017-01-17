//
//  ViewController.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 12.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class MasterViewController: UITableViewController {
    var notificationToken: NotificationToken?
    let dataSource = RemindersDataSource()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.dataSource
        self.notificationToken = self.dataSource.reminders.addNotificationBlock({ [weak self](changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {
                return
            }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(let reminders, let deletions, let insertions, let modifications):
                self?.locationManager.refreshNotifications(with: reminders)
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        self.locationManager.stopAllNotifications()
        self.notificationToken?.stop()
    }
}

extension MasterViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        if (segueIdentifier == "editReminder") {
            let controller = segue.destination as! DetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let reminder = self.dataSource.reminders[indexPath.row]
                controller.reminder = reminder
            }
        }
    }
}
