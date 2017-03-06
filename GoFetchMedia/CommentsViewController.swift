//
//  CommentsViewController.swift
//  GoFetchMedia
//
//  Created by Edess Akpa on 3/6/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var TableView_Comments: UITableView!
    
    @IBOutlet weak var UI_posterProfilePic: UIImageView!
    @IBOutlet weak var lbl_posterName: UILabel!
    @IBOutlet weak var lbl_posterCaptionText: UILabel!
    @IBOutlet weak var UI_PostedImage: UIImageView!
    
    //tables to hold the data about comments
    var TableData_CommentatorName: Array< String > = Array < String >()
    var TableData_Commentator_PhotoLinks: Array< String > = Array < String >()
    var TableData_Commentator_comment: Array< String > = Array < String >()
    
    //variables
    let placeholderImage = UIImage(named: "profile_pic")!
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //get the poster name
        //by checking first if posterName exist, we avoid crash in case when userdefault
        //return nil values
        
        if let posterName = UserDefaults.standard.value(forKey: "posterName"){
            
            lbl_posterName.text = posterName as? String
            
            
            //get the poster profile pic link from the user default and download the img
            let poster_profilePic_link = UserDefaults.standard.value(forKey: "posterProfile")
            //print("[CommentsViewController] poster_profilePic_link = \(poster_profilePic_link!)")
            let poster_photo_URL = URL(string: poster_profilePic_link as! String)
            UI_posterProfilePic.af_setImage(withURL: poster_photo_URL!)
            
            
            //get the posted image for which we want to see comments
            let posted_image_link = UserDefaults.standard.value(forKey: "postedImage")
            let posted_image_URL = URL(string: posted_image_link as! String)
            UI_PostedImage.af_setImage(withURL: posted_image_URL!)
            
            //get the text, caption, or hastag of the posted image
            let text_Hastag = UserDefaults.standard.value(forKey: "posterText")
            lbl_posterCaptionText.text = text_Hastag as? String
            
            // get the media_id, and execute the func get_data_from_url to fetch existing comments on the media
            let the_id_of_media = UserDefaults.standard.value(forKey: "media_id") as? String
            print("[CommentsViewController] the_id_of_media = \(the_id_of_media!)")
            
            //comment Endpoints URL = https://api.instagram.com/v1/media/{media-id}/comments?access_token=ACCESS-TOKEN
            // we also need to get the acces_token
            let the_token_id = UserDefaults.standard.value(forKey: "token_id")
            
            get_data_from_url("https://api.instagram.com/v1/media/\(the_id_of_media!)/comments?access_token=\(the_token_id!)")
        }
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(CommentsViewController.refresh), for: UIControlEvents.valueChanged)
        self.TableView_Comments?.addSubview(refreshControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(){
        
        
        //reload tableview
        TableView_Comments.reloadData()
        
        
        //stop refreshing
        refreshControl.endRefreshing()
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData_CommentatorName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let this_cell = self.TableView_Comments.dequeueReusableCell(withIdentifier: "cell_comments", for: indexPath) as! CustomCellComments
        
        this_cell.lbl_commentatorName.text = TableData_CommentatorName[indexPath.row]
        this_cell.lbl_commentatorComment.text = TableData_Commentator_comment[indexPath.row]
        
        if let commentator_photo_URL = URL(string: TableData_Commentator_PhotoLinks[indexPath.row]) {
            
            // download the commentator profile image
            this_cell.UI_commentator_profilePic.af_setImage(withURL: commentator_photo_URL, placeholderImage: placeholderImage)
            //this_cell.UI_commentator_profilePic.image?.af_imageRoundedIntoCircle()
        }
        
        
        return this_cell
    }
    
    
    // functon to get the data from URL
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            self.extract_json(data!)
            
            //let responseString = String(data: data!, encoding: .utf8)
            //print("[CommentsViewController] response String = \(responseString)")
        })
        
        task.resume()
    }
    
    
    // function to extract data
    func extract_json(_ data: Data)
    {
        
        
        let myNewJson = JSON(data: data)
        
        let allComments = myNewJson["data"].arrayValue
        print("all comments ==== \(allComments)")
        
        DispatchQueue.main.async(execute: {
            for comment in allComments
            {
                let commenator_name = comment["from"]["username"].stringValue
                let photo_Link = comment["from"]["profile_picture"].stringValue
                let commentator_comment = comment["text"].stringValue
                
                
                self.TableData_CommentatorName.append(commenator_name)
                self.TableData_Commentator_PhotoLinks.append(photo_Link)
                self.TableData_Commentator_comment.append(commentator_comment)
                
                
            }
            DispatchQueue.main.async(execute: {self.do_table_refresh()})
        })
        
        
        
    }
    
    func do_table_refresh()
    {
        
        self.TableView_Comments.reloadData()
        
    }


  

}
