//
//  LocationDetailViewController.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import Alamofire

class LocationDetailViewController: UIViewController, UICollectionViewDelegate
{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var location: Location!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset            = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumLineSpacing      = 2
        layout.minimumInteritemSpacing = 2
        
        let width = floor((self.collectionView.frame.size.width / 3) - 6)
        
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView.collectionViewLayout = layout
    }
    
    
}

extension LocationDetailViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return location.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        location.images.count
        let image = location.images[indexPath.row]
        
        cell.imageView.image = image
        
        return cell
        
    }
    
    
}