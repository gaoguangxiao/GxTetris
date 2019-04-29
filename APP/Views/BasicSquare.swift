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
            self.isSelected = newValue
        }
    }
    
//    //扩展一个选中的图片展示
    //1.0.2加入多种颜色的方块
    @available(iOS, introduced: 1.0.1, deprecated: 1.0.1, message: "setBelownewImage is deprecated. Use setSquareSelectImage  instead")
    func setBelownewImage(image:UIImage)  {
        print(self.isSelectSquare)
        print(image)
    }
    
    //需要扩展
//    var selectbackImage: UIImage {
//        return self.currentBackgroundImage!
//    }
    
    //更新选中的图片状态，
    func setSquareSelectImage(image:UIImage,nomalImage:UIImage)  {
        self.setBackgroundImage(image, for: UIControl.State.selected)
//        self.setBackgroundImage(nomalImage, for: UIControlState.normal)

    }
   
}
class BasicSquare: UIButton {
    
    var internalType :NSInteger = 0 //定义方块类型，提示方块、移动方块是22、给绿色
    
    //该属性1.0.2版本之后弃用
    var internalImage : UIImage!//定义方块图片
    
    init(frame: CGRect,type:NSInteger) {
        super.init(frame: frame)
        internalType = type
        if internalType == 11 {
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.3).cgColor
        
        }
        //test
        self.titleLabel?.font = UIFont.systemFont(ofSize: 7)
      
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //1.0.2
//    MARK:- newShowPic is deprecated. Use setSquareSelectImage  instead
    func newShowPic(image:UIImage)  {
        internalImage = image
//        print("%d",self.isSelectSquare)
        self.setBackgroundImage(internalImage, for: UIControl.State.selected)
        self.setBackgroundImage(nil, for: UIControl.State.normal)

//        print(image)
    }
    
    //指定颜色1.0.0
    override func select(_ sender: Any?){

//       self.setBackgroundImage((sender as!Bool)?:internalImage:nil, for: UIControlState.normal)
        //随机取出一种颜色
        self.setBackgroundImage(internalImage, for: UIControl.State.selected)
        self.setBackgroundImage(nil, for: UIControl.State.normal)
//        self.setBackgroundImage(UIImage.init(named: "star_b"), for: UIControlState.selected)
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
