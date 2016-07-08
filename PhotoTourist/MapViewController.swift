//
//  ViewController.swift
//  PhotoTourist
//
//  Created by Мануэль on 07.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func edit(sender: AnyObject) {
        
            FlickrClient.sharedInstance().downloadImages() 
    }

}

