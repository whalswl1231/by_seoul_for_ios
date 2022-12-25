//
//  SpringTableViewCell.swift
//  test
//
//  Created by user on 2020/11/19.
//  Copyright © 2020 111. All rights reserved.
//

import Foundation
import UIKit

class SpringTableViewCell: UITableViewCell {
    
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var springLabel: UILabel!
    @IBOutlet var springImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}

