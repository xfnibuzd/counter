//
//  ViewController.swift
//  calculating
//
//  Created by liuxiaofeng on 16/4/26.
//  Copyright © 2016年 Soonbuy. All rights reserved.
//

import UIKit

let ScreenWidth     = UIScreen.mainScreen().bounds.size.width
let ScreenHeight    = UIScreen.mainScreen().bounds.size.height
let BTWidth         = ScreenWidth*0.25
let Result_height   = 100.0
let BTHeight        = (ScreenHeight-CGFloat(Result_height))*0.25
let ADD             = "+"
let SUB             = "-"
let MUL             = "x"
let DIV             = "/"
let CLEAR           = "c"
let RESULT          = "="


enum operateState {
    case ReadyInputNum,InputNumingFirst,InputOperatored,OperateValue,InputNumingSecond
};
enum Operate {
    case add,sub,mul,div
}


class ViewController: UIViewController {
    
    var state:operateState? = operateState.ReadyInputNum
    var result_label: UILabel?
    var operate_Selected:Operate?
    var first_input:Double? = 0.0
    var second_input:Double? = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CalculatorView()
    }

    
    func CalculatorView() {
        self.result_label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: CGFloat(Result_height)))
        
        self.result_label!.backgroundColor = UIColor.blackColor()
        self.result_label!.textColor = UIColor.whiteColor()
        self.result_label!.textAlignment = NSTextAlignment.Right
        self.result_label!.text = "0"
        self.view.addSubview(self.result_label!)
        self.setNumBt()
        self.setOperatorBt()
    }
    
    func setNumBt() {
        for i in 0...9 {
            let numBt = UIButton.init(frame: CGRect.init(x: (CGFloat)(i%3)*BTWidth, y: (CGFloat)(i/3)*BTHeight+CGFloat(Result_height), width: BTWidth, height: BTHeight))
            numBt.setTitle(String(i), forState: UIControlState.Normal)
            numBt.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            numBt.titleLabel?.textAlignment = NSTextAlignment.Center
            numBt.backgroundColor = UIColor.grayColor()
            numBt.layer.borderWidth = 0.3
            numBt.layer.borderColor = UIColor.blackColor().CGColor
            numBt.addTarget(self, action:#selector(tapNum(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(numBt)
        }
    }
    
    func setOperatorBt() {
        let operater:[String] = [ADD,SUB,MUL,DIV,RESULT,CLEAR]
        for i in 0..<operater.count {
            let item = operater[i]
            var rect:CGRect?

            if i<operater.count-2 {
                rect = CGRect.init(x: 3*BTWidth, y: (CGFloat)(i)*BTHeight+CGFloat(Result_height), width: BTWidth, height: BTHeight)
            }else{
                rect = CGRect.init(x: (CGFloat)(operater.count-i)*BTWidth, y: 3*BTHeight+CGFloat(Result_height), width: BTWidth, height: BTHeight)
            }
            let numBt = UIButton.init(frame: rect!)
            numBt.setTitle(item, forState: UIControlState.Normal)
            numBt.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            numBt.titleLabel?.textAlignment = NSTextAlignment.Center
            numBt.backgroundColor = UIColor.orangeColor()
            numBt.layer.borderWidth = 0.3
            numBt.layer.borderColor = UIColor.blackColor().CGColor
            numBt.addTarget(self, action:#selector(tapOperator(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(numBt)
        }
    }

    
    func tapNum(numBt:UIButton) {
        if self.state==operateState.ReadyInputNum {
            self.state=operateState.InputNumingFirst
            self.result_label?.text = numBt.titleLabel?.text
        }else if self.state==operateState.InputOperatored||self.state == operateState.OperateValue{
            self.state=operateState.InputNumingSecond
            self.result_label?.text = numBt.titleLabel?.text
        }else if (self.state==operateState.InputNumingFirst||self.state == operateState.InputNumingSecond){
            self.result_label?.text = (self.result_label?.text)! + (numBt.titleLabel?.text)!
        }
    }
    
    func tapOperator(operatorBt:UIButton) {
        let operator_string = operatorBt.titleLabel?.text!
        if operator_string==CLEAR {
            self.clear()
            return
        }
        if self.state != operateState.InputOperatored{
            self.configValue()
            if self.operate_Selected != nil && self.state != operateState.OperateValue{
                self.first_input = self.operatorByOperateSelected(self.operate_Selected!, firstInput: self.first_input!, secondInput: self.second_input!)
                self.result_label?.text = String(self.first_input!)
            }

            if operator_string==RESULT {
                self.state = operateState.OperateValue
                return
            }
            
            self.state = operateState.InputOperatored
            switch operator_string! {
            case ADD:
                self.operate_Selected = Operate.add
                break
            case SUB:
                 self.operate_Selected = Operate.sub
                break
            case MUL:
                self.operate_Selected = Operate.mul
                break
            case DIV:
                self.operate_Selected = Operate.div
                break
            default:
                break
            }
        }
    }
    
    func clear() {
        self.operate_Selected = nil
        self.second_input = 0.0
        self.first_input = 0.0
        self.state = operateState.ReadyInputNum
        self.result_label?.text = "0.0"
    }
    func configValue() {
        if self.state == operateState.InputNumingFirst||self.state == operateState.ReadyInputNum {
            self.first_input = Double((self.result_label?.text)!)
        }else if self.state == operateState.InputNumingSecond{
            self.second_input = Double((self.result_label?.text)!)
        }
    }
    
    func operatorByOperateSelected(selected:Operate,firstInput:Double,secondInput:Double) -> Double {
        var operatorS:operatorSuper?;
        switch selected {
        case .add:
            operatorS = add()
            break
        case .sub:
            operatorS = sub()
            break
        case .mul:
            operatorS = multip()
            break
        case .div:
            operatorS = division()
            break
        }
        operatorS?.number_A = firstInput
        operatorS?.number_B = secondInput
        print(operatorS?.operate())
        return (operatorS?.operate())!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

