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
    var realm: Realm!
    
    override func setUp() {
        self.testLocation = Location(value: [
            "latitude": 37.33,
            "longitude": -122.031,
            "title": "Test Location"
            ])
        self.realm = try! Realm()
        
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
}
