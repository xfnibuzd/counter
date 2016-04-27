//
//  operator.swift
//  calculating
//
//  Created by liuxiaofeng on 16/4/26.
//  Copyright © 2016年 Soonbuy. All rights reserved.
//

import UIKit

struct MyErrorType: ErrorType {
    let reason :String?
}


class operatorSuper: NSObject {
    var number_A:Double?
    var number_B:Double?
    var result  :Double?
    
    func operate() -> Double {
        result = 0
        return result!
    }
}

class add: operatorSuper {
    override func operate() -> Double {
        return self.number_A! + self.number_B!
    }
}

class sub: operatorSuper {
    override func operate() -> Double {
        return self.number_A! - self.number_B!
    }
}

class multip: operatorSuper {
    override func operate() -> Double {
        return self.number_A! * self.number_B!
    }
}

class division: operatorSuper {
    override func operate() -> Double {
//        if self.number_B == 0 {
//            throw MyErrorType(reason :"除数不能为0")
//        }else{
            return self.number_A! / self.number_B!
//        }
    }
}













