//
//  MealCell.swift
//  Who Needs A Nutritionist?
//
//  Created by AnthonyProject on 11/22/21.
//

import UIKit

protocol MealCellDelegate: AnyObject {
    func buttonPressed(sender: MealCell, buttonPressed: Bool, id: UUID)
}

class MealCell: UITableViewCell {
    
    var buttonPressed = false
    var id: UUID? = nil
    weak var delegate: MealCellDelegate?
    
    @IBAction func ateFoodPressed(_ sender: UIButton) {
        if delegate != nil {
            print("Pressed")
            buttonPressed = true
            delegate?.buttonPressed(sender: self, buttonPressed: buttonPressed, id: id!)
        }
    }
    
    @IBOutlet weak var ateFoodButton: UIButton!
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
