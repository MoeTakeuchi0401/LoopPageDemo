//
//  NSObject+.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2019/03/08.
//  Copyright © 2019年 takeuchi-mo. All rights reserved.
//

import Foundation

extension NSObject {
    
    // クラス名の取得
    class var className: String {
        return String(describing: self)
    }
    var className: String {
        return type(of: self).className
    }
    
}
