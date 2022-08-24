//
//  PreviousStreamCollectionViewCell.swift
//  SwirlFramework
//
//  Created by Pinkesh Gajjar on 18/08/22.
//

import UIKit

class PreviousStreamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnSelectCell: UIButton!
    @IBOutlet weak var imgViewThumbnail: DesignableImageView!
    @IBOutlet weak var viewStreamTimeDate: DesignableView!
    @IBOutlet weak var lblStreamTimeDate: UILabel!
    @IBOutlet weak var btnShareLink: UIButton!
    @IBOutlet weak var lblLiveStreamName: UILabel!
    @IBOutlet weak var lblStreamDuration: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var viewContent: DesignableView!
    
    var objectOfLiveStream: LiveStream? = nil
    
    func configCell() {
        
        self.imgViewThumbnail.loadImage(imageUrl: self.objectOfLiveStream?.cover_img, placeHolder: "ph_swirl", isCache: true, contentMode: .scaleAspectFill)
        
        if let streamTitle = self.objectOfLiveStream?.title {
            self.lblLiveStreamName.text = streamTitle
        } else {
            self.lblLiveStreamName.text = "---"
        }
    }
    
    
    @IBAction func btnSelectCell(_ sender: UIButton) {
        
        
    }
    
    @IBAction func btnShareLink(_ sender: UIButton) {
        
        
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        
        
    }
    
}
