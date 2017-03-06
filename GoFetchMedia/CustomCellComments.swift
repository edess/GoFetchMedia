//
//  CustomCellComments.swift
//  GoFetchMedia
//
//  Created by Edess Akpa on 3/6/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CustomCellComments: UITableViewCell {
    
    @IBOutlet weak var UI_commentator_profilePic: UIImageView!
    @IBOutlet weak var lbl_commentatorName: UILabel!
    @IBOutlet weak var lbl_commentatorComment: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
