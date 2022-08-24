//
//  DesignableImageView.swift
//  HaHaApp
//
//  Created by Atirek Pothiwala on 30/05/18.
//  Copyright © 2018 Atirek Pothiwala. All rights reserved.
//

import UIKit
@IBDesignable class DesignableImageView : UIImageView {
    
    @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var rotateAngle : CGFloat = 0.0 {
        didSet {
            self.transform = CGAffineTransform.init(rotationAngle: (rotateAngle * .pi) / 180)
        }
    }
    
    @IBInspectable var imageTintColor: UIColor! = nil {
        didSet {
            let image = self.image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = imageTintColor
            self.image = image
        }
    }
}
