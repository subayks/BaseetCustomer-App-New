//
//  ProfileNameCell.swift
//  Baseet App
//
//  Created by Subendran on 23/09/22.
//

import UIKit

class ProfileNameCell: UITableViewCell {

    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
