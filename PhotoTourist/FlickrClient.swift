//
//  FlickrClient.swift
//  PhotoTourist
//
//  Created by Мануэль on 07.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

class FlickrClient
{
    let session = NSURLSession.sharedSession()
    
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton
        {
            static let client = FlickrClient()
        }
        
        return Singleton.client
    }
    
    func downloadImages() {
    
//        let oauthswift = OAuth1Swift(
//            consumerKey:    "79fbcc98d30f49f6334399156b8cf996",
//            consumerSecret: "1f31975486556a28",
//            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
//            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
//            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
//        )
    
        let oauthswift = OAuth1Swift(
            consumerKey:    "79fbcc98d30f49f6334399156b8cf996",
            consumerSecret: "1f31975486556a28",
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )

        
        let methodParameters = [
            
            Constants.ParameterKeys.Method:   Constants.ParameterValues.PhotosForLocationMethod,
            Constants.ParameterKeys.APIKey:   Constants.ParameterValues.APIKey,
            Constants.ParameterKeys.Format:   Constants.ParameterValues.ResponseFormat,
           // "oauth_token": token,
            "perms": "read",
            "lat": "45",
            "lon": "50"
        ]
        
        let urlString = Constants.APIBaseURL// + escapedParameters(methodParameters)
        
        let url = NSURL(string: urlString)
        
        let appDelegate       = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let navController     = appDelegate.window?.rootViewController as! UINavigationController
        
        let controller        = navController.viewControllers.first as! MapViewController
        
        let webViewController = controller.storyboard!.instantiateViewControllerWithIdentifier("WebController") as! WebViewController
        
        oauthswift.authorize_url_handler = webViewController
        
        controller.presentViewController(webViewController, animated: true) { 
     
        oauthswift.authorizeWithCallbackURL(NSURL(string: "AuroraInterplay.PhotoTourist:/oauth2Callback")!, success: { (credential, response, parameters) in
            print(response)
            }, failure: { (error) in
                print(error)
        })
        
        
        
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
    
    
    
}

