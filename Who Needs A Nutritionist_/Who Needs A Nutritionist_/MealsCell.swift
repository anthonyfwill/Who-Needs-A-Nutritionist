//
//  SearchResultCell.swift
//  Who Needs A Nutritionist?
//
//  Created by james on 11/13/21.
//

import UIKit

class MealsCell: UITableViewCell {
    
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var foodsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
