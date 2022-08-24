//
//  LiveStreamCollectionViewCell.swift
//  SwirlFramework
//
//  Created by Pinkesh Gajjar on 17/08/22.
//

import UIKit

protocol LiveStreamCCDelegate {
    
    func btnSelectCell(index: Int)
    func btnShareLink(index: Int)
}

class LiveStreamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnSelectCell: UIButton!
    @IBOutlet weak var imgViewThumbnail: DesignableImageView!
    @IBOutlet weak var btnShareLink: UIButton!
    @IBOutlet weak var lblLiveStreamName: UILabel!
    @IBOutlet weak var viewLiveLabel: DesignableView!
    @IBOutlet weak var lblLiveStatus: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    var delegate: LiveStreamCCDelegate! = nil
    var objectOfLiveStream: LiveStream? = nil
    
    func configCell() {
        
        self.imgViewThumbnail.loadImage(imageUrl: self.objectOfLiveStream?.cover_img, placeHolder: "ph_swirl", isCache: true, contentMode: .scaleAspectFill)
        
        if self.tag == 0 {
            print("From configCell : ", self.tag)
            self.viewLiveLabel.backgroundColor = UIColor(hex: "#EE3445")
            self.lblLiveStatus.text = "Live"
        } else {
            print("From configCell :: ", self.tag)
            self.viewLiveLabel.backgroundColor = UIColor(hex: "#000000")
            self.lblLiveStatus.text = "20th Aug"
        }
        
        if let streamTitle = self.objectOfLiveStream?.title {
            self.lblLiveStreamName.text = streamTitle
        } else {
            self.lblLiveStreamName.text = "---"
        }
    }
    
    @IBAction func btnSelectCell(_ sender: UIButton) {
        
        self.delegate.btnSelectCell(index: sender.tag)
    }
    
    @IBAction func btnShareLink(_ sender: UIButton) {
        
        self.delegate.btnShareLink(index: sender.tag)
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        
        
    }
}
