//
//  InitDemo.swift
//  MayBe
//
//  Created by liuxiang on 2020/7/1.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class InitDemo: NSObject {
    var str:String
    init(str:String) {
        self.str = str
    }
//    override init() {
//        super.init()
//    }

}

class Sub1: InitDemo {
     init() {
        super.init(str: "33")
    }
}

class Sub2: Sub1 {
    var str2:String = ""
    
    convenience init(str:String) {
        self.init()
        self.str2 = str
    }
    
    override init() {
        
    }
}

