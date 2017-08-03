//
//  GameStartViewController.swift
//  GxTetris
//
//  Created by ggx on 2017/7/27.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

class GameStartViewController: UIViewController {

    @IBOutlet weak var _soundSetting: UIButton!
    
    //1.0.2 增加隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "俄罗斯方块"
        // Do any additional setup after loading the view.
                
    }

    @IBAction func StartGame(_ sender: UIButton) {
        
        let V = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
        V.isNewGame = sender.tag == 0 ? true : false
        self.present(V, animated: true, completion: {
            
        })
//        self.navigationController?.pushViewController(V, animated: true)
        
    }
    
    //控制音效
    @IBAction func SoundSetting(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        AudioPlayer.play()
//        //选中状态是禁止播放
//        CustomUtil.saveSoundSet(status: !sender.isSelected)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
