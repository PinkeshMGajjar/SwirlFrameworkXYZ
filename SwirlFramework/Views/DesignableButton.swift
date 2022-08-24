//
//  DesignableButton.swift
//  HaHaApp
//
//  Created by Atirek Pothiwala on 30/05/18.
//  Copyright © 2018 Atirek Pothiwala. All rights reserved.
//
import UIKit
@IBDesignable class DesignableButton : UIButton {
    
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
    
    @IBInspectable var imageTintColor: UIColor! = nil {
        didSet {
            let image = self.currentImage?.withRenderingMode(.alwaysTemplate)
            self.tintColor = imageTintColor
            self.setImage(image, for: .normal)
        }
    }
    
    @IBInspectable var isShadowEnabled : Bool = false {
        didSet {
            if !isShadowEnabled {
                self.layer.masksToBounds = true
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
            } else {
                self.layer.masksToBounds = false
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                self.layer.shadowOpacity = 0.7
                self.layer.shadowRadius = 5
            }
            
        }
    }
}
