//
//  PastOrderDetailsVC.swift
//  Baseet App
//
//  Created by apple on 09/11/22.
//

import UIKit

class PastOrderDetailsVC: UIViewController {
    
    var myPastOrderTableViewCellVMM: MyPastOrderTableViewCellVM?
    var myOrderVM = MyOrderVM()
    var orderOntheWayVM: OrderOntheWayVM?

    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var deliveryCharges: UILabel!
    
    @IBOutlet weak var CpersonName: UILabel!
    @IBOutlet weak var CpersonNumber: UILabel!
    @IBOutlet weak var CaddressType: UILabel!
    @IBOutlet weak var Caddress: UILabel!
    
    
    @IBOutlet weak var Rname: UILabel!
    @IBOutlet weak var Raddress: UILabel!
    
    var amount:String!
    var orderId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.orderAmount.text = "\(self.myPastOrderTableViewCellVMM?.myOrder?.orderAmount ?? 0)"
        print()
        //myPastOrderTableViewCellVM?.myOrder?.restaurant?.name
        //self.orderAmount.text = UserDefaults.standard.string(forKey: "order_Amount")
        self.discountAmount.text = UserDefaults.standard.string(forKey: "couponDiscountAmount")
        self.paymentMethod.text = UserDefaults.standard.string(forKey: "paymentMethod")
        self.deliveryCharges.text = UserDefaults.standard.string(forKey: "deliveryCharge")
        
        self.CpersonName.text = UserDefaults.standard.string(forKey: "contactPersonName")
        self.CpersonNumber.text = UserDefaults.standard.string(forKey: "contactPersonNumber")
        self.CaddressType.text = UserDefaults.standard.string(forKey: "addressType")
        self.Caddress.text = UserDefaults.standard.string(forKey: "address")
        
        self.Rname.text = UserDefaults.standard.string(forKey: "order_Amount")
        self.Raddress.text = UserDefaults.standard.string(forKey: "order_Amount")
        
        
        
       
        
       
        
        
        
//        self.itemImage.loadImageUsingURL(self.myCurrentOrderTableViewCellVM?.myOrder?.restaurant?.applogo)
//        self.itemName.text = self.myCurrentOrderTableViewCellVM?.myOrder?.restaurant?.name
//        self.orderId.text = "Order ID: \(self.myCurrentOrderTableViewCellVM?.myOrder?.id ?? 0)"
//        self.orderPrice.text = "QR \(self.myCurrentOrderTableViewCellVM?.myOrder?.orderAmount ?? 0)"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
