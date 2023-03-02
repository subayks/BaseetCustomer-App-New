//
//  MyFevTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class MyFevTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNowButton: UIButton!{
        didSet{
            orderNowButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order Now", comment: ""), for: .normal)
        }
    }
    @IBOutlet weak var buttonFav: UIButton!
    @IBOutlet weak var timingButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var couponCode: UILabel!
    @IBOutlet weak var restaurentName: UILabel!
    @IBOutlet weak var restaurentIcon: UIImageView!
    var myFevTableViewCellVM: MyFevTableViewCellVM? {
        didSet {
            self.setupValues()
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
    
    func setupValues() {
        self.restaurentName.text = self.myFevTableViewCellVM?.restaurent?.name
        self.restaurentIcon.loadImageUsingURL(self.myFevTableViewCellVM?.restaurent?.applogo ?? "")
        self.ratingButton.setTitle(String(self.myFevTableViewCellVM?.restaurent?.avgRating ?? 0), for: .normal)
        self.timingButton.setTitle(self.myFevTableViewCellVM?.restaurent?.deliveryTime, for: .normal)
    }

}
