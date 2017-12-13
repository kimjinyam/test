//
//  StockTableViewCell.swift
//  htmlParser
//
//  Created by nemus on 2017. 10. 12..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var stockname: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var perChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
