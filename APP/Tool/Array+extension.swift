//
//  Array+extension.swift
//  GxTetris
//
//  Created by ggx on 2017/7/25.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation



extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object: object)
        }
    }
}
