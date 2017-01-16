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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var notificationToken: NotificationToken?
    let locationManager = LocationManager.sharedInstance
    let dataSource = RemindersDataSource()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.locationManager.delegate = self
        self.locationManager.startMonitoringSignificantLocationChanges()
        
        self.notificationToken = self.dataSource.reminders.addNotificationBlock { [weak self](changes: RealmCollectionChange) in
            guard
            let s = self
                else {
                    print("Whoops, self is not self!")
                    return
            }
            
            switch changes {
            case .initial(let reminders):
                s.refresh(notificationsFor: reminders, locationManager: s.locationManager)
                break
            case .update(let reminders,_,_,_):
                s.refresh(notificationsFor: reminders, locationManager: s.locationManager)
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
        
        return true
    }

    deinit {
        self.notificationToken?.stop()
    }
    
    private func refresh(notificationsFor reminders: Results<Reminder>, locationManager: LocationManager) {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
            print("Region: \(region) stopped monitoring...")
        }
        for reminder in reminders {
            if (reminder.isRun) {
                if let region = reminder.region {
                    locationManager.startMonitoring(for: region)
                    print("Region: \(region) started monitoring...")
                }
            }
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated, last is: \(locations.last!.coordinate)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("You have entered to region \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("You have left region \(region.identifier)")
    }
}


