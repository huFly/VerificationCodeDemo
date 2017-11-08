//
//  PFTextField.swift
//  VerificationCodeDemo
//
//  Created by 胡鹏飞 on 2017/11/3.
//  Copyright © 2017年 胡鹏飞. All rights reserved.
//

import UIKit

@objc class PFTextField: UITextField {

    
    //MARK: init && override
    //禁止 粘贴 复制 等操作
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    //监听 删除操作
    override func deleteBackward() {
        self.text = ""
        NotificationCenter.default.post(name: .UITextFieldTextDidChange, object: self)
    }

    

    

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
