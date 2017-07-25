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

let kRowCount = 20 //20 高度保持440
let kColumnCount = 11
let kSquareWH  = 22

class HomeViewController: UIViewController {
    @IBOutlet weak var _squareRoomView: UIView!//方块区域
    @IBOutlet weak var tipBoardView: UIView!
    
    
    @IBOutlet weak var pauseButton: UIButton!
    
    var _edgeRotateOffset :CGFloat = 0.0 //选装溢出补偿
    
    var group : SquareGroup!
    let speedLevel :NSInteger! = 0//速度级别
    var dropDownTimer : Timer! //下落计时，每次点击下拉
    var keepMoveTimer :Timer!//按住按钮持续下移
    
    var startPoint : CGPoint!
    var isSettingMode :Bool!//设置模式。1-设置。0移动
    
    //    @property (strong, nonatomic) NSTimer *dropDownTimer;       // 下落计时 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "俄罗斯方块"
        self.navigationController!.navigationBar.isTranslucent = false;
        
        
        setupUI()
        
        initConfigs()
        
        //test
        startPlay()
        
    }
    
    func initConfigs() {
        startPoint = CGPoint(x:kSquareWH * 4,y:0)
        
        isSettingMode = true
    }
    
    func setupUI(){
        
        //        let kSquareWH = NSInteger(kScreenWidth - 130)/kColumnCount
        //        let kRowCount = NSInteger(_squareRoomView.bounds.size.height)/kSquareWH
        //设置几个fang'kuai
        let  count = kColumnCount * kRowCount
        for i in 0..<count {
            let square = BasicSquare.init(frame: CGRect(x:i % kColumnCount * kSquareWH,y:i / kColumnCount * kSquareWH,width:kSquareWH
                ,height:kSquareWH),type: 11)
            //            square.isSelected = false
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
    
    
    //    MARK:定时器
    func destroyTimer(timer :Timer)  {
        timer.invalidate()
        
        //        dropDownTimer = nil
        //        timer = nil
    }
    func setupDropDownTimer() {
        //        let duartion = 1.0 * pow(0.75, (self.speedLevel - 1))
        dropDownTimer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(down(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(dropDownTimer, forMode: RunLoopMode.commonModes)
    }
    //保持持续移动
    @IBAction func setupKeepMoveTimer(_ sender: UILongPressGestureRecognizer) {
        var controlAction = #selector(down(_:))
        var duration = 0.0
        let index = Int((sender.view?.tag)!)
        
        switch index {
        case 11:
            controlAction = #selector(left(_sender:))
            duration = 0.1
        case 33:
            controlAction = #selector(down(_:))
            duration = 0.03
        default:
            controlAction = #selector(right(_sender:))
            duration = 0.1
        }
        
        
        if keepMoveTimer == nil {
            keepMoveTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: controlAction, userInfo: nil, repeats: true)
            RunLoop.current.add(keepMoveTimer, forMode: RunLoopMode.commonModes)
        }
        
        
        if (sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled) {
            
            keepMoveTimer.invalidate();
            self.keepMoveTimer = nil;
            
        }
    }
    
    
    //    MARK:控制
    @IBAction func left(_sender :Any){
        
        if isPauseState(){
            print("暂停")
        }else{
            if canMoveLeft() {
                self.group.x = self.group.x! - CGFloat(kSquareWH)
                
            }
        }
    }
    
    
    @IBAction func right(_sender :Any){
        if isPauseState(){
            print("暂停")
        }else{
            if self.canMoveRight() {
                self.group.x =  self.group.x! + CGFloat(kSquareWH);
            }
        }
        
        
    }
    
    //下
    @IBAction func down(_ sender: Any) {
        
        
        //2、判断是否可移动
        if canMoveDown() {
            self.group.y = self.group.y! + CGFloat(kSquareWH)
            print(self.group.y!)
            //销毁没有执行到位
            destroyTimer(timer: self.dropDownTimer)
            setupDropDownTimer()
        }else{
            //            print("不可移动")
            convertGroupSquareToBlack()
            
            clearFullLines()
        }
        
    }
    @IBAction func rotate(_ sender: UIButton) {
        if isPauseState() {
            
        }else{
            self.group.rotate(canRotate:
                {(nextGoup) -> Bool in
                    return canRotate(nextGroup: nextGoup as! Array<Int>)
            })
        }
    }
    
    //    MARK:游戏中
    //将落下的方块固定
    func convertGroupSquareToBlack() {
        //取消下落倒计时
        destroyTimer(timer: self.dropDownTimer)
        //固定已经下落的组合
        for i in 0..<self.group.subviews.count{
            let square = self.group.subviews[i]as!BasicSquare
            if square.isSelectSquare {
                //查看squear在父视图的rect
                let rect2 = _squareRoomView.convert(square.frame, from: self.group)
                if rect2.origin.y>=0 {
                    let X = Int(rect2.origin.x)/kSquareWH
                    let Y = Int(rect2.origin.y)/kSquareWH
                    
                    let indexOfBelowSquare = Y * kColumnCount + X
                    //                    print(indexOfBelowSquare)//将这几个方块变化颜色
                    let  belowSquare = _squareRoomView.subviews[indexOfBelowSquare] as!BasicSquare
                    belowSquare.isSelectSquare = true
                    
                }
            }
        }
    }
    //游戏结束后的操作
    func gameOverOperaton()  {
        print("游戏结束")
        //1、记录最高分
        
        //2、销毁定时器
        destroyTimer(timer: self.dropDownTimer)
        //3、刷新动画
        
        //4、
    }
    //消行、
    func clearFullLines() {
        //1、获取应该消除的行
        let linesShouldClear = LineArrayWaitForClear()
        //2、添加一个消除行的动画
        for i in 0..<linesShouldClear.count {
            let tempLinex =  linesShouldClear[i]as!NSArray
            
            for index in 0..<tempLinex.count {
                let square = _squareRoomView.subviews[index] as!BasicSquare
                square.isSelectSquare  = false
            }
        }
        
        //3、消失行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(0.5))) {
            for i in 0..<linesShouldClear.count{
                let squareLine = linesShouldClear[i]as!NSArray
                let lastSquareIndex = squareLine.lastObject as!Int
                for j in (0..<lastSquareIndex).reversed() {
                    let lastLineSquare = self._squareRoomView.subviews[j]as!BasicSquare
                    if j >= kColumnCount {
                        let aboveSquare = self._squareRoomView.subviews[j - kColumnCount]as!BasicSquare
                        lastLineSquare.isSelectSquare = aboveSquare.isSelectSquare
                    }else{
                        lastLineSquare.isSelectSquare  = false
                    }
                }
                
            }
            
        }
        //4、判断游戏是否结束
        if isOver() {
            gameOverOperaton()
        }else{
            self.group.backToStartPoint(startPoint: startPoint)
            setupDropDownTimer()
        }
        
        
    }
    //找出需要消除的行
    func LineArrayWaitForClear() -> Array<Any> {
        //找出刚落下的组合对应的都是第几行
        
        //这样初始化
        var lineMaybeFull_Arr :Array<Int> = [];
        
        
        for i in 0..<self.group.subviews.count {
            let square = self.group.subviews[i]as!BasicSquare
            if square.isSelectSquare {
                let rect2 = _squareRoomView.convert(square.frame, from: self.group)
                let Y = Int(rect2.origin.y)/kSquareWH
                
                if Y>=0 {
                    if lineMaybeFull_Arr.contains(where: { (member) -> Bool in
//                        print(member)
                        
                        return member  == Y
                        }) {
                        
                    }else{
                        lineMaybeFull_Arr.append(Y)
                    }
                    
                }
                
            }
        }
        
        
        //拿到这些行里面的所有按钮的索引
        var indexArrays : Array<Any> = []
        
        for i in 0..<lineMaybeFull_Arr.count {
            let Y = lineMaybeFull_Arr[i]
            //
            var indexArrayForALine :[Int] = []
            for j in 0..<kColumnCount {
                let index = Y * kColumnCount + j
                indexArrayForALine.append(index)
            }
            
            indexArrays.append(indexArrayForALine)
        }
        
        //判断其中某一行是填充
        var notFullLines :[Any] = []
        
        for i in 0..<indexArrays.count {
            //数组
            let indexArr = (indexArrays[i])as! NSArray

            var notFullFlag = 0
            for j in 0..<indexArr.count {
                
                let squareIndex = indexArr[j] as! Int
                
                let square = _squareRoomView.subviews[squareIndex]as!BasicSquare
                if square.isSelectSquare {
                    
                }else{
                    notFullFlag = 1
                }
            }
            
            if notFullFlag == 1{
                notFullLines.append(indexArr)
            }
            
        }
        //        indexArrays.removeob
        //        indexArrays.removeObjects(in: [notFullLines])
        
        //        indexArrays.remove
        //        var delArr1 = ["123", "456", 1, 3]
        //        let index = indexArrays.index(of: notFullLines)
        
        //        indexArrays.index(of: notFullLines)
        //        indexArrays.removeObject(at: index)
        
        return indexArrays
        
        
    }
    //    MARK:判断
    //是否可以左移动
    func canMoveLeft() -> Bool {
        for i in 0..<self.group.subviews.count{
            let square = self.group.subviews[i]as!BasicSquare
            
            if square.isSelectSquare {
                //查看squear在父视图的rect
                let rect2 = _squareRoomView.convert(square.frame, from: self.group)
                let X = Int(rect2.origin.x)/kSquareWH
                let Y = Int(rect2.origin.y)/kSquareWH
                
                if X == 0 { return false}
                
                if Y >= 0 {
                    //获取它下方的块是否是选择状态 获取 Y
                    let indexOfBelowSquare = Y * (kColumnCount) + X - 1
                    
                    let  belowSquare = _squareRoomView.subviews[indexOfBelowSquare] as!BasicSquare
                    if belowSquare.isSelectSquare{
                        return false
                    }
                }
                
            }
        }
        return true
    }
    //是否可以移动
    func canMoveRight() -> Bool {
        for i in 0..<self.group.subviews.count{
            let square = self.group.subviews[i]as!BasicSquare
            
            if square.isSelectSquare {
                //查看squear在父视图的rect
                let rect2 = _squareRoomView.convert(square.frame, from: self.group)
                let X = Int(rect2.origin.x)/kSquareWH
                let Y = Int(rect2.origin.y)/kSquareWH
                
                
                if X == kColumnCount - 1 { return false}
                
                if Y >= 0 {
                    //获取它下方的块是否是选择状态 获取 Y
                    let indexOfBelowSquare = Y * (kColumnCount) + X + 1
                    
                    let  belowSquare = _squareRoomView.subviews[indexOfBelowSquare] as!BasicSquare
                    if belowSquare.isSelectSquare{
                        return false
                    }
                }
            }
        }
        return true
    }
    //是否可以下移动
    func canMoveDown() -> Bool {
        for i in 0..<self.group.subviews.count{
            let square = self.group.subviews[i]as!BasicSquare
            
            if square.isSelectSquare {
                //查看squear在父视图的rect
                let rect2 = _squareRoomView.convert(square.frame, from: self.group)
                //            print(rect2.origin.y)
                if rect2.origin.y>=0 {
                    let X = Int(rect2.origin.x)/kSquareWH
                    let Y = Int(rect2.origin.y)/kSquareWH
                    //判断是否到底部
                    if Y == kRowCount - 1{
                        return false
                    }
                    //获取它下方的块是否是选择状态 获取 Y
                    let indexOfBelowSquare = (Y + 1)  * (kColumnCount) + X
                    
                    let  belowSquare = _squareRoomView.subviews[indexOfBelowSquare] as!BasicSquare
                    if belowSquare.isSelectSquare{
                        return false
                    }
                }
            }
            
        }
        return true
    }
    //是否可以旋转
    func canRotate(nextGroup:Array<Int>) -> Bool {
        for i in 0..<nextGroup.count {
            let index = Int(nextGroup[i])
            let square = self.group.subviews[index]
            let squareRect = _squareRoomView.convert(square.frame, from: self.group)
            
            let X = Int(squareRect.origin.x) / kSquareWH;
            let Y = Int(squareRect.origin.y) / kSquareWH;
            
            if X < 0 {
                _edgeRotateOffset = CGFloat(-X * kSquareWH);
            }else if X >= kColumnCount{
                _edgeRotateOffset = CGFloat((kColumnCount - X - 1) * kSquareWH);
            }
            
            if Y >= kRowCount {
                return false;
            }
            
            // 重合判断
            if Y >= 0 {
                let indexOfBehindSquare = Y * kColumnCount + X;
                let behindSquare = _squareRoomView.subviews[indexOfBehindSquare] as!BasicSquare
                if behindSquare.isSelectSquare{
                    return false;
                }
            }
            
        }
        return true
    }
    //判断游戏状态
    func isPauseState() -> Bool {
        if self.pauseButton.isSelected {//暂停状态
            setupDropDownTimer()
            self.pauseButton.isSelected = false
            
            return true
        }else{
            
            
            return false
        }
    }
    //游戏是否结束
    func isOver() -> Bool {
        for i in 0..<kColumnCount {
            let square = _squareRoomView.subviews[i]as!BasicSquare
            if square.isSelectSquare {
                return true
            }
        }
        return false
    }
    //冲完
    @IBAction func rePlay(_ sender: UIButton) {
        
        startPlay()
    }
    
    //    MARK:设置
    //开始游戏
    func startPlay() {
        //
        isSettingMode = false
        //2、设置提示起始点
        self.group.backToStartPoint(startPoint: startPoint)
        //3、设置下落时间
        setupDropDownTimer()
        //4、
    }
    //设置起始行
    func configRandomLines()  {
        
    }
    @IBAction func pause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            destroyTimer(timer: self.dropDownTimer)
        }else{
            setupDropDownTimer()
        }
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
