//
//  LocationsTableViewController.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 16.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class LocationsTableViewController: UITableViewController {
    var notificationToken: NotificationToken?
    let realm = RealmManager.sharedInstance
    let dataSource = LocationsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.notificationToken = self.dataSource.locations.addNotificationBlock({ [weak self](changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {
                return
            }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
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
        self.notificationToken?.stop()
    }
}

extension LocationsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        if (segueIdentifier == "editLocation") {
            let controller = segue.destination as! MapViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let location = self.dataSource.locations[indexPath.row]
                controller.location = location
            }
        }
    }
}
