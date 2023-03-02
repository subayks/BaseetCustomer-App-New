//
//  OrderItemsListCell.swift
//  Baseet App
//
//  Created by Subendran on 24/09/22.
//

import UIKit

class OrderItemsListCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    var OrderItemsListCellVM: OrderItemsListCellVM? {
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
        self.itemName.text = self.OrderItemsListCellVM?.foodDetails?.foodDetails?.name
        self.priceLabel.text = "QR \(self.OrderItemsListCellVM?.foodDetails?.price ?? 0)"
    }
}
