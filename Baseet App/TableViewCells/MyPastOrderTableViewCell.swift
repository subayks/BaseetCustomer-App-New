//
//  MyPastOrderTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit
enum OrderStatus: String {
    case pending = "pending"
    case canceled = "canceled"
    case delivered = "delivered"
    case refund_requested = "refund_requested"
    case processing = "processing"
    case picked_up = "picked_up"
}

class MyPastOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var orderDetailsBtn: UIButton!{
        didSet{
            //Order Details
            self.orderDetailsBtn.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order Details", comment: ""), for: .normal)
           
        }
    }
    var myPastOrderTableViewCellVM: MyPastOrderTableViewCellVM? {
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
        self.overView.layer.cornerRadius = 10
        self.overView.layer.borderWidth = 1
        self.overView.layer.borderColor = UIColor.gray.cgColor
        
        self.itemImage.layer.cornerRadius = 10
        self.itemImage.loadImageUsingURL(self.myPastOrderTableViewCellVM?.myOrder?.restaurant?.applogo)
        self.itemName.text = self.myPastOrderTableViewCellVM?.myOrder?.restaurant?.name
        self.orderId.text = "Order Id: \(self.myPastOrderTableViewCellVM?.myOrder?.id ?? 0)"
        print(orderId.text as Any)
        self.orderPrice.text = "QR \(self.myPastOrderTableViewCellVM?.myOrder?.orderAmount ?? 0)"
        
        
        
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.orderAmount, forKey: "order_Amount")
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.paymentMethod, forKey: "paymentMethod")
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.couponDiscountAmount, forKey: "couponDiscountAmount")
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.paymentMethod, forKey: "paymentMethod")
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.deliveryCharge, forKey: "deliveryCharge")
//
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.deliveryAddress?.contactPersonName, forKey: "contactPersonName")
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.deliveryAddress?.contactPersonNumber, forKey: "contactPersonNumber")
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.deliveryAddress?.addressType, forKey: "addressType")
//        UserDefaults.standard.set(myPastOrderTableViewCellVM?.myOrder?.deliveryAddress?.address, forKey: "address")
        
        
        
        
        
        
        
        if self.myPastOrderTableViewCellVM?.type == 0 {
        self.timingLabel.text = "Expected Delivery Time \(self.myPastOrderTableViewCellVM?.myOrder?.restaurant?.deliveryTime ?? "") Min"
        } else {
            self.timingLabel.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivered At", comment: "")) \(self.formattedTimeString(date: self.myPastOrderTableViewCellVM?.myOrder?.delivered ?? "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "On", comment: "")) \((self.formattedDateString(date: self.myPastOrderTableViewCellVM?.myOrder?.delivered ?? "")))"
        }
        
//        if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.delivered.rawValue {
//            self.orderStatus.text = "Your food has been \(self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus ?? "")"
//        } else if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.canceled.rawValue {
//            self.orderStatus.text = "On request \(self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus ?? "") your order"
//        } else if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.picked_up.rawValue {
//            self.orderStatus.text = "Your order is on the way"
//        } else if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.processing.rawValue {
//            self.orderStatus.text = "Your oder has been placed"
//        } else if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.refund_requested.rawValue {
//            self.orderStatus.text = "Your refund is initiated"
//        }
    }
    
    func formattedTimeString(date: String) ->String{
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")

        let dateObj = dateFormatter.date(from: dateString) ?? Date()

        dateFormatter.dateFormat = "h:mm a"
        return (dateFormatter.string(from: dateObj))
    }

    func formattedDateString(date: String) ->String{
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")

        let dateObj = dateFormatter.date(from: dateString)  ?? Date()

        dateFormatter.dateFormat = "MMMM d, yyyy"
        return (dateFormatter.string(from: dateObj))
    }
}

