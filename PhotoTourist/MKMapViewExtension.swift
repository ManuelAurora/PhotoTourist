//
//  MKMapViewExtension.swift
//  PhotoTourist
//
//  Created by Мануэль on 12.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import MapKit

extension MKMapView {
    
    func setZoomByDelta(delta: Double, animated: Bool) {
        
        var zoomedRegion = self.region
        var span         = self.region.span
        
        span.latitudeDelta  *= delta
        span.longitudeDelta *= delta
        
        zoomedRegion.span = span
        
        setRegion(zoomedRegion, animated: animated)
    }
}