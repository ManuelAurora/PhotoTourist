//
//  LocationDetailViewController.swift
//  PhotoTourist
//
//  Created by Manuel on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class LocationDetailViewController: UIViewController, UICollectionViewDelegate
{
    
    //MARK: * Variables *
    
    var location:       Location!
    var managedContext: NSManagedObjectContext!
    
    var updateIndexPaths = [NSIndexPath]()
    
    var fetchController: NSFetchedResultsController {
       
        return createAndConfigureFetchController()
    }
    
    //MARK: * Outlets *
    
    @IBOutlet weak var mapView:        MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK: * Actions() *
    
    @IBAction func refresh(sender: AnyObject) {
        collectionView.reloadData()
    }
    
    //MARK: * Overrided Functions() *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapViewCenterCoordinate()
        registerNibs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeCustomLayout()
    }
}

//MARK: === EXTENSION -> UICollectionViewDataSource ===

extension LocationDetailViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchController.fetchedObjects!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
      let cell = CreateAndConfigureCell(forIndexPath: indexPath)
        
        return cell
    }
}

//MARK: === EXTENSION -> NSFetchedResultsControllerDelegate ===

extension LocationDetailViewController: NSFetchedResultsControllerDelegate
{
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type
        {
        case .Update:
            
            updateIndexPaths.append(indexPath!)
            
        case .Delete:
            print("Deleted")
            
        case .Insert:
            print("Inserted")
            
            
        case .Move:
            print("Moved")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        reloadItems()
    }
}















