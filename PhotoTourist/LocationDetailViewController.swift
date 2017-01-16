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
    
    var updateIndexPaths   = [IndexPath]()
    var selectedIndexPaths = [IndexPath]()
    var deleteIndexPaths   = [IndexPath]()
    var insertIndexPaths   = [IndexPath]()
    

    
    lazy var fetchController: NSFetchedResultsController <ImageForCell> = { _ in
        
        let fetchRequest = NSFetchRequest<ImageForCell>(entityName: "ImageForCell")
        let predicate    = NSPredicate(format: "location=%@", self.location)
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate       = predicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        try! controller.performFetch()
        
        return controller
    }()
    
    //MARK: * Outlets *
    
    
    @IBOutlet weak var mapView:             MKMapView!
    @IBOutlet weak var noImagesLabel:       UILabel!
    @IBOutlet weak var collectionView:      UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    //MARK: * Actions() *
    
    @IBAction func makeNewCollection(_ sender: UIBarButtonItem) {
        
        if sender.title == "New Collection"
        {
            sender.isEnabled = false
            
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
        
        hideLabel(collectionView.numberOfItems(inSection: 0) == 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeCustomLayout()
    }
    
    deinit{
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print("Error saving context")
        }
        
    }
}

//MARK: === EXTENSION -> UICollectionViewDataSource ===

extension LocationDetailViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = CreateAndConfigureCell(forIndexPath: indexPath)
        
        return cell
    }
}

//MARK: === EXTENSION -> UICollectionViewDelegate ===

extension LocationDetailViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCell
        
        if let index = selectedIndexPaths.index(of: indexPath)
        {
            selectedIndexPaths.remove(at: index)
            
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
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type
        {
        case .update:
                       
            updateIndexPaths.append(indexPath!)
            
        case .delete:
            
            deleteIndexPaths.append(indexPath!)
            
        case .insert:
            
            insertIndexPaths.append(newIndexPath!)
            
        case .move:
            print("Moved")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        changeItemsInContent()
        
    }    
    
}












