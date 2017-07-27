
//
//  UIColor+Extension.swift
//  GxTetris
//
//  Created by ggx on 2017/7/27.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

extension UIColor{
    
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    //指定的下落颜色
    class var botomSelectColor: UIColor {
        get {
            let red   = CGFloat(85/255.0)
            let green = CGFloat(145/255.0)
            let blue  = CGFloat(34/255.0)
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    static func SelectColor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        let red   = CGFloat(red/255.0)
        let green = CGFloat(green/255.0)
        let blue  = CGFloat(blue/255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
