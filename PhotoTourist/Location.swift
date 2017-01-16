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
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(withCoordinate: CLLocationCoordinate2D) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: CoreDataStack.sharedInstance().context)
    
        self.init(entity: entity!, insertInto: CoreDataStack.sharedInstance().context)
             
        
        longitude = withCoordinate.longitude
        latitude  = withCoordinate.latitude
    }
        
}
