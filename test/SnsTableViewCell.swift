//
//  SnsTableViewCell.swift
//  test
//
//  Created by user on 26/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit

class SnsTableViewCell: UITableViewCell{
    
    @IBOutlet var snsImage: UIImageView!
    @IBOutlet var snsText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
