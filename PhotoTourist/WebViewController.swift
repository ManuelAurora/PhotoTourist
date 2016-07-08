//
//  WebViewController.swift
//  PhotoTourist
//
//  Created by Мануэль on 08.07.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

class WebViewController: UIViewController
{
    @IBOutlet weak var webView: UIWebView!
    
    
    
    
}

extension WebViewController: OAuthSwiftURLHandlerType
{
    func handle(url: NSURL) {
        
        let request = NSURLRequest(URL: url)
        
        self.webView.loadRequest(request)
             
    }    
    
}