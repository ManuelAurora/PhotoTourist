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
    let session = NSURLSession.sharedSession()
    
    let oauthswift = OAuth2Swift(parameters: [:])

    class func sharedInstance() -> FlickrClient {
        
        struct Singleton
        {
            static let client = FlickrClient()
        }
        
        return Singleton.client
    }
    
    func downloadImages(lat: Double, long: Double) {
                
        oauthswift!.client.get("https://api.flickr.com/services/rest/?method=flickr.photos.geo.photosForLocation&api_key=\(Constants.ParameterValues.APIKey)&lat=\(lat)&lon=\(long)&format=json", success: { (data, response) in
            
            let a = String(data: data, encoding: NSUTF8StringEncoding)
            
            print(a)
            
            }, failure: { (error) in
                print(error)
        })
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
    
    
    
}

