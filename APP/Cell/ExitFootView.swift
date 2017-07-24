//
//  ExitCell.swift
//  GuessStone
//
//  Created by ggx on 2017/7/21.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

//声明设置代理方法
protocol ExitLoginDelegate:NSObjectProtocol {
    func exibtn()
//    func PreviewCountdownLabelCorrectTime()
}

class ExitFootView: UIView {

    weak var delegate : ExitLoginDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    退出登录
    @IBAction func ExitLogin(_ sender: UIButton) {
        
        delegate?.exibtn()
    }
    
    
    
}
