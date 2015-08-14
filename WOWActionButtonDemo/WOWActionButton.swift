//
//  WOWActionButton.swift
//  WOWActionButtonDemo
//
//  Created by Zhou Hao on 11/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

public class WOWActionButton: UIButton {

    // MARK: inspectable properties
    @IBInspectable private var indicator    : WOWActivityIndicator?
    
    @IBInspectable var indicatorPadding     : CGFloat = 2.0
    
    @IBInspectable var indicatorColor       : UIColor = UIColor.whiteColor() {
        didSet {
            indicator?.tintColor = indicatorColor
        }
    }
    @IBInspectable var cornerRadius         : CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth          : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor          : UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    // MARK: private variables
    private var actionInProgress            : Bool = false
    private var originalCornerRadius        : CGFloat = 0
    private var originalFrame               : CGRect = CGRectZero
    
    // MARK: - Overrides
    override public func prepareForInterfaceBuilder() {
    }
    
    public override func awakeFromNib() {
    }
    
    // MARK: public methods
    public func startAction() {
        
        if !actionInProgress {

 //           self.translatesAutoresizingMaskIntoConstraints = true
            self.titleLabel?.alpha = 0
            
/*
            let boundsSize = self.bounds.size.width > self.bounds.size.height ? CGSizeMake(self.bounds.size.height, self.bounds.size.height) : CGSizeMake(self.bounds.size.width, self.bounds.size.width)
            self.layer.cornerRadius = boundsSize.width / 2
            
            //self.bounds = CGRect(origin: CGPointZero, size: boundsSize)
            let animation = CABasicAnimation(keyPath: "bounds")
            animation.fromValue = NSValue(CGRect : self.bounds)
            animation.toValue = NSValue(CGRect : CGRect(origin: self.frame.origin, size: boundsSize))
            animation.delegate = self
            self.layer.bounds = CGRect(origin: self.frame.origin, size: boundsSize)
            self.layer.addAnimation(animation, forKey: "")
*/

            originalCornerRadius = cornerRadius
            originalFrame = frame
            
            let boundsSize = self.bounds.size.width > self.bounds.size.height ? CGSizeMake(self.bounds.size.height, self.bounds.size.height) : CGSizeMake(self.bounds.size.width, self.bounds.size.width)
            self.layer.cornerRadius = boundsSize.width / 2
            
            let anim = POPSpringAnimation(propertyNamed: kPOPViewBounds)
            anim.toValue = NSValue(CGRect: CGRect(origin: CGPointZero, size: boundsSize))
            anim.springSpeed = 20
            anim.springBounciness = 10
            anim.completionBlock = {
                (animation , finished) in
            }
            self.pop_addAnimation(anim, forKey: "morph")

            setupIndicator()
            indicator!.startAnimation()
            
            actionInProgress = true
            
        }
    }
    
    public func stopActionToExpand(toView: UIView) {
     
        if actionInProgress {
            
            removeIndicator()
            actionInProgress = false
            //self.titleLabel?.alpha = 1
                
            toView.clipsToBounds = true // don't allow the subview out of the boundary
            
            let anim = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            let offset = max(toView.bounds.width - self.bounds.origin.x/2, toView.bounds.height - self.bounds.origin.y/2)
            let scale = offset / (self.bounds.width/2)
            anim.toValue = NSValue(CGPoint: CGPointMake(scale, scale))
            anim.springSpeed = 20
            anim.springBounciness = 10
            self.pop_addAnimation(anim, forKey: "zooming")

            let anim2 = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            anim2.toValue = 0
            self.pop_addAnimation(anim2, forKey: "fadeout")
        }
        
    }
    
    public func stopActionToReset(animated: Bool) {
        
        if actionInProgress {
            
            removeIndicator()
            actionInProgress = false

            self.layer.cornerRadius = originalCornerRadius
            self.titleLabel?.alpha = 1
            
            if animated {
                
                let anim = POPSpringAnimation(propertyNamed: kPOPViewBounds)
                anim.toValue = NSValue(CGRect: CGRect(origin: CGPointZero, size: originalFrame.size))
                anim.springSpeed = 20
                anim.springBounciness = 10
                self.pop_addAnimation(anim, forKey: "morph")
                
            } else {
                
                self.frame = originalFrame                
            }
        }
    }
    
    // MARK: private memthods
    private func setupIndicator() {

        if indicator == nil {
            indicator = WOWActivityIndicator()
            addSubview(indicator!)
        }
        
        if self.frame.size.width > self.frame.size.height {
            let indicatorWidth = self.frame.size.height - 2 * indicatorPadding
            let frame = CGRectMake(indicatorPadding, indicatorPadding, indicatorWidth, indicatorWidth)
            indicator!.frame = frame
            
        } else {
            let indicatorWidth = self.frame.size.width - 2 * indicatorPadding
            let frame = CGRectMake(indicatorPadding, indicatorPadding, indicatorWidth, indicatorWidth)
            indicator!.frame = frame
        }

        indicator!.markerCount = 8
        indicator!.markerRadiusFactor = 0.5
        indicator!.tintColor = indicatorColor
        indicator!.thickness = 6
        indicator!.length = 6
        indicator!.padding = 0
        indicator!.scaleFactor = 0.05
        indicator!.isScaling = true
    }
    
    private func removeIndicator() {
        
        if indicator != nil {
            
            indicator!.removeFromSuperview()
            indicator = nil
            
        }
    }
}
