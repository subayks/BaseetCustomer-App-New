//
//  CartTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 11/07/22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    var CartTableViewCellVM: CartTableViewCellVM? {
        didSet {
            self.setupValues()
        }
    }
 

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupValues() {
        self.cartImage.layer.cornerRadius = 15
        self.cartImage.loadImageUsingURL(self.CartTableViewCellVM?.foodItems?.appimage)
        self.cartLbl.text = self.CartTableViewCellVM?.foodItems?.name
        self.moneyLbl.text = "QR \(self.CartTableViewCellVM?.foodItems?.tprice ?? 0)"
        self.percentLbl.text = "Quantity \(self.CartTableViewCellVM?.foodItems?.foodQty ?? "Unknown")"
        self.percentLbl.font = UIFont.systemFont(ofSize: 16)
       // cartLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "No item avaliable", comment: "")
    }

}
