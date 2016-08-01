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

class FlickrClient
{
    private var page       = 1
    private var totalPages = 0
    
    private var currentLocation: Location?
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton
        {
            static let client = FlickrClient()
        }
        
        return Singleton.client
    }
    
    func fetchDataForLocation(location location: Location) {
        
        let parameters = [
            Constants.ParameterKeys.Longitude:      "\(location.longitude)",
            Constants.ParameterKeys.Latitude:       "\(location.latitude)",
            Constants.ParameterKeys.APIKey:         Constants.ParameterValues.APIKey,
            Constants.ParameterKeys.Format:         Constants.ParameterValues.ResponseFormat,
            Constants.ParameterKeys.Method:         Constants.ParameterValues.PhotosSearchMethod,
            Constants.ParameterKeys.NoJSONCallback: Constants.ParameterValues.DisableJSONCB,
            Constants.ParameterKeys.PhotosPerPage:  Constants.ParameterValues.PhotosPerPage,
            Constants.ParameterKeys.Sort:           Constants.ParameterValues.RelevanceSort,
            Constants.ParameterKeys.Page:           "\(page)"
        ]
        
        Alamofire.request(.GET, Constants.APIBaseURL, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate()
            .responseJSON { (response) in
                
                let result = response.result.value as! [String: AnyObject]
                
                let photos = result["photos"]!
                
                let photosArray = photos["photo"] as! [[String: AnyObject]]
                
                self.totalPages = photos["pages"] as! Int
                
                self.currentLocation = location
                
                self.changePageForLocation(location)
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                   
                    for dict in photosArray {
                        
                        let flickrImage = FlickImage(fromDict: dict)
                        
                        let urlForImage = flickrImage.makeUrlForImage()
                        
                        let imageForCell = ImageForCell(withURL: urlForImage, forLocation: location)
                        
                        try! CoreDataStack.sharedInstance().saveContext()
                        
                        imageForCell.downloadImage()                        
                    }
                }
        }
    }
    
    func changePageForLocation(location: Location) {
        
        guard  let currentLocation = self.currentLocation else { return }
        
        guard currentLocation == location else { page = 1; return }
        
        if page < totalPages
        {
            page += 1
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
            static let Longitude      = "lon"
            static let Latitude       = "lat"
            static let PhotosPerPage  = "per_page"
            static let Sort           = "sort"
            static let Page           = "page"
        }
        
        struct ParameterValues
        {
            static let APIKey         = "79fbcc98d30f49f6334399156b8cf996"
            static let Secret         = "1f31975486556a28"
            static let ResponseFormat = "json"
            static let DisableJSONCB  = "1"
            static let PhotosPerPage  = "15"
            static let RelevanceSort  = "relevance"
            
            static let PhotosSearchMethod = "flickr.photos.search"
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
    
    func makeUrlForImage() -> String {
        
        guard farm != nil && serverID != nil && id != nil && secret != nil else { return "" }
        
        return "https://farm\(farm!).staticflickr.com/\(serverID!)/\(id!)_\(secret!)_m.jpg"
    }
}

