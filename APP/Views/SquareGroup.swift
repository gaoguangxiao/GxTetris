//
//  SquareGroup.swift
//  GxTetris
//
//  Created by ggx on 2017/7/24.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

class SquareGroup: UIView {
//    var tipView : UIView!
    
    var tipGroup : Array<Int>!
    var tipIndx  : NSInteger = 0
    var selectImage: UIImage!
    
    var group : Array<Int>!
    
    var tipView :UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //闭合区间 ...小余等于 ..<小余
        for i in 0..<16 {
            let square = BasicSquare.init(frame: CGRect(x:i % 4 * kSquareWH,y:i / 4 * kSquareWH,width:kSquareWH,height:kSquareWH),type: 22)
            self.addSubview(square)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tipBoard() -> UIView {
        tipView = setupview()
        return tipView;
    }
    
    private func setupview() ->UIView {
        tipView = UIView.init(frame: CGRect(x: 0,y: 0,width:4 * kSquareWH,height:2 * kSquareWH))
        for i in 0..<8 {
            let squareMask = BasicSquare.init(frame: CGRect(x:i % 4 * kSquareWH,y:i / 4 * kSquareWH,width:kSquareWH,height:kSquareWH),type: 22)
            tipView.addSubview(squareMask)
        }
        return tipView
    }
    

    //回到起始位置
    func backToStartPoint(startPoint:CGPoint) {
        //设置起始点
        self.origin  = startPoint
        //2、清空上次显示
        clearPrevGroup()
        //3、展示组合
        showCurrentGroup()
        //4、设置初始位置
        initPosition()
        //5、更新提示的View
        updateTipView()
    }
    
    //清空上次的显示
    func clearPrevGroup() {
        for squere in self.subviews {
            let squareM = squere as! BasicSquare
            squareM.isSelectSquare = false
        }
    }
    //显示组合
    func showCurrentGroup() {
        if self.tipGroup == nil {
            self.tipGroup = catchAnRandomGroup().first as! Array<Int>
        }
        
        self.group = self.tipGroup
        
        let randomData = catchAnRandomGroup()
        self.tipGroup = randomData.first as! Array<Int>
        
        self.tipIndx = (randomData.last as!Int)
    
        //这个获取的不一致啊
        self.selectImage = UIImage.selectStarImage
        
        for i in 0..<self.group.count {
            let index = self.group[i]
            let squareM = self.subviews[index]as!BasicSquare
            squareM.isSelectSquare = true

            squareM.setSquareSelectImage(image: selectImage, nomalImage: UIImage.init())
            
        }
    }
    
    //随机取出一个组合
    func catchAnRandomGroup() -> Array<Any> {
        let typesArray = types()
        
        //获取随机一个数值
        let bangIndex = arc4random_uniform(UInt32(typesArray.count));
//        let bangIndex = 3
//        print("组合大类：\(bangIndex)")

        //选取某一组形状
//        NSArray *randomBang = self.types[bangIndex];
        let randomBang = typesArray[Int(bangIndex)] as!Array<Any>
        //选取一组形状中的某一个
         let groupindex = arc4random_uniform(UInt32(randomBang.count));
//        let groupindex = 0
//        print("组合第几：\(groupindex)")
        //NSArray *randomGroup = randomBang[groupindex];
        let randomGroup = randomBang[Int(groupindex)]
 
        return [randomGroup, Int(bangIndex)];
    }
    
    //设置初始位置
    func initPosition() {
        var count = self.subviews.count - 1
        
        while count >= 0 {
            let lastSquare = self.subviews[count]as!BasicSquare
            if lastSquare.isSelectSquare {
                self.y = self.y! - lastSquare.y!
                return
            }
            count = count - 1
        }

    }
    
    func updateTipView() {
        //
        for squere in self.tipView.subviews {
            //将所有的置为 未选择状态
            let squareM = squere as! BasicSquare
            squareM.isSelectSquare = false
        }
        
        let tip = tipTypes()[self.tipIndx]as!Array<Int>


        for i in 0..<tip.count {
            let index = tip[i]
//            print(index)
            let square = self.tipView.subviews[index]as!BasicSquare
            square.isSelectSquare = true
            square.setSquareSelectImage(image: selectImage, nomalImage: UIImage.init())
//            square.internalImage  = self.selectImage
        }
        
    }
    
    //旋转的数据
    func rotate(canRotate:(_ nextGroup:NSArray) -> Bool){
    //找出包含待旋转的方块数组
        var array = NSArray()
        
        for i in 0..<self.types().count {
            let tempArray = self.types()[i]
            if (tempArray as AnyObject).contains(self.group) {
                array = tempArray as! NSArray
            }
        }
        
        //拿到该组合的索引，循环取出下一个组合
        let index = array.index(of: self.group)
        //该组合的索引+1取余
        let nextIndex = (index + 1)%array.count
        //下一组旋转的数据
        let nextGroup = array[nextIndex] as!NSArray

        if canRotate(nextGroup) {
            clearPrevGroup()
            for i in 0..<nextGroup.count {
                let tempIndex = nextGroup[i]as!Int
                let square = self.subviews[tempIndex]as!BasicSquare
                square.isSelectSquare = true
                square.setSquareSelectImage(image: selectImage, nomalImage: UIImage.init())
            }
            self.group = nextGroup as! Array<Int>
        }
        
    }
    
    //取出应该显示颜色
//    func selectStarImage() -> UIImage {
//        let random = Int(arc4random_uniform(UInt32(5)))
//        let picture = [UIImage.init(named: "star_b"),
//                       UIImage.init(named: "star_g"),
//                       UIImage.init(named: "star_p"),
//                       UIImage.init(named: "star_r"),
//                       UIImage.init(named: "star_y")]
//        
//        return  picture[random]!;
//    }
    
    func tipTypes() -> (NSArray) {
        return [
        [1, 2, 6, 7], // Z
        [2, 3, 5, 6], // 反Z
        [2, 4, 5, 6], // L
        [0, 4, 5, 6], // 反L
        [1, 4, 5, 6], // 凸
        [1, 2, 5, 6], // 田
        [4, 5, 6, 7], // 一
        ]
    }
    
    //获取类型
    func types() -> ( NSArray ){
        let types = [[
        [1, 4, 5, 8],   // Z
        [0, 1, 5, 6],
        ],
        
        [
        [1, 5, 6, 10],  // 反Z
        [1, 2, 4, 5],
        ],
        
        [
        [1, 2, 6, 10],
        [6, 8, 9, 10],
        [0, 4, 8, 9],   // L
        [0, 1, 2, 4],
        ],
        
        [
        [0, 1, 4, 8],
        [0, 1, 2, 6],
        [2, 6, 9, 10],  // 反L
        [4, 8, 9, 10],
        ],
        
        [
        [1, 4, 5, 9],
        [1, 4, 5, 6],   // 凸
        [1, 5, 6, 9],
        [4, 5, 6, 9],
        ],
        
        [[1, 2, 5, 6],    // 田
        ],
        
        [
        [4, 5, 6, 7],   // 一
        [1, 5, 9, 13],
        ],
        
        ];
        
        return types as (NSArray)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
