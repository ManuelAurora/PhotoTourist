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


class Location: NSManagedObject, MKAnnotation
{
    @NSManaged var images:    NSSet
    @NSManaged var longitude: Double
    @NSManaged var latitude:  Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(withCoordinate: CLLocationCoordinate2D) {
        
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: CoreDataStack.sharedInstance().context)
    
        self.init(entity: entity!, insertIntoManagedObjectContext: CoreDataStack.sharedInstance().context)
             
        
        longitude = withCoordinate.longitude
        latitude  = withCoordinate.latitude
    }
        
}