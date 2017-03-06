//
//  FetchMediaViewController.swift
//  GoFetchMedia
//
//  Created by Edess Akpa on 3/6/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage
import Alamofire 


class FetchMediaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var myTableview_Media: UITableView!
    
    // Tables
    var TableData_textCaption: Array< String > = Array < String >()
    var TableData_imageLinks: Array< String > = Array < String >()
    var TableData_numberOfLIke: Array< Int > = Array < Int >()
    var TableData_numberOfComments: Array< Int > = Array < Int >()
    var TableData_mediaID: Array< String > = Array < String >()
    var TableData_PosterUsername: Array< String > = Array < String >()
    var TableData_PosterProfilePic_link: Array< String > = Array < String >()
    
    
    // other variables
    let getRecentMedaiUrl = "https://api.instagram.com/v1/users/self/media/recent/?access_token" //Get the most recent media published by the owner of the access_token.
    
    //By specifying a placeholder image, the image view uses the placeholder
    //image until the remote image is downloaded
    let placeholderImage = UIImage(named: "profile_pic")!
    var refreshControl = UIRefreshControl()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the token from the default memory
        let the_token_id = UserDefaults.standard.value(forKey: "token_id")
        print("[FetchMediaViewController] the_token_id = \(the_token_id)")
        get_data_from_url("\(getRecentMedaiUrl)=\(the_token_id!)")
        
        
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(FetchMediaViewController.refresh), for: UIControlEvents.valueChanged)
        self.myTableview_Media?.addSubview(refreshControl)
    }
    
    func refresh(){
        
        
        //reload tableview
        myTableview_Media.reloadData()
        
        
        //stop refreshing
        refreshControl.endRefreshing()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData_imageLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let my_cell = myTableview_Media.dequeueReusableCell(withIdentifier: "cell_media", for: indexPath) as! CustomCellMedia
        
        // fill custom cell elements using the data in the Tables
        my_cell.lbl_text.text = TableData_textCaption[indexPath.row]
        my_cell.lbl_NumberOfLike.text = "\(TableData_numberOfLIke[indexPath.row])"
        my_cell.lbl_NumberOfComment.text = "\(TableData_numberOfComments[indexPath.row])"
        
        //download the posted image using AlamofireImage
        if let postedImageURL = URL(string: TableData_imageLinks[indexPath.row]){
            
            my_cell.IV_postedImage.af_setImage(withURL: postedImageURL, placeholderImage: placeholderImage) //if image not found for any reason, replace it by the default placeholder
        
        }
        else{
            print("no image link found")
        }
        
        //manage the Comment button of cell
        my_cell.BtnSeeComments.tag = indexPath.row
        my_cell.BtnSeeComments.addTarget(self, action: #selector(FetchMediaViewController.detailsToDisplayComments(sender:)), for: .touchUpInside)
        
        
        return my_cell
        
    }
    
    
    // function that will charge all neccesairy data from the FetchMediaViewController to display when the
    //comment button of each cell is pushed
    func detailsToDisplayComments(sender: AnyObject){
        
        let the_button : UIButton = sender as! UIButton
        
        let the_mediaID_ofSelectedImage = self.TableData_mediaID[the_button.tag]
        let poster_profile_picture_link = self.TableData_PosterProfilePic_link[the_button.tag]
        let poster_username = self.TableData_PosterUsername[the_button.tag]
        let poster_textCaptionHastag = self.TableData_textCaption[the_button.tag]
        let posted_image_link = self.TableData_imageLinks[the_button.tag]

        
        
        //save in user default
        UserDefaults.standard.set(poster_profile_picture_link, forKey: "posterProfile")
        UserDefaults.standard.set(poster_username, forKey: "posterName")
        UserDefaults.standard.set(poster_textCaptionHastag, forKey: "posterText")
        UserDefaults.standard.set(posted_image_link, forKey: "postedImage")
        UserDefaults.standard.set(the_mediaID_ofSelectedImage, forKey: "media_id")
        UserDefaults.standard.synchronize()
        
        print("poster_profile_picture_link = \(poster_profile_picture_link)")
        print("poster_username = \(poster_username)")
    
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
          
        })
        
        task.resume()
        
    }
    
    
    // function to extract data
    func extract_json(_ data: Data)
    {
        
        
        let myNewJson = JSON(data: data)
        
        let all_Data = myNewJson["data"].arrayValue
        print("allTeamArray ==== \(all_Data)")
        
        DispatchQueue.main.async(execute: {
            for each_data in all_Data
            {
                let textOrCaption = each_data["caption"]["text"].stringValue
                //let image_Link = each_data["images"]["low_resolution"]["url"].stringValue  // low resolution image
                let image_Link = each_data["images"]["standard_resolution"]["url"].stringValue // standard resolution
                let numb_Of_Like = each_data["likes"]["count"].intValue
                let numb_Of_Comment = each_data["comments"]["count"].intValue
                let media_ID = each_data["id"].stringValue
                let poster_Username = each_data["caption"]["from"]["username"].stringValue
                let poster_ProfilePic = each_data["caption"]["from"]["profile_picture"].stringValue
                
                print( "text: \(textOrCaption); numberOfLike = \(numb_Of_Like); numberOfComments = \(numb_Of_Comment); media_ID = \(media_ID) ;image_Link: \(image_Link); \nposter_Username = \(poster_Username); poster_ProfilePic = \(poster_ProfilePic) " )
                
                self.TableData_textCaption.append(textOrCaption)
                self.TableData_imageLinks.append(image_Link)
                self.TableData_numberOfLIke.append(numb_Of_Like)
                self.TableData_numberOfComments.append(numb_Of_Comment)
                self.TableData_mediaID.append(media_ID)
                self.TableData_PosterUsername.append(poster_Username)
                self.TableData_PosterProfilePic_link.append(poster_ProfilePic)
                
                
            }
            DispatchQueue.main.async(execute: {self.do_table_refresh()})
        })
        
        
        
    }
    
    func do_table_refresh()
    {
       
        
        self.myTableview_Media.reloadData()
        
    }

}


