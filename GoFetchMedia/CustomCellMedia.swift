//
//  CustomCellMedia.swift
//  GoFetchMedia
//
//  Created by Edess Akpa on 3/6/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit

class CustomCellMedia: UITableViewCell {
    
    
    @IBOutlet weak var lbl_text: UILabel!
    @IBOutlet weak var IV_postedImage: UIImageView!
    @IBOutlet weak var lbl_NumberOfLike: UILabel!
    @IBOutlet weak var lbl_NumberOfComment: UILabel!
    @IBOutlet weak var BtnSeeComments: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
