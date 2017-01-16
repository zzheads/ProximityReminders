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
    let dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MasterViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        switch segueIdentifier {
        case "addReminder":
            let controller = segue.destination as! DetailViewController
            controller.delegate = self
        case "editReminder":
            let controller = segue.destination as! DetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let reminder = self.dataSource.reminders[indexPath.row]
                controller.reminder = reminder
            }
            controller.delegate = self
        case "editLocations":
            let _ = segue.destination as! MapViewController
        default:
            break
        }
    }
}

extension MasterViewController: UpdateChangesDelegate {
    func updateChanges() {
        self.tableView.reloadData()
    }
}
