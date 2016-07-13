//
//  MapModel.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import Alamofire

extension MapViewController
{
    
    func addGestures() {
        
        let pressureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlePressure))
        
        pressureRecognizer.minimumPressDuration = 0.8
                
        mapView.addGestureRecognizer(pressureRecognizer)
        
        mapView.delegate = self
        
        mapView.setZoomByDelta(0.4, animated: true)
    }
    
    func getLocation(fromGesture gesture: UIGestureRecognizer) -> Location {
                
        let touchPoint = gesture.locationInView(mapView!)
        
        let touchCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView!)
        
        let location = Location(withCoordinate: touchCoordinate)
                
        return location
    }
    
    func fetchDataForLocation(location location: Location) {
        
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
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    
                    for photo in photosArray
                    {
                        let farm     = photo["farm"]
                        let serverID = photo["server"]
                        let id       = photo["id"]
                        let secret   = photo["secret"]
                        
                        let url = NSURL(string: "https://farm\(farm!).staticflickr.com/\(serverID!)/\(id!)_\(secret!)_m.jpg")
                        
                        let image = UIImage(data: NSData(contentsOfURL: url!)!)
                        
                        location.images.append(image!)
                    }
                }
                
        }
    
    }
    
}