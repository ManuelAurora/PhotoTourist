//
//  AppDelegate.swift
//  PhotoTourist
//
//  Created by Мануэль on 07.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let managedContext = CoreDataStack.sharedInstance().context
        
        let navController = window!.rootViewController as! UINavigationController
        
        let mapController = navController.viewControllers.first as! MapViewController
    
        mapController.managedContext = managedContext
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handleOpenURL(url)
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        try! CoreDataStack.sharedInstance().saveContext()
        
        let navController = window!.rootViewController          as! UINavigationController
        let mapController = navController.viewControllers.first as! MapViewController
        
        let mapView = mapController.mapView
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setDouble(mapView.centerCoordinate.latitude,  forKey: "Latitude")
        userDefaults.setDouble(mapView.centerCoordinate.longitude, forKey: "Longitude")
        userDefaults.setDouble(mapView.region.span.latitudeDelta,  forKey: "LatDelta")
        userDefaults.setDouble(mapView.region.span.longitudeDelta, forKey: "LonDelta")        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        try! CoreDataStack.sharedInstance().saveContext()
    }

}

