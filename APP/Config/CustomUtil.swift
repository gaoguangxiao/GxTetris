//
//  CustomUtil.swift
//  EagleFastSwift
//
//  Created by ggx on 2017/7/18.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit


let U_TOKEN = "TOKEN"
let USER_DEFAULT = UserDefaults.standard

class CustomUtil: NSObject {

    //是否登陆
    static func isUserLogin() -> Bool {
        if (USER_DEFAULT.value(forKey: U_TOKEN) != nil){
            return true
        }else {
            return false
        }
    }
    
    static func saveAcessToken(token : String) {
        USER_DEFAULT.set(token, forKey: U_TOKEN)
        USER_DEFAULT.synchronize()
    }
    
    static func getToken() -> String {
       return USER_DEFAULT.value(forKey: U_TOKEN) as! String
    }
    
    static func deleteToken(){
        USER_DEFAULT.removeObject(forKey: U_TOKEN)
    }
}
