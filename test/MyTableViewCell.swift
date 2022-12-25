//
//  MyTableViewCell.swift
//  test
//
//  Created by user on 27/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell{
    
    @IBOutlet var myImage: UIImageView!
    @IBOutlet var myText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
