//
//  LocationModel.swift
//  PhotoTourist
//
//  Created by Мануэль on 19.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.


import UIKit
import CoreData
import MapKit

extension LocationDetailViewController
{
    
    func makeCustomLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionView.backgroundColor = UIColor.whiteColor()
        
        layout.sectionInset            = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumLineSpacing      = 4
        layout.minimumInteritemSpacing = 2
        
        let width = floor((collectionView.frame.size.width / 3) - 4)
        
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView.collectionViewLayout = layout
    }
    
    func registerNibs() {
        
        let cellNib = UINib(nibName: "ItemCell",        bundle: nil)
       
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "ItemCell")
    }
    
    func setupMapViewCenterCoordinate() {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        mapView.setZoomByDelta(0.05, animated: true)
        
        mapView.setCenterCoordinate(coordinate, animated: false)
        
        mapView.addAnnotation(location)
    }
    
    func removeActivityIndicator(indicator: UIActivityIndicatorView) {
        
        indicator.hidden = true
        indicator.stopAnimating()
    }
    
    func reloadItems() {
        
        collectionView.performBatchUpdates({
            
            for path in self.updateIndexPaths
            {
                self.collectionView.reloadItemsAtIndexPaths([path])
            }
            
            }, completion: nil)
    }    
    
    func createAndConfigureFetchController() -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest(entityName: "ImageForCell")
        let predicate    = NSPredicate(format: "location=%@", self.location)
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate       = predicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance().context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        try! controller.performFetch()
        
        return controller
    }
    
    func CreateAndConfigureCell(forIndexPath indexPath: NSIndexPath) -> ItemCell {
        
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