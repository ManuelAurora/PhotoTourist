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
            let userDefaults = UserDefaults.standard
            
            let latitude  = userDefaults.double(forKey: "Latitude")
            let longitude = userDefaults.double(forKey: "Longitude")
            
            let span      = MKCoordinateSpan(latitudeDelta:  userDefaults.double(forKey: "LatDelta"),
                                             longitudeDelta: userDefaults.double(forKey: "LonDelta"))
            
            let loadedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
            
            mapView.setRegion(loadedRegion, animated: false)            
        }
        else
        {
            let userDefaults = UserDefaults.standard
            
            let location = CLLocationCoordinate2D(
                latitude: 31.237789,
                longitude: -88.803721
            )
            
            let span = MKCoordinateSpanMake(80, 80)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: true)
            
            userDefaults.set(true, forKey: "FirstLaunch")
        }
    }
    
    func wasLaunched() -> Bool {
        
        let userDefaults = UserDefaults.standard
        
        return userDefaults.bool(forKey: "FirstLaunch")        
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
        
        UIView.transition(with: editMapView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            self.editMapView.isHidden = !self.deletingPins
            
            let title = self.deletingPins ? "Done" : "Edit"
            
            self.editDoneButton.setTitle(title, for: UIControlState())
            
            }, completion: nil)        
    }
    
    func deleteLocationView(_ view: MKAnnotationView) {
        
        let location = view.annotation as! Location
        
        mapView.removeAnnotation(location)
        
        managedContext.delete(location)
        
        try! CoreDataStack.sharedInstance().saveContext()
    }
    
    func getLocation(fromGesture gesture: UIGestureRecognizer) -> Location {
                
        let touchPoint = gesture.location(in: mapView!)
        
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView!)
        
        let location = Location(withCoordinate: touchCoordinate)
        
        try! managedContext.save()
                 
        return location
    }
    
    func animateAnnotation(_ annotation: MKAnnotationView) {
        
        let endFrame = annotation.frame
        
        annotation.frame = endFrame.offsetBy(dx: 0, dy: -500)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: { 
            
            annotation.frame = endFrame
            
            }) {  _ in
                
                UIView.animate(withDuration: 0.05, delay: 0, options: UIViewAnimationOptions(), animations: { 
                    
                    annotation.transform = CGAffineTransform(scaleX: 1, y: 0.6)
                    
                }) { _ in
                
                    UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions(), animations: { 
                        
                        annotation.transform = CGAffineTransform.identity
                        
                        }, completion: nil)
                }
        }
    }
    
    func fetchLocations() -> [Location] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        let result = try! managedContext.fetch(request) as! [Location]
        
        return result
    }
    
}
