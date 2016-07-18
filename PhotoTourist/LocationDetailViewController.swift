//
//  LocationDetailViewController.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import Alamofire
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
        
        let cellNib = UINib(nibName: "ItemCell",        bundle: nil)
        let loadNib = UINib(nibName: "DownloadingCell", bundle: nil)
        
        collectionView.registerNib(loadNib, forCellWithReuseIdentifier: "DownloadingCell")
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "ItemCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset            = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumLineSpacing      = 2
        layout.minimumInteritemSpacing = 2
        
        let width = floor((collectionView.frame.size.width / 3) - 4)
        
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
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
    
    func removeActivityIndicator(indicator: UIActivityIndicatorView) {
        
        indicator.hidden = true
        indicator.stopAnimating()
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
        
        collectionView.performBatchUpdates({
            
            for path in self.updateIndexPaths
            {
                self.collectionView.reloadItemsAtIndexPaths([path])
            }
            
            }, completion: nil)
    }
}















