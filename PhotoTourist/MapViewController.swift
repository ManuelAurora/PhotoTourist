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
    //MARK: * Variables *
    
    var managedContext: NSManagedObjectContext!
   
    var deletingPins: Bool = false    
  
    //MARK: * Outlets *
    
    @IBOutlet weak var editDoneButton: UIButton!
    @IBOutlet weak var editMapView:    UIView!
    @IBOutlet weak var mapView:        MKMapView!
    
    //MARK: * Actions() *
    
    @IBAction func edit(sender: AnyObject) {
     
        toggleDeletion()
    }
    
    //MARK: * Overrided Functions() *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setZoomByDelta(0.7, animated: true)
        
        let locations = fetchLocations()
        
        mapView.addAnnotations(locations)
        
        addGestures()
        
        centerMapView()
    }
    
    //MARK: * Functions() *
    
    func handlePressure(gestureRecognizer: UIGestureRecognizer) {        
        
        guard gestureRecognizer.state == .Began else { return }
        
        let location = getLocation(fromGesture: gestureRecognizer)
        
        FlickrClient.sharedInstance().fetchDataForLocation(location: location)
        
        mapView.addAnnotation(location)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if deletingPins
        {
            deleteLocationView(view)
        }
        else
        {
            showDetails(view)
            mapView.deselectAnnotation(view.annotation!, animated: true)
        }
        
    }
    
    func showDetails(annotation: MKAnnotationView) {
        
        performSegueWithIdentifier("ShowPhoto", sender: annotation)
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {        
        
        for annotation in views
        {
            animateAnnotation(annotation)
        }
    }
    
    //MARK: * Segues *
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let annotationView = sender as! MKAnnotationView
        
        let location = annotationView.annotation as! Location
        
        let controller = segue.destinationViewController as! LocationDetailViewController
        
        controller.location       = location
        controller.managedContext = managedContext
    }
    
}

