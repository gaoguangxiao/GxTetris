//
//  UIView+Extension.swift
//  GxTetris
//
//  Created by ggx on 2017/7/24.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    var x:CGFloat? {
        get {
            return self.frame.origin.x
        }set {
            var temp = self.frame
            temp.origin.x = newValue!
            self.frame = temp
        }
    }
    
    var y: CGFloat? {
        get {
            return self.frame.origin.y
        }set {
            var temp = self.frame
            temp.origin.y  = newValue!
            self.frame = temp
        }
    }
    
    var width: CGFloat? {
        get {
            return self.frame.size.width
        }
        set {
            var temp = self.frame
                temp.size.width = newValue!
                self.frame = temp
        }
    }
    
    var height: CGFloat? {
        get {
            return self.frame.size.height
        }
        set {
            var temp = self.frame;
            temp.size.height = newValue!;
            self.frame = temp;
        }
    }
    
    var centerX: CGFloat? {
        get {
            return self.center.x
        }
        set {
            var temp = self.center;
            temp.x = newValue!
            self.center = temp;
        }
    }
    
    var centerY: CGFloat? {
        get {
            return self.center.y
        }
        set {
            var temp = self.center;
            temp.y = newValue!
            self.center = temp;
        }
    }
    
    var size: CGSize? {
        get {
            return self.frame.size
        }
        set {
            var temp = self.frame;
            temp.size = newValue!
            self.frame = temp;
        }
    }

    var origin: CGPoint? {
        get {
            return self.frame.origin
        }
        set {
            var temp = self.frame;
            temp.origin = newValue!
            self.frame = temp;
        }
    }
}
