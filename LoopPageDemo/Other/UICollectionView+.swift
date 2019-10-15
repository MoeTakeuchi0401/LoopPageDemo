//
//  UICollectionView+.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2019/03/08.
//  Copyright © 2019年 takeuchi-mo. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    // セルの登録
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: className)
    }
    
    // 登録したセルのインスタンス化
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
}
