//
//  MyCurrentOrderTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class MyCurrentOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var orderDetailsBtn: UIButton!{
        didSet{
            self.orderDetailsBtn.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order Details", comment: ""), for: .normal)
        }
    }
    @IBOutlet weak var modifyOrderBtn: UIButton!
    var myCurrentOrderTableViewCellVM: MyCurrentOrderTableViewCellVM? {
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
        self.itemImage.loadImageUsingURL(self.myCurrentOrderTableViewCellVM?.myOrder?.restaurant?.applogo)
        self.itemName.text = self.myCurrentOrderTableViewCellVM?.myOrder?.restaurant?.name
        self.orderId.text = "Order ID: \(self.myCurrentOrderTableViewCellVM?.myOrder?.id ?? 0)"
        UserDefaults.standard.set(myCurrentOrderTableViewCellVM?.myOrder?.id ?? 0, forKey: "OrderId")
        self.orderPrice.text = "QR \(self.myCurrentOrderTableViewCellVM?.myOrder?.orderAmount ?? 0)"
        orderDetailsBtn.titleLabel?.numberOfLines = 1
        orderDetailsBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        orderDetailsBtn.titleLabel?.lineBreakMode = .byClipping
        
       
        if self.myCurrentOrderTableViewCellVM?.type == 0 {
        self.timingLabel.text = "Expected Delivery at \(self.myCurrentOrderTableViewCellVM?.myOrder?.restaurant?.deliveryTime ?? "") Min"
        } else {
            self.timingLabel.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivered At", comment: "")) \(self.formattedTimeString(date: self.myCurrentOrderTableViewCellVM?.myOrder?.delivered ?? "")) on \((self.formattedDateString(date: self.myCurrentOrderTableViewCellVM?.myOrder?.delivered ?? "")))"
        }
        
        if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.delivered.rawValue {
            self.orderStatus.text = "Your food has been \(self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus ?? "")"
        } else if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.canceled.rawValue {
            self.orderStatus.text = "On request \(self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus ?? "") your order"
        } else if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.picked_up.rawValue {
            self.orderStatus.text = "Your order is on the way"
        } else if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.processing.rawValue {
            self.orderStatus.text = "Your oder has been placed"
        } else if self.myCurrentOrderTableViewCellVM?.myOrder?.orderStatus == OrderStatus.refund_requested.rawValue {
            self.orderStatus.text = "Your refund is initiated"
        }
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
