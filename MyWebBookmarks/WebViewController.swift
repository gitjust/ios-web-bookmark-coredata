//
//  WebViewController.swift
//  MyWebBookmarks
//
//  Created by Justinus Andjarwirawan on 11/25/16.
//  Copyright © 2016 Petra Christian University. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var theURL: String?
    
    @IBOutlet weak var webScreen: UIWebView!
    
    func displayURL() {
        print("Opening \(theURL!)")
        let myURLString = theURL!
        let myURL = NSURL(string: myURLString)
        let myURLRequest = NSURLRequest(url: myURL! as URL)
        
        webScreen.loadRequest(myURLRequest as URLRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayURL()
    }

}
