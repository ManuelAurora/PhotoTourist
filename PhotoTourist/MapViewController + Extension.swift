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

extension MapViewController
{    
    func addGestures() {
        
        let pressureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlePressure))
                
        pressureRecognizer.minimumPressDuration = 0.8
        
        mapView.addGestureRecognizer(pressureRecognizer)
        
        mapView.delegate = self
        
        mapView.setZoomByDelta(0.4, animated: true)
    }
    
    func getLocation(fromGesture gesture: UIGestureRecognizer) -> Location {
                
        let touchPoint = gesture.locationInView(mapView!)
        
        let touchCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView!)
        
        let location = Location(withCoordinate: touchCoordinate)
        
        try! CoreDataStack.sharedInstance().saveContext()
        
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