
//
//  AudioPlayer.swift
//  HappyPic
//
//  Created by ggx on 2017/7/17.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    private static var instance: AVAudioPlayer? = nil //static 直到被销毁 全局存在
    
//    var soundFileName :String
    static func share(soundFileName : String){
        do{
            let path =  Bundle.main.path(forResource: soundFileName, ofType: nil)
            let url = URL.init(fileURLWithPath: path!)
            try instance = AVAudioPlayer(contentsOf: url)
            instance?.play()
        }
        catch{
            instance=nil;
            print("error")
        }
        
//        return true
    }

    
    //播放
    static func play()->Bool{
        if (instance?.isPlaying)! {
            instance?.pause()
            return false
        }else{
            instance?.play()
            return true
        }
    }
    //是否在播放音乐
    static func isPlaying()->Bool{
        return (instance?.isPlaying)!
    }
    
}
