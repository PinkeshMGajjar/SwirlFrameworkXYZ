//
//  DesignableView.swift
//  HaHaApp
//
//  Created by Atirek Pothiwala on 30/05/18.
//  Copyright © 2018 Atirek Pothiwala. All rights reserved.
//

import UIKit
@IBDesignable class DesignableView : UIView {
    
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
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var dashedBorderColor : UIColor! = nil {
        didSet {
            self.clipsToBounds = true
            let border = CAShapeLayer()
            border.strokeColor = dashedBorderColor.cgColor
            border.lineDashPattern = [5, 5]
            border.frame = self.bounds
            border.fillColor = nil
            border.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(border)
        }
    }
    

    @IBInspectable var isShadowEnabled : Bool = false {
        didSet {
            if !isShadowEnabled {
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
            } else {
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                self.layer.shadowOpacity = 0.7
                self.layer.shadowRadius = 5
            }
            
        }
    }

}


