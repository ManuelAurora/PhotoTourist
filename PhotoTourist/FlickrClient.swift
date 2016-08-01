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
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            _ = ImageForCell(withURL: urlForImage, forLocation: location)
                            
                            try! CoreDataStack.sharedInstance().saveContext()
                        })
                    }
                    
                    self.downloadImages()
                }
        }
    }
    
    func changePageForLocation(location: Location) {
        
        guard  let currentLocation = self.currentLocation else { return }
        
        guard currentLocation == location else { page = 1; return }
        
        if page < totalPages { page += 1 }
        else                 { page  = 1 }
    }
    
    func downloadImages() {
        
        guard let currentLocation = currentLocation else { return }
        
        dispatch_async(dispatch_get_main_queue(), {
            
            for element in currentLocation.images
            {
                let image = element as! ImageForCell
                
                image.downloadImage()
            }
        })
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

