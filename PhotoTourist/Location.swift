//
//  Location.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class Location: NSObject, MKAnnotation
{
    
    var longitude: Double?
    var latitude: Double?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    
    convenience init(withCoordinate: CLLocationCoordinate2D) {
        
        self.init()
        
        longitude = withCoordinate.longitude
        latitude  = withCoordinate.latitude        
        
    }
        
}