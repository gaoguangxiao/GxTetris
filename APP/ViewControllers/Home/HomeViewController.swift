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

let leftmargin = 5
let topMargin = 5

let kRowCount = 20 //20 高度保持440
let kColumnCount = 11
let kSquareWH  = 22

let upLevel = 10//控制消行的升级问题


class HomeViewController: UIViewController {
    
    @IBOutlet weak var scoreField: UITextField!
    @IBOutlet weak var lineCountField: UITextField!
    @IBOutlet weak var levelField: UITextField!
    
    
    @IBOutlet weak var _squareRoomView: UIView!//方块区域
    @IBOutlet weak var tipBoardView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var _edgeRotateOffset :CGFloat = 0.0 //选装溢出补偿
    
    var group : SquareGroup!
    
    var dropDownTimer : Timer! //下落计时，每次点击下拉
    var panMoveTimer  :Timer!//拖曳手势操作俄罗斯方块
    
    var keepMoveTimer :Timer!//按住按钮持续下移
    var refreshTimer  :Timer!//刷新动画计时器
    
    var disableButtonActions :Bool! //采取禁用按钮禁用
    var startPoint : CGPoint!
    var isSettingMode :Bool!//设置模式。1-设置。0移动
    
    var clearedLines :Int! = 0//消除行数
    var levelUpCounter :Int = 0//积满20行升级
    var bestScore      :Int = 0//最高分
    var score          :Int = 0//当前得分
    
    var speedLevel   :Int! = 0//速度级别
    var startupLines :Int! = 0//起始行数
    
    
    
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
        startPoint = CGPoint(x:kSquareWH * 4 + leftmargin,y:0 + topMargin)
        
