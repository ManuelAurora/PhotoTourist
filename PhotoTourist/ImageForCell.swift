//
//  ImageForCell.swift
//  PhotoTourist
//
//  Created by Мануэль on 13.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class ImageForCell
{
    var image: UIImage?
    var url:   NSURL?    
    
    func downloadImage() {
        
        guard let url = url else { return }
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url) { (data, response, error) in
            
            if let data = data, let image = UIImage(data: data)
            {
                self.image = image
            }
        }
        
        task.resume()
    }
    
}