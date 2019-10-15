//
//  StoryBoardInstantiatable.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2019/03/08.
//  Copyright © 2019年 takeuchi-mo. All rights reserved.
//

import Foundation
import UIKit

protocol StoryBoardInstantiatable {}
extension UIViewController: StoryBoardInstantiatable {}

extension StoryBoardInstantiatable where Self: UIViewController {
    
    // StoryboardのViewControllerを生成
    // InitialViewControllerに設定されている必要がある
    static func instantiateFromStoryboard(_ storyboardName: String? = nil) -> Self {
        // storyboardが指定されていない場合は\(クラス名).storyboard から取得
        let storyboard = UIStoryboard(name: storyboardName ?? self.className, bundle: nil)
        return storyboard.instantiateInitialViewController() as! Self
    }
    
    static func instantiateFromStoryboard(withIdentifier identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}
