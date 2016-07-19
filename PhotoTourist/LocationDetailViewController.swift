//
//  LocationDetailViewController.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class LocationDetailViewController: UIViewController, UICollectionViewDelegate
{
    var location:       Location!
    var managedContext: NSManagedObjectContext!
    
    var updateIndexPaths = [NSIndexPath]()
    
    var fetchController: NSFetchedResultsController {
       
        return createAndConfigureFetchController()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    @IBAction func refresh(sender: AnyObject) {
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       makeCustomLayout()
    }
}

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















