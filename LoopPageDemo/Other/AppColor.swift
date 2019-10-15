//
//  AppColor.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2018/03/06.
//  Copyright © 2017年 takeuchi-mo. All rights reserved.
//

import UIKit

extension App {
    
    enum Color {
        case black                      // 黒
        case paleOverlayBackgroundGray  // 透過グレー
        
        private var params: (code: Int, alpha: Double) {
            switch self {
            case .black: return (0x000000, 1)
            case .paleOverlayBackgroundGray: return (0xf2f2f2, 0)
            }
        }
        
        var uiColor: UIColor {
            return UIColor(hex: self.params.code, alpha: self.params.alpha)
        }
        
        var cgColor: CGColor {
            return self.uiColor.cgColor
        }
    }
    
}
