//
//  ViewController.swift
//  VerificationCodeDemo
//
//  Created by 胡鹏飞 on 2017/11/3.
//  Copyright © 2017年 胡鹏飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let textField  = PFCodeInputView.init(frame: CGRect.init(x: 10, y: 100, width: 300, height: 60))
        textField.showCursor = true
        textField.secureTextEntry = true
        textField.boderStyle = .rect(1, UIColor.orange)
        textField.textColor = UIColor.cyan
        textField.completion = {[weak textField] text in
            print(text)
            let _ = textField?.resignFirstResponder()
        }
        self.view.addSubview(textField)
        
        let textField1  = PFCodeInputView(frame: CGRect.init(x: 10, y: 200, width: 300, height: 60))
        textField1.showCursor = true
        textField1.boderStyle = .underLine(1, UIColor.orange)
        textField1.textColor = UIColor.cyan
        textField1.completion = {[weak textField1] text in
            print(text)
            let _ = textField1?.resignFirstResponder()
        }
        self.view.addSubview(textField1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

