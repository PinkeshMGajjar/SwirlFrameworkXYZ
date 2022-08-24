//
//  CommentCell.swift
//  LiveStreamDemo
//
//  Created by A.Live Mind on 07/09/20.
//  Copyright © 2020 ALiveMind. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var ivProfile: DesignableImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewLblMessage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //ivProfile.image = nil
    }
    
    func configCell(userId: String) {
        
        self.setLabelView()
        if userId == Constants.getUserDetails(key: "user_id") {
            self.viewLblMessage.alpha = 0.4
            self.viewLblMessage.backgroundColor = UIColor(named: "color_commentFB")
            self.lblMessage.textColor = UIColor.white
        } else {
            self.viewLblMessage.alpha = 0.6
            self.viewLblMessage.backgroundColor = UIColor(named: "color_commentFC")
            self.lblMessage.textColor = UIColor.black
        }
    }
    
    func setLabelView() {
        
        self.viewLblMessage.layer.cornerRadius = 5
    }

}
