//
//  FlickrClient.swift
//  PhotoTourist
//
//  Created by Мануэль on 07.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import OAuthSwift

class FlickrClient
{
    var state: State = .NotSearchedYet
    
    enum State
    {
        case NotSearchedYet
        case Loading
        case NoResults
        case Results
    }
    
    

    private var total = 0
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton
        {
            static let client = FlickrClient()
        }
        
        return Singleton.client
    }
    
    func fetchDataForLocation(location location: Location) {
        
        let parameters = [
            "api_key": "79fbcc98d30f49f6334399156b8cf996",
            "lon": "\(location.longitude)",
            "lat": "\(location.latitude)",
            "format": "json",
            "method":"flickr.photos.search",
            "nojsoncallback": "1",
            "per_page": "100",
            "sort": "relevance"
//            "geo_context": "2"
        ]
        
        Alamofire.request(.GET, "https://api.flickr.com/services/rest/", parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate()
            .responseJSON { (response) in
                
                let result = response.result.value as! [String: AnyObject]
                
                let photosArray = result["photos"]!["photo"] as! [[String: AnyObject]]
                
                self.total = photosArray.count
                
                print(self.total)
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    
                    let set = NSMutableSet()
                    
                    var numberOfItems = 0
                    
                    if self.total > 15
                    {
                        numberOfItems = 15
                    }
                    else
                    {
                        numberOfItems = self.total
                    }
                    
                    while set.allObjects.count < numberOfItems
                    {
                        let rnd   = Int(arc4random_uniform(UInt32(self.total)))
                        let dict  = photosArray[rnd]
                        
                        var flickrImage = FlickImage(fromDict: dict)
                        
                        let urlForImage = "https://farm\(flickrImage.farm!).staticflickr.com/\(flickrImage.serverID!)/\(flickrImage.id!)_\(flickrImage.secret!)_m.jpg"
                        
                        for item in set
                        {
                            let image = item as! ImageForCell
                            
                            if urlForImage == image.url! { flickrImage.used = true }
                        }
                        
                        if !flickrImage.used
                        {
                            let imageForCell = ImageForCell(withURL: urlForImage )
                            
                            set.addObject(imageForCell)
                        }
                    }
                    
                    location.images = set
                    self.downloadImages(forLocation: location)
                }
        }
    }
}

extension FlickrClient
{
    struct Constants
    {
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
        static let AuthURL    = "https://www.flickr.com/auth-72157670737850785"
        
        struct ParameterKeys
        {
            static let Method         = "method"
            static let APIKey         = "api_key"
            static let Format         = "format"
            static let NoJSONCallback = "nojsoncallback"
        }
        
        struct ParameterValues
        {
            static let APIKey         = "79fbcc98d30f49f6334399156b8cf996"
            static let Secret         = "1f31975486556a28"
            static let ResponseFormat = "json"
            static let DisableJSONCB  = "1"
            
            static let PhotosForLocationMethod = "flickr.photos.geo.photosForLocation"
        }
        
        struct ResponseKeys
        {
            static let Status = "stat"
            static let Photos = "photos"
            static let Photo  = "photo"
            static let Title  = "title"
        }
        
        struct ResponseValues
        {
            static let OKStatus = "ok"
        }
    }
    
    private func escapedParameters(parameters: [String: AnyObject]) -> String {
        
        guard !parameters.isEmpty else { return "" }
        
        var keyValuePairs = [String]()
        
        for (key, value) in parameters
        {
            let stringValue = "\(value)"
            
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            keyValuePairs.append(key + "=" + "\(escapedValue!)")
        }
        
        return "?\(keyValuePairs.joinWithSeparator("&"))"
    }
    
    func downloadImages(forLocation location: Location) {
        
        for element in location.images
        {
            let image = element as! ImageForCell
            
            image.downloadImage()
        }
    }
    
}

struct FlickImage
{
    let farm:     AnyObject?
    let serverID: AnyObject?
    let id:       AnyObject?
    let secret:   AnyObject?
    
    var used:     Bool = false
    
    init(fromDict photo: [String: AnyObject]) {
        
        farm     = photo["farm"]
        serverID = photo["server"]
        id       = photo["id"]
        secret   = photo["secret"]
    }
}

