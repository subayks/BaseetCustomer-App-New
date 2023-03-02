//
//  MyPlacesTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class MyPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var hoemIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
