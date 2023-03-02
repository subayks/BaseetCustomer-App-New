//
//  CouponCell.swift
//  Baseet App
//
//  Created by Subendran on 22/09/22.
//

import UIKit

class CouponCell: UITableViewCell {
    
    @IBOutlet weak var offerTitle: UIButton!{
        didSet{
            
        }
    }
    @IBOutlet weak var iconImage: UIImageView!{
        didSet{
            
        }
    }
    var CouponCellVM: CouponCellVM? {
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
        self.iconImage.loadImageUsingURL(self.CouponCellVM?.couponItem?.logo)
        self.offerTitle.setTitle(self.CouponCellVM?.couponItem?.title, for: .normal)
        let subtitle = "Use \(self.CouponCellVM?.couponItem?.code ?? "") | "
        self.offerTitle.subtitleLabel?.text = subtitle
    }
}
