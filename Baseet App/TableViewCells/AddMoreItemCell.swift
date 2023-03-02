//
//  AddMoreItemCell.swift
//  Baseet App
//
//  Created by Subendran on 22/09/22.
//

import UIKit

class AddMoreItemCell: UITableViewCell {
    @IBOutlet weak var addMore: UIButton!{
        didSet{
            addMore.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add More Item", comment: ""), for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
