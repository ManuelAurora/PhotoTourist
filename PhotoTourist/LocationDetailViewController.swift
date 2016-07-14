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
    
    @IBAction func refresh(sender: AnyObject) {
        collectionView.reloadData()
    }
    
    var location: Location!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ItemCell", bundle: nil)
        let loadNib = UINib(nibName: "DownloadingCell", bundle: nil)
        
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "ItemCell")
        collectionView.registerNib(loadNib, forCellWithReuseIdentifier: "DownloadingCell")
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
    
}

extension LocationDetailViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return location.images.count
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let imageForCell = location.images[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.imageView.image = imageForCell.image
       
        
        return cell
    }
    
}