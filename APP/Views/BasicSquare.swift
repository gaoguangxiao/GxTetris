//
//  BasicSquare.swift
//  GxTetris
//
//  Created by ggx on 2017/7/24.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

extension UIButton{
    
    var isSelectSquare: Bool {
        get {
            return self.isSelected
        }
        set {
            select(newValue)
            self.isSelected = newValue
            

        }
    }
   
}
class BasicSquare: UIButton {
    
    var internalType :NSInteger = 0 //定义方块类型
    
    init(frame: CGRect,type:NSInteger) {
        super.init(frame: frame)
        internalType = type
        if internalType == 11 {
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        }else{
//            self.layer.borderWidth = 0.5
//            self.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        }

        //test
        self.titleLabel?.font = UIFont.systemFont(ofSize: 7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func select(_ sender: Any?){

        if internalType == 11 {
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha:(sender as!Bool) ? 0.8 : 0);
        }else if internalType == 22 {
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha:(sender as!Bool) ? 0.5 : 0);
        }
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
