//
//  RecordTableViewCell.swift
//  test
//
//  Created by user on 29/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell{
    
    @IBOutlet var record_date: UILabel!
    @IBOutlet var record_time: UILabel!
    @IBOutlet var record_kcal: UILabel!
    @IBOutlet var record_km: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class BuyTableViewCell: UITableViewCell{
    @IBOutlet var buy_date: UILabel!
    @IBOutlet var buy_time: UILabel!
    @IBOutlet var buy_price: UILabel!
    
}
