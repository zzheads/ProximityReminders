//
//  ViewController.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 12.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import RealmSwift

class Dog: Object {
    dynamic var name = ""
    dynamic var age = 0
}

class Person: Object {
    dynamic var name = ""
    dynamic var picture: NSData? = nil // optionals supported
    let dogs = List<Dog>()
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use them like regular Swift objects
        let myDog = Dog()
        myDog.name = "Rex"
        myDog.age = 1
        print("name of dog: \(myDog.name)")
        
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for all dogs less than 2 years old
        let puppies = realm.objects(Dog.self).filter("age < 2")
        print("Puppies: \(puppies.count)") // => 0 because no dogs have been added to the Realm yet
        
        // Persist your data easily
        try! realm.write {
            realm.add(myDog)
        }
        
        // Queries are updated in realtime
        print("Puppies: \(puppies.count)") // => 1
        
        // Query and update from any thread
        DispatchQueue(label: "background").async {
            let realm = try! Realm()
            let theDog = realm.objects(Dog.self).filter("age == 1").first
            try! realm.write {
                theDog!.age = 3
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