        score = 0
        scoreField.text = String(format:"%d",score)
        speedLevel = 1
        lineCountField.text = String(format:"%d",clearedLines)
        levelField.text     = String(format:"%ld",speedLevel)
        isSettingMode = true
    }
    
    func setupUI(){

        let  count = kColumnCount * kRowCount
        for i in 0..<count {
            let square = BasicSquare.init(frame: CGRect(x:i % kColumnCount * kSquareWH + leftmargin,y:i / kColumnCount * kSquareWH + topMargin,width:kSquareWH
                ,height:kSquareWH),type: 11)
            _squareRoomView.addSubview(square)
            
            /// test
//            square.setTitleColor(UIColor.orange, for: UIControlState.normal)
//            square.setTitle(String(format: "%d", i), for: UIControlState.normal)
            
        }
        
        group = SquareGroup.init(frame: CGRect(x:0 + leftmargin,y: 0 + topMargin,width:kSquareWH * 4,height:kSquareWH * 4))
        _squareRoomView.addSubview(group)
        
        let selectShow = group.tipBoard()
//        print(NSStringFromCGRect(selectShow.frame))
        tipBoardView.addSubview(selectShow)
        
    }
    
    
    //    MARK:定时器
    func destroyTimer(timer :Timer)  {
        timer.invalidate()
    }
    func setupDropDownTimer() {
        var duartion : Double
        if speedLevel == 1 {
            duartion = 1.0
        }else if speedLevel == 2{
            duartion = 0.9
        }else if speedLevel == 3{
            duartion = 0.8
        }else if speedLevel == 4{
            duartion = 0.7
        }else{
            //5
            let duarationString = NSString(format:"%d",speedLevel)
            duartion = 1.0 - (duarationString.doubleValue * 0.1)
        }
        dropDownTimer = Timer.scheduledTimer(timeInterval:duartion, target: self, selector: #selector(down(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(dropDownTimer, forMode: RunLoopMode.commonModes)
    }
    //添加手势拖动
    @IBAction func PanKeepMove(_ sender: UIPanGestureRecognizer) {
        //加下滑手势、直接倒地
//        let rectw = sender.translation(in: _squareRoomView)
//        print(rectw.x)
        
    }
    
    
    //保持持续移动
    @IBAction func setupKeepMoveTimer(_ sender: UILongPressGestureRecognizer) {
        var controlAction = #selector(down(_:))
        var duration = 0.0
        let index = Int((sender.view?.tag)!)
        
        switch index {
        case 11:
            controlAction = #selector(left(_:))
            duration = 0.1
        case 33:
            controlAction = #selector(down(_:))
            duration = 0.03
        default:
            controlAction = #selector(right(_:))
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
    @IBAction func left(_ sender: UIButton) {
        //        print("点了")
        if isPauseState(){
            //            print("暂停")
        }else{
            if canMoveLeft() {
                self.group.x = self.group.x! - CGFloat(kSquareWH)
                //                print("向左移动")
            }else{
                //                print("不可向左移动")
            }
        }
        
    }
    
    
    @IBAction func right(_ sender: UIButton) {
        if isPauseState(){
//            print("暂停")
        }else{
            if self.canMoveRight() {
//                print("向右移动")
                self.group.x =  self.group.x! + CGFloat(kSquareWH);
            }else{
//                print("不可向右移动")
            }
        }
        
    }
    @IBAction func down(_ sender: UIButton) {
        //2、判断是否可移动
        if canMoveDown() {
            self.group.y = self.group.y! + CGFloat(kSquareWH)
            //            print(self.group.y!)
            //销毁没有执行到位
            destroyTimer(timer: self.dropDownTimer)
            //
            setupDropDownTimer()
        }else{
            //test
            //print("不可移动")
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
        self.group.isHidden = true
        //1、记录最高分
        clearedLines = 0
        scoreField.text = "0"
        score = 0
        lineCountField.text = "0"
        //        levelField.text = "0"
        //2、销毁定时器
        destroyTimer(timer: self.dropDownTimer)
        //3、刷新动画
        if #available(iOS 10.0, *) {
            commitRefreshAnimation()
        } else {
            // Fallback on earlier versions
        }
        //4、设置
        isSettingMode = true
    }
    //刷新动画
    @available(iOS 10.0, *)
    func commitRefreshAnimation()  {
        
        //起始刷新位置
        var startIndex = kColumnCount * kRowCount - 1
        var screenColor = true
        
        //屏幕变白
        func refreshWhite(){
            var rI = startIndex
            //            print("变白方法\(rI)")
            if rI > kColumnCount * kRowCount - 1 {
                print("销毁")
                destroyTimer(timer: refreshTimer)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(0.5)), execute: {
                    //直接开始下一句游戏
                    self.startPlay()
                })
                
                return
            }else{
                var j = (startIndex + kColumnCount)
                
                //修复一下bug，以防游戏结束 程序崩溃
                if rI <= 0 {
                    rI = 0
                    j = 11
                }
                
                //rI用于将方块变色
                while rI  < j {
                    let square = _squareRoomView.subviews[rI]as!BasicSquare
                    square.isSelectSquare = false
                    
                    rI = rI + 1
                }
                startIndex = rI

            }
            
        }
        //屏幕变黑
        func refresh() {
            var i = startIndex
            if i < 0,screenColor{
                screenColor = false
                
                startIndex = 0
                //销毁
                destroyTimer(timer: refreshTimer)
                //重建
                refreshTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true, block: { (timer) in
                    refreshWhite()
                })
                RunLoop.current.add(refreshTimer, forMode: RunLoopMode.commonModes)
                
            }else{
                let j = (startIndex - kColumnCount)
                while i > j,i>=0{
                    let square = _squareRoomView.subviews[i]as!BasicSquare
                    square.isSelectSquare = true
                    
                    i = i - 1
                }
                startIndex = i
            }
            
        }
        //刷新动画
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true, block: { (timer) in
            refresh()
        })
        RunLoop.current.add(refreshTimer, forMode: RunLoopMode.commonModes)
    }
    //消行、
    func clearFullLines() {
        //1、获取应该消除的行
        let linesShouldClear = LineArrayWaitForClear()
        //2、添加一个消除行的动画
        for i in 0..<linesShouldClear.count {
            let tempLinex =  linesShouldClear[i]
            
            for index in 0..<(tempLinex as AnyObject).count {
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
        //4、进行分数计算
        calcScoreAndSpeedLevel(clearedCount: linesShouldClear.count)
        
        //5、判断游戏是否结束
        if isOver() {
            //
            gameOverOperaton()
        }else{
            self.group.backToStartPoint(startPoint: startPoint)
            setupDropDownTimer()
        }
        
        
    }
    //进行计分，提高速度级别
    func calcScoreAndSpeedLevel(clearedCount:Int)  {
        //分数增加
        clearedLines = clearedLines + clearedCount
        //消行总数
        levelUpCounter = levelUpCounter + clearedCount
        
        if clearedCount > 0 {
            let calScore = clearedCount == 1 ? 100 : (clearedCount == 2 ? 300 : (clearedCount == 3 ? 600 : 1000));
            
            score = score + calScore
        }
        //调整等级
        if speedLevel < 6,levelUpCounter>=upLevel {
            speedLevel = speedLevel + 1
            levelUpCounter = levelUpCounter - upLevel
        }
        //显示消除的行数
        lineCountField.text = String(format: "%d",levelUpCounter)
        //显示分数
        scoreField.text = String(format: "%d",score)
        //显示级别
        levelField.text = String(format: "%ld",speedLevel)
    }
    //找出需要消除的行
    func LineArrayWaitForClear() -> NSMutableArray{
        //找出刚落下的组合对应的都是第几行
        
        var lineMaybeFull_Arr :Array<Int> = [];
        for i in 0..<self.group.subviews.count {
            let square = self.group.subviews[i]as!BasicSquare
            if square.isSelectSquare {
                let rect2 = _squareRoomView.convert(square.frame, from: self.group)
                let Y = Int(rect2.origin.y)/kSquareWH
                
                if Y>=0 {
                    if lineMaybeFull_Arr.contains(where: { (member) -> Bool in
                        return member  == Y
                    }) {
                    }else{
                        lineMaybeFull_Arr.append(Y)
                    }
                    
                }
                
            }
        }
        //test
        //        print(lineMaybeFull_Arr)
        
        //拿到这些行里面的所有按钮的索引
        let indexArrays = NSMutableArray()
        
        for i in 0..<lineMaybeFull_Arr.count {
            let Y = lineMaybeFull_Arr[i]
            //
            var indexArrayForALine :[Int] = []
            for j in 0..<kColumnCount {
                let index = Y * kColumnCount + j
                indexArrayForALine.append(index)
            }
            indexArrays.add(indexArrayForALine)
        }
        
        //判断其中某一行是不是填充满了
        var notFullLines :[Any] = []
        
        for i in 0..<indexArrays.count {
            //数组
            let indexArr = (indexArrays[i])as! NSArray
            
            var notFullFlag = 0
            //查询一行是否都被选择，一旦其中一个未被选择，就会添加进notFullLines数组
            for j in 0..<indexArr.count {
                
                let squareIndex = indexArr[j] as! Int
                
                let square = _squareRoomView.subviews[squareIndex]as!BasicSquare
                if square.isSelectSquare {
                    
                }else{
                    notFullFlag = 1
                }
            }
            
            //
            if notFullFlag == 1{
                notFullLines.append(indexArr)
            }
            
        }
        
        //只保留满行的数组
        indexArrays.removeObjectsInArray(array: notFullLines)
        
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
    
    //    MARK:设置
    //重玩
    @IBAction func rePlay(_ sender: UIButton) {
        if isSettingMode {
            startPlay()
        }else{
            convertGroupSquareToBlack()
            gameOverOperaton()
        }
        
    }

    //开始游戏
    func startPlay() {
        //
        isSettingMode = false
        self.group.isHidden  = false
        //2、设置提示起始点
        self.group.backToStartPoint(startPoint: startPoint)
        //3、设置下落时间
        setupDropDownTimer()
        //4、设置起始行
        configRandomLines()
    }
    //设置起始行
    func configRandomLines()  {
        if startupLines == 0 {
            return
        }
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
