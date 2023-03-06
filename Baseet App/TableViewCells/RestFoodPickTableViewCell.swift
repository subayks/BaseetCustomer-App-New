//
//  RestFoodPickTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

var grandTotalValue:String!
var addonPriceValuesIncreement:String!

protocol YourCellDelegate: AnyObject {
    func didTapButton(_ sender: UIButton)
}

class RestFoodPickTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addonNames: UILabel!
    weak var delegate: YourCellDelegate?
    @IBOutlet weak var countOverView: UIView!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var qrCodeLabel: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    var itemAdded:((Int, Int,Bool)->())?
    var itemCountValue = 0
    var addonprice:String!
    var yourobj : (() -> Void)? = nil
    @IBOutlet weak var customizeBtn: UIButton!
    var addonInfo:(([CartAddOn])->())?
    
    var RestFoodPickTableViewCellVM: RestFoodPickTableViewCellVM? {
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
        self.itemImage.layer.cornerRadius = 15
        self.countOverView.layer.cornerRadius = 5
        self.countOverView.layer.borderWidth = 1
        self.countOverView.layer.borderColor = UIColor(red: 172/255, green: 37/255, blue: 23/255, alpha: 1).cgColor
        self.addonNames.text = self.RestFoodPickTableViewCellVM?.addonNames()
        self.itemName.text = self.RestFoodPickTableViewCellVM?.foodItems?.name
        self.itemCount.text = self.RestFoodPickTableViewCellVM?.foodItems?.foodQty
        self.itemCountValue = Int(self.RestFoodPickTableViewCellVM?.foodItems?.foodQty ?? "") ?? 0
        self.itemImage.loadImageUsingURL(self.RestFoodPickTableViewCellVM?.foodItems?.appimage)
       /* if addonPriceValuesIncreement == "addonsValue"{
            let addon = self.RestFoodPickTableViewCellVM?.foodItems?.addon
            for price in addon!{
                addonprice = price.addonprice
                print(addonprice!)
            }
            let itemPrice = self.RestFoodPickTableViewCellVM?.foodItems?.tprice ?? 0 - (Int(self.RestFoodPickTableViewCellVM?.foodItems?.discount ?? "") ?? 0)
            print(itemPrice)
            let addonValue = Int(addonprice)
            self.qrCodeLabel.text = "QR \(itemPrice + addonValue!)"
        }else{
            let itemPrice = self.RestFoodPickTableViewCellVM?.foodItems?.tprice ?? 0 - (Int(self.RestFoodPickTableViewCellVM?.foodItems?.discount ?? "") ?? 0)
            self.qrCodeLabel.text = "QR \(itemPrice)"
        }*/
        //let itemPrice = self.RestFoodPickTableViewCellVM?.foodItems?.tprice ?? 0 - (Int(self.RestFoodPickTableViewCellVM?.foodItems?.discount ?? "") ?? 0)
        let itemPrice = self.RestFoodPickTableViewCellVM?.foodItems?.name
       //
        self.qrCodeLabel.text = "QR \(self.RestFoodPickTableViewCellVM?.foodItems?.price ?? "")"
        
    }

    @IBAction func reduceQuantity(_ sender: UIButton) {
       /* if self.itemCountValue >= 0 {
            couponcodeValue = ""
            self.itemCountValue = self.itemCountValue - 1
            self.itemAdded?(self.itemCountValue, buttonAdd.tag,false)
            //NotificationCenter.default.post(name: Notification.Name("RemovePopUpView"), object: nil)
        }*/
        
        if self.itemCountValue == 1 {
            itemCountValue = self.itemCountValue - 1
        } else {
            self.itemCountValue = self.itemCountValue - 1
        }
        self.itemAdded?(self.itemCountValue, buttonAdd.tag, false)
        NotificationCenter.default.post(name: Notification.Name("ReduceFunctionName"), object: nil)
    }
    
    @IBAction func addQuantity(_ sender: UIButton) {
        couponcodeValue = ""
        addonPriceValuesIncreement = "ItemAdded"
        self.itemCountValue = self.itemCountValue  + 1
        self.itemAdded?(self.itemCountValue, buttonAdd.tag,true)
        NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
    }
    
    @IBAction func customizationAction(_ sender: Any) {
        self.addonInfo?(self.RestFoodPickTableViewCellVM?.foodItems?.addon ?? [CartAddOn()])
    }
    
    
}
