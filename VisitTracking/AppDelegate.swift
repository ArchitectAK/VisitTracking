//
//  AppDelegate.swift
//  VisitTracking
//
//  Created by Ankit Kumar on 25/02/2019.
//  Copyright © 2019 Ankit Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    static let geoCoder = CLGeocoder()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
    
        let tabTintColor = UIColor(red: 0/255, green: 104/255, blue: 55/255, alpha: 1)
        UITabBar.appearance().tintColor = tabTintColor
        
        //Asking for Notifications Permissions
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        }
        
        //Asking for location permission
        locationManager.requestAlwaysAuthorization()
        
        //Subscribe to Location Changes
        locationManager.startMonitoringVisits()
        locationManager.delegate = self
        
        // 1
        locationManager.distanceFilter = 35
        
        // 2
        locationManager.allowsBackgroundLocationUpdates = true
        
        // 3
        locationManager.startUpdatingLocation()
        
        return true
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


// Core Location uses delegate callbacks to inform you of location changes
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // create CLLocation from the coordinates of CLVisit
        let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        
        // Get location description
    }
    
    func newVisitReceived(_ visit: CLVisit, description: String) {
        let location = Location(visit: visit, descriptionString: description)
        
        // Save location to disk
//        LocationStorage.shared.saveLocationOnDisk(location)
        
        // create notification content
        let content = UNMutableNotificationContent()
        content.title = "New Place Visited"
        content.body = location.description
        content.sound = .default
        
        // Create a one second long trigger and notification request with that trigger.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: location.dateString, content: content, trigger: trigger)
        
        // Schedule the notification by adding the request to notification center.
        center.add(request, withCompletionHandler: nil)
        
    }
}

