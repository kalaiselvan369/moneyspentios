//
//  CurrencyTableViewCell.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 16/05/23.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var itemSelectionIcon: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected == true {
            itemSelectionIcon.isHidden = false
        } else {
            itemSelectionIcon.isHidden = true
        }
    }
    
}
