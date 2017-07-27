//
//  CustomUtil.swift
//  EagleFastSwift
//
//  Created by ggx on 2017/7/18.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit


let U_TOKEN = "TOKEN"
let U_RBESTSCORE = "BESTSCORE"
let U_SOUNDSTATUS = "SOUNDSTATUS"

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
    
    //存储音效控制、开关音乐
    static func saveSoundSet(status:Bool) {
        USER_DEFAULT.set(status, forKey: U_SOUNDSTATUS)
        USER_DEFAULT.synchronize()
    }
    static func getSoundSet() -> Bool {
        if (USER_DEFAULT.value(forKey: U_SOUNDSTATUS) != nil) {
            return USER_DEFAULT.value(forKey: U_SOUNDSTATUS) as! Bool
        }else{
            return true
        }
    }
    
    //存储分数
    static func saveBestScore(score:Int){
        USER_DEFAULT.set(score, forKey: U_RBESTSCORE)
        USER_DEFAULT.synchronize()
    }
    //获取最高分
    static func getBestScore()->Int{
        if (USER_DEFAULT.value(forKey: U_RBESTSCORE) != nil) {
            return USER_DEFAULT.value(forKey: U_RBESTSCORE) as! Int
        }else{
            return 0
        }
        
    }
    
}
