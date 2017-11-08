//
//  PFTextFieldRenderView.swift
//  VerificationCodeDemo
//
//  Created by 胡鹏飞 on 2017/11/3.
//  Copyright © 2017年 胡鹏飞. All rights reserved.
//

import UIKit
import Darwin

enum BoderStyle {
    case rect(Double, UIColor)
    case underLine(Double, UIColor)
}

@IBDesignable
class PFTextFieldRenderView: UIView {
   
    
    var textColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    var showCursor: Bool = false {
        didSet {
            startCursorViewAnimation(at: text == nil ? 0 : text!.count - 1)
        }
    }
    var cursorColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    var contentOffSet: CGPoint = CGPoint.zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var numOfInput = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    var boderStyle: BoderStyle = .rect(1.0, .black) {
        didSet {
            setNeedsDisplay()
        }
    }
    var secureTextEntry = false {
        didSet {
            if oldValue {
                textColor = nil
                setNeedsDisplay()
                return
            }
            textColor = UIColor.black
            setNeedsDisplay()
        }
    }
    var minumDotRadius = 5.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var dotColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    var font: UIFont = UIFont.systemFont(ofSize: 20) {
        didSet {
            contentOffSet = CGPoint(x: font.pointSize * 2 / 3, y: 5)
        }
    }

    private var underLineSpace: CGFloat = 5.0
    private var cursorView: UIView?
    
    
    
    //MARK: init && override
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    // Views & UI
    
    override func draw(_ rect: CGRect) {
        
        switch boderStyle {
        case let .rect(boderWidth, boderColor):
            let cox = UIGraphicsGetCurrentContext()!
            //边框
            cox.saveGState()
            let boderPath = UIBezierPath(rect: bounds)
            boderPath.lineCapStyle = .square
            //不知道为啥矩形的线细
            cox.setLineWidth(CGFloat(boderWidth * 2.0))

            cox.addPath(boderPath.cgPath)
            cox.setStrokeColor(boderColor.cgColor)
            cox.strokePath()
            cox.restoreGState()
            //纵向分割线
            cox.saveGState()
            let uprightLines = UIBezierPath()
            cox.setLineWidth(CGFloat(boderWidth))
            for index in 1..<numOfInput {
                uprightLines.move(to: CGPoint(x: calculateInputArea(at: index).minX, y: 0))
                uprightLines.addLine(to: CGPoint(x: calculateInputArea(at: index).minX, y: calculateInputArea(at: index).maxY))
            }
            cox.addPath(uprightLines.cgPath)
            cox.setStrokeColor(boderColor.cgColor)
            cox.strokePath()
            cox.restoreGState()
            // 画数据
            drawData(in: cox)
        case let .underLine(boderWidth, boderColor):
            // 画底线
            let cox = UIGraphicsGetCurrentContext()!
            cox.saveGState()
            cox.move(to: CGPoint(x: underLineSpace, y: bounds.maxY - CGFloat(boderWidth)))
            cox.setLineWidth(CGFloat(boderWidth))
            cox.setLineCap(.square)
            cox.setStrokeColor(boderColor.cgColor)
            let bottomBoderLength: CGFloat = (bounds.maxX - (underLineSpace * CGFloat(numOfInput * 2))) / CGFloat(numOfInput)
            cox.setLineDash(phase: 0, lengths: [bottomBoderLength, underLineSpace * 2])
            cox.addLine(to: CGPoint(x: bounds.maxX - CGFloat(underLineSpace), y: bounds.maxY - CGFloat(boderWidth)))
            cox.strokePath()
            cox.restoreGState()
            // 画数据
            drawData(in: cox)
        }
    }
    //MARK: Public
    func startCursorViewAnimation(at index: Int) {
        if showCursor {
            if (cursorView == nil) {
                cursorView = UIView()
                addSubview(cursorView!)
            }
            cursorView!.isHidden = false
            cursorView!.frame = CGRect(x: 0, y: 0, width: 2, height: CGFloat(bounds.maxY / 2.0))
            cursorView!.backgroundColor = cursorColor!
            cursorView!.center = CGPoint(x: calculateInputArea(at: index).midX, y: calculateInputArea(at: index).midY)
            guard (cursorView?.layer.animation(forKey: "opacity")) == nil else { return }
            let opacityAni = CABasicAnimation(keyPath: "opacity")
            opacityAni.fromValue = 1.0
            opacityAni.toValue = 0.0
            opacityAni.duration = 1
            opacityAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            opacityAni.repeatCount = Float.greatestFiniteMagnitude
            opacityAni.isRemovedOnCompletion = true
            cursorView!.layer.add(opacityAni, forKey: "opacity")
        }
    }
    func endCursorViewAnimation() {
        if showCursor {
            cursorView!.layer.removeAnimation(forKey: "opacity")
            cursorView!.isHidden = true
        }
    }

    
    //MARK: private
    
    
    private func drawData(in cox: CGContext?) {
        if text != nil {
            if secureTextEntry {
                //画点
                let radius = Double.maximum(minumDotRadius, Double(font.pointSize / 2.0))
                cox!.setFillColor(dotColor.cgColor)
                for index in 0..<text!.count {
                    let circlePath = UIBezierPath(arcCenter: CGPoint(x: calculateInputArea(at: index).midX - contentOffSet.x, y: calculateInputArea(at: index).midY - contentOffSet.y), radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
                    cox!.addPath(circlePath.cgPath)
                    cox!.fillPath()
                }
                
            } else {
                // 画文字
                guard textColor != nil else { return }
                guard textColor != UIColor.clear else { return }
                for (index, c) in text!.enumerated() {

                    let textCenter = CGPoint(x: calculateInputArea(at: index).midX - calculateCharacterRect(c: c).midX - contentOffSet.x, y: calculateInputArea(at: index).midY - calculateCharacterRect(c: c).midY - contentOffSet.y)
                    
                    let single = String(c) as NSString
                    single.draw(at: textCenter, withAttributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : textColor!])
                }
            }
        }
    }
    
    
    private func setup() {
        backgroundColor = UIColor.white
        showCursor = false
        cursorColor = tintColor
    }
    
    
    private func calculateInputArea(at index: Int) -> CGRect {
        let segementWidth = bounds.size.width / CGFloat(numOfInput)
        return CGRect(x: CGFloat(index) * segementWidth, y: 0, width: segementWidth, height: bounds.size.height)
    }

    private func calculateCharacterRect(c: Character) -> CGRect{
        let label = UILabel()
        label.font = font
        label.text = String(c)
        label.sizeToFit()
        return label.bounds
    }
    
    
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
