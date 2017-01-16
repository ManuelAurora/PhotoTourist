//
//  AppDelegate.swift
//  PhotoTourist
//
//  Created by Мануэль on 07.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let managedContext = CoreDataStack.sharedInstance().context
        
        let navController = window!.rootViewController as! UINavigationController
        
        let mapController = navController.viewControllers.first as! MapViewController
    
        mapController.managedContext = managedContext
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        
        return true
    }   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        saveDefaultsAndContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        saveDefaultsAndContext()
    }
    
    func saveDefaultsAndContext() {
        
        do
        {
            try CoreDataStack.sharedInstance().saveContext()
        }
        catch
        {
            print("Error saving context")
        }
        
        let navController = window!.rootViewController          as! UINavigationController
        let mapController = navController.viewControllers.first as! MapViewController
        
        let mapView = mapController.mapView
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(mapView?.centerCoordinate.latitude,  forKey: "Latitude")
        userDefaults.set(mapView?.centerCoordinate.longitude, forKey: "Longitude")
        userDefaults.set(mapView?.region.span.latitudeDelta,  forKey: "LatDelta")
        userDefaults.set(mapView?.region.span.longitudeDelta, forKey: "LonDelta")
    }

}

