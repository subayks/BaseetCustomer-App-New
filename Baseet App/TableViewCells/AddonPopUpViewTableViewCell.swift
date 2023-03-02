//
//  AddonPopUpViewTableViewCell.swift
//  Baseet App
//
//  Created by apple on 21/11/22.
//

import UIKit

class AddonPopUpViewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVieww: UIImageView!
    
    @IBOutlet weak var foodItem: UILabel!
    
   @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
