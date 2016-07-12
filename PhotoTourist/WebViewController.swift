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


class WebViewController: OAuthWebViewController
{
    var webView : UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = view.bounds
        webView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        webView.scalesPageToFit = true
        view.addSubview(webView)
       
    }
    
    override func handle(url: NSURL) {
        
        let req = NSURLRequest(URL: url)
        webView.loadRequest(req)
        
        
    }
}

