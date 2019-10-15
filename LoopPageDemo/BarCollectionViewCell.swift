//
//  BarCollectionViewCell.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2019/03/08.
//  Copyright © 2019年 takeuchi-mo. All rights reserved.
//

import UIKit

class BarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTitle(_ title: String) {
        self.categoryTitleLabel.text = title
        setSelectedCell(false)
    }
    
    func setSelectedCell(_ select: Bool) {
        self.categoryTitleLabel.textColor = select ? UIColor.blue : UIColor.gray
    }

}
