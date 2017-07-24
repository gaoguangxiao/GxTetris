//
//  UserCenterViewController.swift
//  乐科图
//
//  Created by ggx on 2017/7/5.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit
//import SQLite
//import Macro
//MARK: - ExitLoginDelegate代理方法
//MARK:-UIActionSheetDelegate
extension UserCenterViewController:UIActionSheetDelegate{

    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        let piker = UIImagePickerController.init()
        piker.delegate = self
        if buttonIndex == 1{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                piker.sourceType = UIImagePickerControllerSourceType.camera;
                 self.navigationController?.present(piker, animated: true, completion: nil)
            }else{
                _ = SweetAlert().showAlert("照相机不可用")
            }
           
            print("选择照相机")
        }else if buttonIndex == 2{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                piker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                 self.navigationController?.present(piker, animated: true, completion: nil)

            }else{
                _ = SweetAlert().showAlert("相册不可用")
            }
        }else{
            print("你点击了其他")
        }

    }
}
//MARK:-UIImagePickerControllerDelegate
extension UserCenterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let imageOriginal = info[UIImagePickerControllerOriginalImage]as!UIImage
        print(imageOriginal)
        let imageData = UIImageJPEGRepresentation(imageOriginal, 0.8)
        print(imageData!)
        
        //将图片信息存储在数据库
//        sqliteContext.insercolumnUserLogo(column: (imageData?.base64EncodedString())!)
        
        _userLogo.image = imageOriginal
//        let userInfo = sqliteContext.geuUserInfo(id: CustomUtil.getToken())
//        //更新用户的头像
//        sqliteContext.updateUserLogo(id: CustomUtil.getToken(), oldUserLogo: userInfo.loginUserLogo, userData: (imageData?.base64EncodedString())!)
        picker.dismiss(animated: true, completion: nil)
        
    }
}

class UserCenterViewController: ViewControllerImpl,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var _userLogo: UIImageView!
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var Score: UIButton!//分数
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "个人中心"
        //获取数据库，用户分数
        _userLogo.layer.cornerRadius = 40;
        
        _userLogo.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:#selector(tapAction) ))

         self.updateUserLocal()
        

         NotificationCenter.default.addObserver(self,selector:#selector(updateUserLocal),name: NSNotification.Name(rawValue: "UserLogin"), object: nil)
    }
    
    //用户切换登陆，更新用户信息
    func updateUserLocal() {
//        let userInfo = sqliteContext.geuUserInfo(id: CustomUtil.getToken())
        //需要查询数据库，用户的分数
//        Score .setTitle("分数：\(userInfo.loginScore)", for: UIControlState.normal)
//        userName .setTitle("玩家：\(userInfo.loginUserName)", for: UIControlState.normal)
        
//        let decodedData = NSData(base64Encoded: userInfo.loginUserLogo, options: NSData.Base64DecodingOptions.init(rawValue: 0))
//        _userLogo.image = UIImage.init(data: decodedData! as Data)

    }
    
    //点击头
    func tapAction(){
        let alertSheet = UIActionSheet(title: "选择头像", delegate:self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "选择照相机", "选择相册")
        alertSheet.show(in: self.view)
    }
    
    
    //注册cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = ["意见反馈","关于我们","为应用评分"][indexPath.row]
        return cell
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let exitView = Bundle.main.loadNibNamed("ExitFootView", owner: self, options: nil)?[0] as! ExitFootView
//        exitView.delegate = self
//        return exitView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40
//    }

    
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


