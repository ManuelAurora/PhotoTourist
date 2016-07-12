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
    
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton
        {
            static let client = FlickrClient()
        }
        
        return Singleton.client
    }
    
    func downloadImages() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let navigationController = appDelegate.window!.rootViewController as! UINavigationController
        
        let webController = navigationController.storyboard!.instantiateViewControllerWithIdentifier("WebController") as! WebViewController
        
        
        let oauthswift = OAuth1Swift(
            consumerKey:    "79fbcc98d30f49f6334399156b8cf996",
            consumerSecret: "1f31975486556a28",
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )
        
        oauthswift.authorize_url_handler = webController
        
        navigationController.presentViewController(webController, animated: true, completion: nil)
        
        oauthswift.authorizeWithCallbackURL(
            NSURL(string: "AuroraInterplay.PhotoTourist://oauth-callback")!,
            success: { credential, response, parameters in
                
                print(credential.oauth_token)
                print(credential.oauth_token_secret)
                print(parameters["user_id"])
                
                navigationController.dismissViewControllerAnimated(true, completion: nil)
                    
                oauthswift.client.get("https://api.flickr.com/services/rest/?method=flickr.photos.geo.photosForLocation&api_key=\(Constants.ParameterValues.APIKey)&lat=55.7522200&lon=37.6155600&format=json", success: { (data, response) in
                    
                    let a = String(data: data, encoding: NSUTF8StringEncoding)
                   
                    print(a)
                   
                    }, failure: { (error) in
                        print(error)
                })
                
            },
            failure: { error in
                print(error.localizedDescription)
            }             
        )
                
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

