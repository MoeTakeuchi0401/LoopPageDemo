//
//  UIColor+.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2019/04/09.
//  Copyright © 2019年 takeuchi-mo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // 16進数でインスタンス化
    convenience init(hex: Int, alpha: Double = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
}

