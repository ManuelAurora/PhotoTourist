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
    
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func edit(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locations = fetchLocations()
        
        mapView.addAnnotations(locations)
        
        addGestures()        
    }
    
    func handlePressure(gestureRecognizer: UIGestureRecognizer) {        
        
        guard gestureRecognizer.state == .Began else { return }
        
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
        
        let annotationView = sender as! MKAnnotationView
        
        let location = annotationView.annotation as! Location
       
        let controller = segue.destinationViewController as! LocationDetailViewController
        
        controller.location       = location
        controller.managedContext = managedContext        
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {        
        
        for annotation in views
        {
            animateAnnotation(annotation)
        }
        
    }
    
}

