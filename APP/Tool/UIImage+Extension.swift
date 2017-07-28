//
//  UIImage+Extension.swift
//  GxTetris
//
//  Created by ggx on 2017/7/28.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation

import UIKit

//
extension UIImage{
    
    //传入最高分，以及用户等级，返回用户应该有的标示,扩展类仅仅处理图片，根据用户等级返回对应图片
    func setNickName(userRange:Int) -> UIImage {
        //总共30个等级，后一个等级下限是前一个等级上限的500*2^(n-1)当前等级需要，依次类推，最高等级分数
        
        //1、计算当前用户等级需要的积分，是否大于所处等级所需要的积分，
//        let upLevelScore = 500 * pow(2,userRange - 1)
//        let upLevelScore = 1000 * (userRange + 1)
        
        //        print("升级需要分数处理之前%d",upLevelScore)
        //        let upLevelScoreString = NSString(format:"%d",upLevelScore as CVarArg).integerValue
        //        print("升级需要分数处理之后%d",upLevelScoreString)
        //        2、如果满足，对用户进行升级处理，否则直接返回，不进行更新
        let imageArrys = CreateWithImageInRect(imageName: UIImage.init(named: "badge_call")!)
//        if bestScoreSave > upLevelScore {
            //做错误处理，当用户等级过高，返回最高等级头衔
//            if userRange >= 30 {
                return imageArrys[userRange]
//            }else{
//                return imageArrys[userRange + 1]
//            }
//        }else{
//            //不对用户头衔进行更新，返回当前的头衔
//            return imageArrys[userRange]
//        }
        //        print(imageArrys)
        
    }
    
    //将图片分隔成数组
    func CreateWithImageInRect(imageName:UIImage) -> Array<UIImage>{
        
        var imageAray :[UIImage] = []
        let imageWidth  = imageName.size.width/5
        let imageHeight = imageName.size.height/6
        for j in 0..<6 {
            for i in 0..<5{
                let imageRect = CGRect(x:CGFloat(i) * imageWidth,y:CGFloat(j) * imageHeight,width: imageWidth,height:imageHeight)
                //                print(imageRect)
                let cgRef = imageName.cgImage
                let imageRef = cgRef!.cropping(to: imageRect)
                let thumbScale = UIImage.init(cgImage: imageRef!)
                imageAray.append(thumbScale)
            }
        }
        
        return imageAray
        
    }
    
    class var selectStarImage: UIImage {
        get {
            let random = Int(arc4random_uniform(UInt32(5)))
            let picture = [UIImage.init(named: "star_b"),
                           UIImage.init(named: "star_g"),
                           UIImage.init(named: "star_p"),
                           UIImage.init(named: "star_r"),
                           UIImage.init(named: "star_y")]
            
            return  picture[random]!;
        }
    }
}
