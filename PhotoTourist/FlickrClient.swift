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
    fileprivate var page       = 1
    fileprivate var totalPages = 0
    
    fileprivate var currentLocation: Location?
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton
        {
            static let client = FlickrClient()
        }
        
        return Singleton.client
    }
    
    func fetchDataForLocation(location: Location) {
        
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
        
        Alamofire.request(Constants.APIBaseURL, method: .get, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate()
            .responseJSON { (response) in
                
                let result = response.result.value as! [String: AnyObject]
                
                let photos = result["photos"]!
                
                let photosArray = photos["photo"] as! [[String: AnyObject]]
                
                self.totalPages = photos["pages"] as! Int
                
                self.currentLocation = location
                
                self.changePageForLocation(location)
                
                DispatchQueue.global().async {
                    for dict in photosArray
                    {
                        let flickrImage = FlickImage(fromDict: dict)
                        
                        let urlForImage = flickrImage.makeUrlForImage()
                        
                        DispatchQueue.main.async {
                                _ = ImageForCell(withURL: urlForImage, forLocation: location)
                        }
                    }
                    
                    DispatchQueue.main.sync {
                        try! CoreDataStack.sharedInstance().saveContext()
                    }
                    
                    self.downloadImages()
                }
        }
    }
    
    func changePageForLocation(_ location: Location) {
        
        guard  let currentLocation = self.currentLocation else { return }
        
        guard currentLocation == location else { page = 1; return }
        
        if page < totalPages { page += 1 }
        else                 { page  = 1 }
    }
    
    func downloadImages() {
        
        guard let currentLocation = currentLocation else { return }
        
        DispatchQueue.main.async(execute: {
            
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

