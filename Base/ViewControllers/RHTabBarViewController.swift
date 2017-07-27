//
//  RHTabBarViewController.swift
//  乐科图
//
//  Created by ggx on 2017/7/5.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

class RHTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = GameStartViewController()
        //设置导航栏为指引项
        let homeNavi = UINavigationController.init(rootViewController: home)
        
        
        
        let item1 : UITabBarItem = UITabBarItem (title: "首页", image: UIImage(named: "tabbarDingdan_hui"), selectedImage: UIImage(named: "tabbarDingdan"))
        home.tabBarItem = item1


        
        self.viewControllers = [homeNavi]
        // Do any additional setup after loading the view.
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
