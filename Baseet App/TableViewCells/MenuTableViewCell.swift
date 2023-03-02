//
//  MenuTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 09/07/22.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
