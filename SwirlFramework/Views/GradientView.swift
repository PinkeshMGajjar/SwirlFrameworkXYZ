//
//  GradientView.swift
//  GetNatty
//
//  Created by A.Live Mind on 27/01/20.
//  Copyright © 2020 GetNatty. All rights reserved.
//

import UIKit
@IBDesignable class GradientView : UIView {
    
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
    
    // the gradient start colour
    @IBInspectable var startColor: UIColor = UIColor.clear
    // the gradient end colour
    @IBInspectable var endColor: UIColor = UIColor.clear
    // the gradient angle, in degrees anticlockwise from 0 (east/right)
    @IBInspectable var angle: CGFloat = 270
    // the gradient layer
    private var gradient: CAGradientLayer? //8642E6 6351C5

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.installGradient()
        self.updateGradient()
    }

    // Create a gradient and install it on the layer
    private func installGradient() {
        // if there's already a gradient installed on the layer, remove it
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }

    // Update an existing gradient
    private func updateGradient() {
        if let gradient = self.gradient {
            gradient.colors = [self.startColor.cgColor, self.endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
        }
    }

    // create gradient layer
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    // create vector pointing in direction of angle
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        //let start = pointForAngle(angle+180.0)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    // get a point corresponding to the angle
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (abs(x) > abs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }

    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }

    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
}
