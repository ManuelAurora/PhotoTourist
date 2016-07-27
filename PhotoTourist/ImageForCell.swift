//
//  ImageForCell.swift
//  PhotoTourist
//
//  Created by Мануэль on 13.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class ImageForCell: NSManagedObject
{
    @NSManaged var imageData: NSData?
    @NSManaged var url:   String?
    @NSManaged var location: Location?
    
    var image: UIImage?    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(withURL url: String, forLocation location: Location) {
        
        let entity = NSEntityDescription.entityForName("ImageForCell", inManagedObjectContext: CoreDataStack.sharedInstance().context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: CoreDataStack.sharedInstance().context)
        
        self.location = location
        self.url      = url
    }
    
    func downloadImage() {
        
        guard let url = url else { return }
        
        let session  = NSURLSession.sharedSession()
        let imageUrl = NSURL(string: url)
        
        let task = session.dataTaskWithURL(imageUrl!) { (data, response, error) in
            
            if let data = data, let image = UIImage(data: data)
            {
                self.image = image
                self.imageData = data           
            }
        }
        
        task.resume()
    }
    
}