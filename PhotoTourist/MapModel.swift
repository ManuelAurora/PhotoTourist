//
//  MapModel.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

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
    
   
    
}