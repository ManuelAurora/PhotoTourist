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
    @NSManaged var imageData: Data?
    @NSManaged var url:       String?
    @NSManaged var location:  Location?
    
    var image: UIImage?
    
    var loaded: Bool = false
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(withURL url: String, forLocation location: Location) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ImageForCell", in: CoreDataStack.sharedInstance().context)
        
        self.init(entity: entity!, insertInto: CoreDataStack.sharedInstance().context)
        
        self.location = location
        self.url      = url
    }
    
    func downloadImage() {
        
        guard let url = url else { return }
        
        let session  = URLSession.shared
        let imageUrl = URL(string: url)
        
        let task = session.dataTask(with: imageUrl!, completionHandler: { (data, response, error) in
            
            if let data = data, let image = UIImage(data: data)
            {
                DispatchQueue.main.async(execute: { 
                    self.image     = image
                    self.imageData = data
                    self.loaded    = true

                })
            }
        }) 
        
        task.resume()
    }
    
}
