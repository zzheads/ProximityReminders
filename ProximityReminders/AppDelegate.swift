//
//  AppDelegate.swift
//  ProximityReminders
//
//  Created by Alexey Papin on 12.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let locationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        var permissionsGranted = true
        
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        if (!self.locationManager.isAuthorized) {
            self.locationManager.requestAlwaysAuthorization()
        }
        if (!self.locationManager.isAuthorized) {
            ErrorHandler.show(title: "Locations permissions", message: "Application can not work without permission of monitoring location changes and will be terminated.", completionHandler: nil)
            permissionsGranted = false
        }
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        self.center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if (!granted) {
                ErrorHandler.show(title: "Notifications permissions", message: "Application can not work without permission of user notifications and will be terminated.", completionHandler: nil)
                permissionsGranted = false
                return
            }
        }
        self.center.delegate = self
        
        let okAction = UNNotificationAction(identifier: "OK", title: "OK", options: .foreground)
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancel", options: [])
        let category = UNNotificationCategory(identifier: "OkAction", actions: [okAction, cancelAction], intentIdentifiers: [], options: [])
        self.center.setNotificationCategories([category])
        
        return permissionsGranted
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // In background check only significant location changes
        if (CLLocationManager.significantLocationChangeMonitoringAvailable()) {
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
        } else {
            NSLog("Significant Location Change Monitoring is NOT Available")
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // In foreground check every location changes
        if (CLLocationManager.significantLocationChangeMonitoringAvailable()) {
            self.locationManager.stopMonitoringSignificantLocationChanges()
            self.locationManager.startUpdatingLocation()
        } else {
            NSLog("Significant Location Change Monitoring is NOT Available")
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Location updated, last is: \(locations.last!.coordinate)")
//    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let realm = try! Realm()
        guard let reminder = realm.object(ofType: Reminder.self, forPrimaryKey: region.identifier) else {
            ErrorHandler.show(title: "Reminder not found", message: "Region \(region.identifier) is monitoring but reminder was not found", completionHandler: nil)
            NSLog("Strange, region is monitoring but reminder was not found. \(region)")
            NSLog("Reminders: \(realm.objects(Reminder.self))")
            return
        }
        if (reminder.inOut == .Out) {
            reminder.push(completionHandler: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let realm = try! Realm()
        guard let reminder = realm.object(ofType: Reminder.self, forPrimaryKey: region.identifier) else {
            ErrorHandler.show(title: "Reminder not found", message: "Region \(region.identifier) is monitoring but reminder was not found", completionHandler: nil)
            NSLog("Strange, region is monitoring but reminder was not found. \(region)")
            NSLog("Reminders: \(realm.objects(Reminder.self))")
            return
        }
        if (reminder.inOut == .In) {
            reminder.push(completionHandler: nil)
        } 
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
