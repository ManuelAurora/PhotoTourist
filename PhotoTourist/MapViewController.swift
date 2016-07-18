//
//  ViewController.swift
//  PhotoTourist
//
//  Created by Мануэль on 07.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class MapViewController: UIViewController, MKMapViewDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func edit(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSFetchRequest(entityName: "Location")
        
        let result = try! CoreDataStack.sharedInstance().context.executeFetchRequest(request) as! [Location]
        
        print(result.count)
        
        mapView.addAnnotations(result)
        
        addGestures()        
    }
    
    func handlePressure(gestureRecognizer: UIGestureRecognizer) {        
        
        let location = getLocation(fromGesture: gestureRecognizer)
        
        FlickrClient.sharedInstance().fetchDataForLocation(location: location)
        
        mapView.addAnnotation(location)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        showDetails(view)
    }
    
    func showDetails(annotation: MKAnnotationView) {
        
        performSegueWithIdentifier("ShowPhoto", sender: annotation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let annotation = sender as! MKAnnotationView
        
        let location = annotation.annotation as! Location
       
        let controller = segue.destinationViewController as! LocationDetailViewController
        
        controller.location = location
    }
    
   
}

