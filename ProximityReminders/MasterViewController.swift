//
//  ViewController.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 12.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UIViewController {

    let realm = RealmManager.sharedInstance
    
    let reminders = [
        Reminder(value: ["title":"Reminder1"]),
        Reminder(value: ["title":"Reminder2"]),
        Reminder(value: ["title":"Reminder3"]),
        Reminder(value: ["title":"Reminder4"]),
        Reminder(value: ["title":"Reminder5"])
    ]
    
    lazy var dataSource: RemindersDataSource = {
        let dataSource = RemindersDataSource()
        return dataSource
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: Reminder.cellReuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self.dataSource
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addReminder))
        
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
        
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension MasterViewController: UITableViewDelegate {
}

extension MasterViewController {
    func addReminder() {
        print("Segue to add and edit new Reminder")
    }
}
