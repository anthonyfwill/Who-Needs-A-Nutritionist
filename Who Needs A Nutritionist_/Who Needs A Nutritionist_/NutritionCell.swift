//
//  NutritionCell.swift
//  Who Needs A Nutritionist?
//
//  Created by AnthonyProject on 11/22/21.
//

import UIKit

class NutritionCell: UITableViewCell {
    
    @IBOutlet weak var nutrientLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
