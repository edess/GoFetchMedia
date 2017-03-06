//
//  MyWebViewController.swift
//  GoFetchMedia
//
//  Created by Edess Akpa on 3/5/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit

class MyWebViewController: UIViewController,UIWebViewDelegate {
    
    
    @IBOutlet weak var myWebView: UIWebView!
    //@IBOutlet weak var theGoBtn: UIButton!
    
    //variables
    let the_clientId: String = "1652363d257f4909a3f1f153b68e9c33"
    let the_redirect_uri: String = "http://ubi-lab.naist.jp/" // my laboratory website url
    var theRealToken = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

       myWebView.delegate = self
        
        
        
        self.myWebView.loadRequest(URLRequest(url: URL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(the_clientId)&redirect_uri=\(the_redirect_uri)&response_type=token&scope=basic+public_content+follower_list+comments+relationships+likes")!))
        
        print("[MyWebViewController] request sent")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //get the your redirect_uri with the access_token in the url fragment, sent bt Instagram API: Client-Side (Implicit) Authentication
        let the_requested_uri: String = request.url!.absoluteString
        print("the_redirect_uri = \(the_requested_uri)")
        
       
        
        if( the_requested_uri.contains("#access_token=")){
            print("zeToken= \(the_requested_uri.components(separatedBy: "#access_token=").last)")
            let theAccessToken = the_requested_uri.components(separatedBy: "#access_token=").last!
            print("theAccessToken = \(theAccessToken)")
            
            // save token_id in the default memory of the app
            UserDefaults.standard.set(theAccessToken, forKey: "token_id")
            UserDefaults.standard.synchronize()
            
            // go to the view to display the iamges
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aViewCont = storyboard.instantiateViewController(withIdentifier: "showImage_id")
            self.present(aViewCont, animated: true, completion: nil)
            
            
        }
        else{
            print("no_token_in_uri")
        }
        
        
        return true
    }
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let theTargetUrl = webView.request?.url
        print("theTargetUrl = \(theTargetUrl)")
        

    }

   
}

