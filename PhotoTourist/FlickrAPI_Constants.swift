//
//  FlickrAPI_Constants.swift
//  PhotoTourist
//
//  Created by Мануэль on 01.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

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
