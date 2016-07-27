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
    
    func deleteBlurredItems() {
        
        var array = [ImageForCell]()
        
        for item in selectedIndexPaths
        {
            array.append(fetchController.objectAtIndexPath(item) as! ImageForCell)
        }
        
        for item in array
        {
            managedContext.deleteObject(item)
        }
        
        selectedIndexPaths = [NSIndexPath]()        
    }
    
    func registerNibs() {
        
        let cellNib = UINib(nibName: "ItemCell", bundle: nil)
        
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "ItemCell")
    }
    
    func setupMapViewCenterCoordinate() {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        mapView.setZoomByDelta(0.1, animated: true)
        
        mapView.setCenterCoordinate(coordinate, animated: false)
        
        mapView.addAnnotation(location)
        
        mapView.zoomEnabled            = false
        mapView.scrollEnabled          = false
        mapView.userInteractionEnabled = false
    }
    
    func removeActivityIndicator(indicator: UIActivityIndicatorView) {
        
        indicator.hidden = true
        indicator.stopAnimating()
    }
    
    func changeItemsInContent() {
        collectionView.performBatchUpdates({
            
            for indexPath in self.deleteIndexPaths
            {
                self.collectionView.deleteItemsAtIndexPaths([indexPath])
            }
            
            self.deleteIndexPaths = [NSIndexPath]()
            
            for indexPath in self.insertIndexPaths
            {
                self.collectionView.insertItemsAtIndexPaths([indexPath])
            }
            
            self.insertIndexPaths = [NSIndexPath]()
            
            for indexPath in self.updateIndexPaths
            {
                self.collectionView.reloadItemsAtIndexPaths([indexPath])
            }
            
            self.updateIndexPaths = [NSIndexPath]()
            
        }) { _ in
            
            self.updateCollectionButton()
            
            self.newCollectionButton.enabled = true
        }
    }
    
    func removeAllItemsForLocation() {
    
        for element in location.images
        {
            let image = element as! ImageForCell
            
            managedContext.deleteObject(image)
        }
        
    }
    
    func updateCollectionButton() {
        
        if selectedIndexPaths.count > 0
        {
            newCollectionButton.title = "Remove Selected Pictures"
        }
        else
        {
            newCollectionButton.title = "New Collection"
        }
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