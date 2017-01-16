//
//  ProximityRemindersTests.swift
//  ProximityRemindersTests
//
//  Created by Alexey Papin on 12.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import XCTest
import RealmSwift

@testable import ProximityReminders
class ProximityRemindersTests: XCTestCase {
    var testLocation: Location!
    var testReminder: Reminder!
    var realm: Realm!
    
    override func setUp() {
        self.testLocation = Location(value: [
            "latitude": 37.33,
            "longitude": -122.031,
            "title": "Test Location"
            ])
        
        self.testReminder = Reminder()
        self.testReminder.title = "Test Reminder"
        self.testReminder.location = self.testLocation
        self.testReminder.inOut = .Out
        
        self.realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
        
        super.setUp()
    }
    
    override func tearDown() {
        try! self.realm.write {
            self.realm.deleteAll()
        }
        super.tearDown()
    }
    
    func testUUID() {
        try! self.realm.write {
            self.realm.add(self.testLocation, update: true)
        }
        let retrivedLocation = self.realm.object(ofType: Location.self, forPrimaryKey: self.testLocation.uuid)
        XCTAssert(retrivedLocation == self.testLocation, "Retrieved location is not equal to stored: \(retrivedLocation) != \(self.testLocation)")
    }
    
    func testInverse() {
        print("Location: \(self.testLocation.reminders)")
        try! self.realm.write {
            self.realm.add(self.testReminder)
        }
        print("\n\n\n\n\n\n\n\nREMINDER: \(self.testReminder)")
        print("\n\n\n\n\n\n\n\nLocation: \(self.testLocation.reminders.count)")
    }
}
