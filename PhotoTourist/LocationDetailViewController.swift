//
//  LocationDetailViewController.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import Alamofire

class LocationDetailViewController: UIViewController
{
    @IBOutlet weak var image: UIImageView!
    
    var location: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let parameters = [
            "api_key": "79fbcc98d30f49f6334399156b8cf996",
            "lon": "\(location.longitude!)",
            "lat": "\(location.latitude!)",
            "format": "json",
            "method":"flickr.photos.search",
            "nojsoncallback": "1"            
        ]
        
        Alamofire.request(.GET, "https://api.flickr.com/services/rest/", parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate()
            .responseJSON { (response) in
                
                let result = response.result.value as! [String: AnyObject]
                
                let photosArray = result["photos"]!["photo"] as! [[String: AnyObject]]
                
                let photo = photosArray[0]
                
                let farm = photo["farm"]
                let serverID = photo["server"]
                let id = photo["id"]
                let secret = photo["secret"]
                
                let url = NSURL(string: "https://farm\(farm!).staticflickr.com/\(serverID!)/\(id!)_\(secret!).jpg")
                
                let image = UIImage(data: NSData(contentsOfURL: url!)!)
                
                self.image.image = image
        }
        
                
        
        
    }
    
    
}