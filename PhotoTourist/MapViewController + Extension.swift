//
//  MapModel.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreGraphics

extension MapViewController
{
    func centerMapView() {
        
        if wasLaunched() == true
        {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            let latitude  = userDefaults.doubleForKey("Latitude")
            let longitude = userDefaults.doubleForKey("Longitude")
            
            let span      = MKCoordinateSpan(latitudeDelta:  userDefaults.doubleForKey("LatDelta"),
                                             longitudeDelta: userDefaults.doubleForKey("LonDelta"))
            
            let loadedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
            
            mapView.setRegion(loadedRegion, animated: false)            
        }
        else
        {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            let location = CLLocationCoordinate2D(
                latitude: 31.237789,
                longitude: -88.803721
            )
            
            let span = MKCoordinateSpanMake(80, 80)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: true)
            
            userDefaults.setBool(true, forKey: "FirstLaunch")
        }
    }
    
    func wasLaunched() -> Bool {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        return userDefaults.boolForKey("FirstLaunch")        
    }
    
    func addGestures() {
        
        let pressureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlePressure))
                
        pressureRecognizer.minimumPressDuration = 0.8
        
        mapView.addGestureRecognizer(pressureRecognizer)
        
        mapView.delegate = self
        
        mapView.setZoomByDelta(0.4, animated: true)
    }
    
    func toggleDeletion() {
        
        deletingPins = !deletingPins
        
        UIView.transitionWithView(editMapView, duration: 0.5, options: .TransitionCrossDissolve, animations: {
            
            self.editMapView.hidden = !self.deletingPins
            
            let title = self.deletingPins ? "Done" : "Edit"
            
            self.editDoneButton.setTitle(title, forState: .Normal)
            
            }, completion: nil)        
    }
    
    func deleteLocationView(view: MKAnnotationView) {
        
        let location = view.annotation as! Location
        
        mapView.removeAnnotation(location)
        
        managedContext.deleteObject(location)
        
        try! CoreDataStack.sharedInstance().saveContext()
    }
    
    func getLocation(fromGesture gesture: UIGestureRecognizer) -> Location {
                
        let touchPoint = gesture.locationInView(mapView!)
        
        let touchCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView!)
        
        let location = Location(withCoordinate: touchCoordinate)
        
        try! managedContext.save()
                 
        return location
    }
    
    func animateAnnotation(annotation: MKAnnotationView) {
        
        let endFrame = annotation.frame
        
        annotation.frame = CGRectOffset(endFrame, 0, -500)
        
        UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseIn, animations: { 
            
            annotation.frame = endFrame
            
            }) {  _ in
                
                UIView.animateWithDuration(0.05, delay: 0, options: .CurveEaseInOut, animations: { 
                    
                    annotation.transform = CGAffineTransformMakeScale(1, 0.6)
                    
                }) { _ in
                
                    UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseInOut, animations: { 
                        
                        annotation.transform = CGAffineTransformIdentity
                        
                        }, completion: nil)
                }
        }
    }
    
    func fetchLocations() -> [Location] {
        
        let request = NSFetchRequest(entityName: "Location")
        
        let result = try! managedContext.executeFetchRequest(request) as! [Location]
        
        return result
    }
    
}