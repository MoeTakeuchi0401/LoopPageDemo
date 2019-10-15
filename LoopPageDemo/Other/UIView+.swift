//
//  UIView+.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2018/02/24.
//  Copyright © 2017年 takeuchi-mo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // addSubview後に上下左右の端が一致するconstraintsを付与
    func addSubviewWithSameFrameConstraints(_ view: UIView) {
        self.addSubview(view)
        self.addSameFrameConstraints(view)
    }
    
    // 上下左右の端が一致するようconstraintsを付与
    func addSameFrameConstraints(_ subview: UIView) {
        if !self.contains(view: subview) {
            fatalError("Cannot add constraints to views not in same view hierarchy.")
        }
        subview.translatesAutoresizingMaskIntoConstraints = false
        let top = subview.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = subview.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leading = subview.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = subview.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let width = subview.widthAnchor.constraint(equalTo: self.widthAnchor)
        let height = subview.heightAnchor.constraint(equalTo: self.heightAnchor)
        self.addConstraints([top, bottom, leading, trailing, width, height])
    }
    
    // 渡したviewが自身のsubViewか、全ての階層を調べる
    func contains(view subview: UIView) -> Bool {
        return subview.contained(by: self)
    }
    
    // 渡したviewが自身のsuperViewか、全ての階層を調べる
    func contained(by view: UIView) -> Bool {
        var superview: UIView? = self.superview
        // 再帰的に確認
        while nil != superview {
            if view == superview {
                return true
            }
            superview = superview!.superview
        }
        return false
    }
    
}
