//
//  PFCodeInputView.swift
//  VerificationCodeDemo
//
//  Created by 胡鹏飞 on 2017/11/3.
//  Copyright © 2017年 胡鹏飞. All rights reserved.
//

import UIKit
@IBDesignable
@objcMembers
class PFCodeInputView: UIView {
    
    private let renderView = PFTextFieldRenderView()
    private let textField = PFTextField()
    
    //验证码输入满调用
    var completion: ((String) -> Void)?
    //默认矩形
    var boderStyle: BoderStyle = .rect(1.0, .black) {
        didSet {
            renderView.boderStyle = self.boderStyle
        }
    }
    //文字的偏移, 默认居中
    var contentOffSet: CGPoint = CGPoint.zero {
        didSet {
            renderView.contentOffSet = contentOffSet
        }
    }
    //
    @IBInspectable var numOfInput: Int = 6 {
        didSet{
            renderView.numOfInput = numOfInput
        }
    }
    @IBInspectable var text: String? {
        didSet {
            textField.text = text
            renderView.text = text
        }
    }

    @IBInspectable var showCursor: Bool = false {
        didSet {
            renderView.showCursor = showCursor
        }
    }
    @IBInspectable var textColor: UIColor? = UIColor.black {
        didSet{
            renderView.textColor = textColor
        }
    }
    @IBInspectable var dotColor = UIColor.black {
        didSet {
            renderView.dotColor = dotColor
        }
    }

    
    @IBInspectable var font: UIFont = UIFont.systemFont(ofSize: 20) {
        didSet{
            renderView.font = font
        }
    }
    @IBInspectable var secureTextEntry: Bool = false {
        didSet{
            renderView.secureTextEntry = secureTextEntry
        }
    }
    //MARK: init && override
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    //MARK: public func
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return self.textField.resignFirstResponder()
    }
    //MARK: Views && UI
    private func setup() {
        backgroundColor = UIColor.white
        self.textColor = UIColor.black
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(notify:)), name: .UITextFieldTextDidChange, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(beginEditText(notify:)), name: .UITextFieldTextDidBeginEditing, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(endEditText(notify:)), name: .UITextFieldTextDidEndEditing, object: textField)
        
        configSubviews()
    
        
    }
    
    private func configSubviews() {
        
        textField.textColor = UIColor.clear
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        fullBoundsLayout(view: textField)
        
        renderView.backgroundColor = UIColor.white
        renderView.isUserInteractionEnabled = false
        fullBoundsLayout(view: renderView)
        
    }
    private func fullBoundsLayout(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        addConstraints([top, leading, bottom, trailing])
    }
    
    //MARK: TargetAction && Notification
    
    @objc private func textChanged(notify: NSNotification) {
        if let textField = notify.object as? PFTextField {
            if textField == self.textField {
                if textField.text!.count < 6 {
                    renderView.text = textField.text
                    renderView.startCursorViewAnimation(at: renderView.text!.count)
                } else {
                    renderView.endCursorViewAnimation()
                    self.text = String(textField.text![textField.text!.startIndex...textField.text!.index(textField.text!.startIndex, offsetBy: 5)])
                    if let finish = completion {
                        finish(textField.text!)
                    }
                }
            }
        }
    }
    @objc private func endEditText(notify: NSNotification) {
        renderView.endCursorViewAnimation()
    }
    @objc private func beginEditText(notify: NSNotification) {
        if let currentText = self.text {
            if showCursor && currentText.count < 6 {
                renderView.startCursorViewAnimation(at: currentText.count)
            } else {
                renderView.endCursorViewAnimation()
            }
        } else {
            renderView.startCursorViewAnimation(at: 0)
        }
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
