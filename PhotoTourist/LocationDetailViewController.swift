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

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func refresh(sender: AnyObject) {
        collectionView.reloadData()
    }
    
    var location: Location!    
    
    var updateIndexPaths = [NSIndexPath]()
    
    lazy var fetchController: NSFetchedResultsController = {
       
        let fetchRequest = NSFetchRequest(entityName: "ImageForCell")
        
        let predicate = NSPredicate(format: "location=%@", self.location)
        
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = predicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance().context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        try! controller.performFetch()
        
        return controller
    }()    
    
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
        
        let imageForCell = fetchController.fetchedObjects![indexPath.row] as! ImageForCell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        if imageForCell.image != nil
        {
            cell.imageView.image = imageForCell.image!
            
            removeActivityIndicator(cell.viewWithTag(666) as! UIActivityIndicatorView)
        }
        else
        {
            if let data = imageForCell.imageData
            {
                
                removeActivityIndicator(cell.viewWithTag(666) as! UIActivityIndicatorView)
                
                let image = UIImage(data: data)
              
                cell.imageView.image = image
            }
        }
        
        return cell
    }
}

extension LocationDetailViewController: NSFetchedResultsControllerDelegate
{
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type
        {
        case .Update:
            print("Updated")
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















