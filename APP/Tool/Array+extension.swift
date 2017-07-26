//
//  Array+extension.swift
//  GxTetris
//
//  Created by ggx on 2017/7/25.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation



extension NSMutableArray{
    func removeObject(object: NSArray) {
        //1、判断是否包含
        if self.contains(object) {
            //2、移除
            self.remove(object)
        }
        
       
    }
    
    func removeObjectsInArray(array: Array<Any>) {
        for object in array {
            self.removeObject(object: object as! NSArray)
        }
    }
}
