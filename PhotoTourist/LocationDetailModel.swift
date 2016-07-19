//
//  LocationModel.swift
//  PhotoTourist
//
//  Created by Мануэль on 19.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

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
    
}