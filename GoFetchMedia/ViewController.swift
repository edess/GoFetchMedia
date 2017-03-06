//
//  ViewController.swift
//  GoFetchMedia
//
//  Created by Edess Akpa on 3/5/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("[ViewController] view did load")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func BtnFlickrPushed(_ sender: UIButton) {
        print("BtnFlickr Pushed")
        
        displayMyAlertMessages("[Flickr] not available", alertMessage: "Sorry! Fetching from Flickr is not yet available. \nPlease wait for my next update. \n\nThank you!")
    }
    
    
    @IBAction func BtnPinterestPushed(_ sender: UIButton) {
        print("BtnPinterest Pushed")
        
        displayMyAlertMessages("[Pinterest] not available", alertMessage: "Sorry! Fetching from Pinterest is not yet available. \nPlease wait for my next update. \n\nThank you!")
    }
    
    // function for displaying the alert messages
    func displayMyAlertMessages(_ alertTitle:String, alertMessage:String){
        
        let myAlertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        myAlertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("alert message:\(alertMessage)")
            
            
            
        }))
        
        present(myAlertView, animated: true, completion: nil)
        
    }


}

