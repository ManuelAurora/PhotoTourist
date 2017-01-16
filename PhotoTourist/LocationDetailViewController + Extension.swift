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
        
        collectionView.backgroundColor = UIColor.white
        
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
            array.append(fetchController.object(at: item) as! ImageForCell)
        }
        
        for item in array
        {
            managedContext.delete(item)
        }
        
        try! managedContext.save()
        
        selectedIndexPaths = [IndexPath]()        
    }
    
    func registerNibs() {
        
        let cellNib = UINib(nibName: "ItemCell", bundle: nil)
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: "ItemCell")
    }
    
    func setupMapViewCenterCoordinate() {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        mapView.setZoomByDelta(0.1, animated: true)
        
        mapView.setCenter(coordinate, animated: false)
        
        mapView.addAnnotation(location)
        
        mapView.isZoomEnabled            = false
        mapView.isScrollEnabled          = false
        mapView.isUserInteractionEnabled = false
    }
    
    func removeActivityIndicator(_ indicator: UIActivityIndicatorView) {
        
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    
    func changeItemsInContent() {
        
            collectionView.performBatchUpdates({
                
                for indexPath in self.deleteIndexPaths
                {
                    self.collectionView.deleteItems(at: [indexPath as IndexPath])
                }
                
                self.deleteIndexPaths = [IndexPath]()
                
                for indexPath in self.insertIndexPaths
                {
                    self.collectionView.insertItems(at: [indexPath as IndexPath])
                }
                
                self.insertIndexPaths = [IndexPath]()
                
                for indexPath in self.updateIndexPaths
                {
                    self.collectionView.reloadItems(at: [indexPath as IndexPath])
                }
                
                self.updateIndexPaths = [IndexPath]()
                
            }) { _ in
                
                self.updateCollectionButton()
            }
    }
    
    func removeAllItemsForLocation() {
        
        for element in location.images
        {
            let image = element as! ImageForCell
            
            managedContext.delete(image)
        }
        
        try! managedContext.save()
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
        
        if !newCollectionButton.isEnabled { enableCollectionButton() }
    }
    
    func hideLabel(_ notHaveItems: Bool) {
        
        noImagesLabel.isHidden = !notHaveItems
        
    }
    
    func enableCollectionButton() {
        
        var counter = 0
        
        for image in location.images
        {
            let image = image as! ImageForCell
            
            if image.loaded { counter += 1 }
        }
        
        if counter == location.images.count { newCollectionButton.isEnabled = true }
    }
    
    func CreateAndConfigureCell(forIndexPath indexPath: IndexPath) -> ItemCell {
        
        let imageForCell = fetchController.fetchedObjects![indexPath.row] as! ImageForCell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        if imageForCell.image != nil
        {
            cell.imageView.image = imageForCell.image!
            
            removeActivityIndicator(cell.activityIndicator)
        }
        else
        {
            if let data = imageForCell.imageData
            {                
                removeActivityIndicator(cell.activityIndicator)
                
                let image = UIImage(data: data)
                
                cell.imageView.image = image
                
                imageForCell.loaded = true
            }
        }
           
        return cell
     
    }
}
