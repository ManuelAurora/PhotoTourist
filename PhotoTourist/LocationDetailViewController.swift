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

class LocationDetailViewController: UIViewController
{
    
    //MARK: * Variables *
    
    var location:       Location!
    var managedContext: NSManagedObjectContext!
    
    var updateIndexPaths   = [NSIndexPath]()
    var selectedIndexPaths = [NSIndexPath]()
    var deleteIndexPaths   = [NSIndexPath]()
    var insertIndexPaths   = [NSIndexPath]()
    
    lazy var fetchController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "ImageForCell")
        let predicate    = NSPredicate(format: "location=%@", self.location)
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate       = predicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        try! controller.performFetch()
        
        return controller
    }()
    
    //MARK: * Outlets *
    
    @IBOutlet weak var mapView:        MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    //MARK: * Actions() *
    
    @IBAction func makeNewCollection(sender: UIBarButtonItem) {
        
        if sender.title == "New Collection"
        {
            sender.enabled = false
            
            removeAllItemsForLocation()
            
            FlickrClient.sharedInstance().fetchDataForLocation(location: location)
        }
        else
        {
            deleteBlurredItems()
        }
    }
    
    //MARK: * Overrided Functions() *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapViewCenterCoordinate()
        registerNibs()
        updateCollectionButton()
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
        
        let sectionInfo = fetchController.sections![section]
                
        if sectionInfo.numberOfObjects > 15
        {
            return 15
        }
        else
        {
            return sectionInfo.numberOfObjects
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = CreateAndConfigureCell(forIndexPath: indexPath)        
        
        return cell
    }
}

//MARK: === EXTENSION -> UICollectionViewDelegate ===

extension LocationDetailViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ItemCell
        
        if let index = selectedIndexPaths.indexOf(indexPath)
        {
            selectedIndexPaths.removeAtIndex(index)
            
            cell.blurView.alpha = 0
        }
        else
        {
            selectedIndexPaths.append(indexPath)
            
            cell.blurView.alpha = 0.7
        }
        
        updateCollectionButton()
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
            
            deleteIndexPaths.append(indexPath!)
            
        case .Insert:
            
            insertIndexPaths.append(newIndexPath!)
            
        case .Move:
            print("Moved")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        changeItemsInContent()            
    }    
    
}












