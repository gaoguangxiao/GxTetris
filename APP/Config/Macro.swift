//
//  Macro.swift
//  GuessStone
//
//  Created by ggx on 2017/7/21.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import UIKit
class Macro: NSObject {
    
    
    //let CreateCell = value
    func CreateCell(xibName:String,owner: Any?) ->(UIView){
        return Bundle.main.loadNibNamed(xibName, owner: Any?.self, options: nil)?[0] as! (UIView)
    }
}
