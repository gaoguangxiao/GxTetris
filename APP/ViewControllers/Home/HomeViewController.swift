//
//  HomeViewController.swift
//  乐科图
//
//  Created by ggx on 2017/7/5.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

let kRowCount = 20 //20
let kColumnCount = 11
let kSquareWH  = 22

class HomeViewController: UIViewController {
    @IBOutlet weak var _squareRoomView: UIView!//方块区域
    @IBOutlet weak var tipBoardView: UIView!
    
    var group : SquareGroup!
    let speedLevel :NSInteger! = 0//速度级别
    var dropDownTimer = Timer()//下落计时
    var startPoint : CGPoint!
    
//    @property (strong, nonatomic) NSTimer *dropDownTimer;       // 下落计时 1
    
       override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "俄罗斯方块"
        self.navigationController!.navigationBar.isTranslucent = false;
        
        
        setupUI()

        initConfigs()
        
        
    }
    
    func initConfigs() {
        startPoint = CGPoint(x:kSquareWH * 4,y:0)
    }
    
    func setupUI(){
        //每一块的宽度 /11列
        //        let kSquareWH = NSInteger(kScreenWidth - 130)/kColumnCount
        //        let kRowCount = NSInteger(_squareRoomView.bounds.size.height)/kSquareWH
        //设置几个fang'kuai
        let  count = kColumnCount * kRowCount
        for i in 0..<count {
            let square = BasicSquare.init(frame: CGRect(x:i % kColumnCount * kSquareWH,y:i / kColumnCount * kSquareWH,width:kSquareWH
                ,height:kSquareWH),type: 11)
            square.select(false)
            _squareRoomView.addSubview(square)
            
            /// test
            square.setTitleColor(UIColor.orange, for: UIControlState.normal)
            square.setTitle(String(format: "%d", i), for: UIControlState.normal)
            
        }

        group = SquareGroup.init(frame: CGRect(x:0,y: 0,width:kSquareWH * 4,height:kSquareWH * 4))
        
        _squareRoomView.addSubview(group)
        
        let selectShow = group.setupview()
        
        tipBoardView.addSubview(selectShow)
        
    }
    //冲完
    @IBAction func rePlay(_ sender: UIButton) {
        startPlay()
    }
    //开始游戏
    func startPlay() {
        //2、设置提示起始点
        self.group .backToStartPoint(startPoint: startPoint)
        //3、设置下落时间
        setupDropDownTimer()
        
    }
//    MARK:定时器
    func destroyTimer(timer :Timer)  {
        timer.invalidate()
        
    }
    func setupDropDownTimer() {
//        let duartion = 1.0 * pow(0.75, (self.speedLevel - 1))
        dropDownTimer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(self.down), userInfo: nil, repeats: true)
    }

//    MARK:控制
    @IBAction func down(_ sender: Any) {
        
        //1、判断是否暂停
        
        //2、判断是否可移动
        self.group.y = self.group.y! + CGFloat(kSquareWH)
        print(self.group.y!)
//        if (sender != nil) {
            destroyTimer(timer: self.dropDownTimer)
            setupDropDownTimer()

//        }
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
