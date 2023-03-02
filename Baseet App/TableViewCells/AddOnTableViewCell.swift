//
//  AddOnTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class AddOnTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    {
        didSet{
           
        }
    }
    @IBOutlet weak var addOnView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adOnImage: UIImageView!
    @IBOutlet weak var QuantityCount: UILabel!
    var itemCount = 1
    var itemAdded:((Int, Int, Bool)->())?

    var addOnTableViewCellVM: AddOnTableViewCellVM? {
        didSet {
        self.setupValues()
        }
    }
    
   
    
    @IBOutlet weak var buttonCheck: UIButton!
    
    var itemCountClosure:((String)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupValues() {
        self.addOnView.layer.borderWidth = 1
        self.addOnView.layer.borderColor = UIColor.white.cgColor
        self.addOnView.layer.cornerRadius = 15
        self.adOnImage.layer.cornerRadius = 15
        self.adOnImage.loadImageUsingURL("")
        self.titleLabel.text = self.addOnTableViewCellVM?.addOn?.name
        self.QuantityCount.text = "\(self.addOnTableViewCellVM?.addOn?.itemQuantity ?? 0)"
        self.itemCount = self.addOnTableViewCellVM?.addOn?.itemQuantity ?? 0
        self.labelPrice.text = "QR \(self.addOnTableViewCellVM?.addOn?.price ?? 0)"
//        if self.addOnTableViewCellVM?.addOn?.itemQuantity == 0 || self.addOnTableViewCellVM?.addOn?.itemQuantity == nil {
//            self.buttonCheck.setImage(UIImage(named: "square"), for: .normal)
//        } else {
//            self.buttonCheck.setImage(UIImage(named: "checkmark"), for: .normal)
//
//        }
        self.buttonCheck.setImage(UIImage(named: "square"), for: .normal)
    }

    @IBAction func actionReduce(_ sender: Any) {
        if self.itemCount == 1 {
            itemCount = self.itemCount - 1
            self.QuantityCount.text = "\(self.itemCount)"
        } else {
            if itemCount > 0 {
            self.itemCount = self.itemCount - 1
            self.QuantityCount.text = "\(self.itemCount)"
            }
        }
        self.itemAdded?(self.itemCount, buttonAdd.tag, false)
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        itemCount = itemCount + 1
        self.QuantityCount.text = "\(itemCount)"
        self.itemAdded?(self.itemCount, buttonAdd.tag, true)
    }
    
    @IBAction func actionCheck(_ sender: Any) {
        print(self.addOnTableViewCellVM?.addOn?.itemQuantity)
        if buttonCheck.currentImage == UIImage(named: "checkmark") {
            self.buttonCheck.setImage(UIImage(named: "square"), for: .normal)
            itemCount = 0
            self.QuantityCount.text = "\(itemCount)"
            self.itemAdded?(self.itemCount, buttonAdd.tag, false)
        } else {
            self.buttonCheck.setImage(UIImage(named: "checkmark"), for: .normal)
            itemCount = itemCount + 1
            self.QuantityCount.text = "\(itemCount)"
            self.itemAdded?(self.itemCount, buttonAdd.tag, true)

        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
