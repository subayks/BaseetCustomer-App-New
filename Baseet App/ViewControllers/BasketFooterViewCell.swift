//
//  BasketFooterViewCell.swift
//  Baseet App
//
//  Created by Subendran on 12/08/22.
//

import UIKit
import Alamofire



class BasketFooterViewCell: UITableViewHeaderFooterView {
    @IBOutlet weak var applyCouponCodeBtn: UIButton!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var couponCodeTF: UITextField!
    @IBOutlet weak var grandTotalValue: UILabel!
    @IBOutlet weak var taxValue: UILabel!
    @IBOutlet weak var itemTotalValue: UILabel!
    @IBOutlet weak var addMoreItem: UIButton!
    @IBOutlet weak var offerCodeImage: UIImageView!
    @IBOutlet weak var takeAway: UIButton!
    @IBOutlet weak var orderNow: UIButton!
    @IBOutlet weak var discountAmountLbl: UILabel!
    
    @IBOutlet weak var discountAmountAppledLbl: UILabel!
    
    @IBOutlet weak var deliveryChargeHeadingLbl: UILabel!
    
    @IBOutlet weak var itemTotalLbl: UILabel!
    
    @IBOutlet weak var taxandChargesL: UILabel!
    
    var parentVC: UIViewController!
    
    @IBOutlet weak var deliveryChargeLbl: UILabel!
    
    @IBOutlet weak var grandL: UILabel!
    
   
    @IBAction func CouponCodeApply(_ sender: Any) {
       
        if removeCoupon == 0{
            self.RemoveCoupons()
        }else{
            couponcodeValue = couponCodeTF.text!
            print(couponcodeValue!)
        }
       
    }
    
    @objc func RemoveCoupons(){
        self.applyCouponCodeBtn.setTitle("Remove", for: .normal)
        couponcodeValue = "\(couponCodeTF.text = "")"
        NotificationCenter.default.post(name: Notification.Name("RemoveCouponName"), object: nil)
    }
    
}
