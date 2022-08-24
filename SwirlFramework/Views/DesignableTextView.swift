//
//  DesignableTextView.swift
//  StarCanada
//
//  Created by Atirek Pothiwala on 11/10/19.
//  Copyright © 2019 Star Canada. All rights reserved.
//

import UIKit
@IBDesignable class DesignableTextView: UITextView {
    
    var limit: Int = 0 {
        didSet {
            self.updateCount()
        }
    }

    var lblCount: UILabel? = nil {
        didSet {
            self.updateCount()
        }
    }
    
    func updateCount(){
        if let lblCount = self.lblCount, limit > 0 {
            let count = self.text.count
            lblCount.text = "\(count)/\(self.limit)"
        }
    }
    
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
    
    @IBInspectable var placeHolderColor : UIColor = UIColor.lightText {
        didSet {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.textColor = placeHolderColor
            } else {
                self.addPlaceholder()
            }
        }
    }
    
    @IBInspectable var placeHolderText : String = String.init() {
        didSet {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = placeHolderText
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder()
            }
        }
    }

    @IBInspectable var paddingVertically : CGFloat = 0.0  {
        didSet {
            self.textContainerInset = UIEdgeInsets(top: paddingVertically, left: paddingHorizontally, bottom: paddingVertically, right: paddingHorizontally)
            //self.contentInset = UIEdgeInsets(top: paddingVertically, left: paddingHorizontally, bottom: paddingVertically, right: paddingHorizontally)
            self.resizePlaceholder()
        }
    }
    
    @IBInspectable var paddingHorizontally : CGFloat = 0.0  {
        didSet {
            self.textContainerInset = UIEdgeInsets(top: paddingVertically, left: paddingHorizontally, bottom: paddingVertically, right: paddingHorizontally)
            //self.contentInset = UIEdgeInsets(top: paddingVertically, left: paddingHorizontally, bottom: paddingVertically, right: paddingHorizontally)
            self.resizePlaceholder()
        }
    }
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainerInset.left + self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height// + CGFloat.greatestFiniteMagnitude
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            placeholderLabel.sizeToFit()
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder() {
        let placeholderLabel = UILabel()
        placeholderLabel.text = self.placeHolderText
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = self.font
        placeholderLabel.textColor = self.placeHolderColor
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

extension DesignableTextView: UITextViewDelegate {
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        self.updateCount()
    }
    
    public func refresh(){
        self.textViewDidChange(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.limit > 0 {
            return textView.text.count + (text.count - range.length) <= self.limit
        } else {
            return true
        }
    }
}
