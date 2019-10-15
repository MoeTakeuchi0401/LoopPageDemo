//
//  SubViewController.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2019/03/08.
//  Copyright © 2019年 takeuchi-mo. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func Set(Text:String, index: NSInteger) {
        let Label = UILabel(frame:CGRect.zero)
        Label.frame.size = CGSize(width:App.windowWidth, height:100)
        Label.center = self.view.center
        Label.text = Text
        Label.textAlignment = .center
        self.view.addSubview(Label)
        
        if index == 0 {
            self.view.backgroundColor = UIColor.red
        } else if index == 1 {
            self.view.backgroundColor =  UIColor.orange
        } else if index == 2 {
            self.view.backgroundColor = UIColor.yellow
        } else {
            self.view.backgroundColor = UIColor.green
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
