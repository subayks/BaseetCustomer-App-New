//
//  SettingsTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 11/07/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingImge: UIImageView!
    @IBOutlet weak var settinglbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
