//
//  OrderSucessViewVC.swift
//  Baseet App
//
//  Created by VinodKatta on 25/07/22.
//

import UIKit

class OrderSucessViewVC: UIViewController {
    var orderSucessViewVCVM: OrderSucessViewVCVM?
    
    @IBOutlet weak var orderPlacedLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromSchedule == "isFromSchedule"{
            let orderId = self.orderSucessViewVCVM?.orderId ?? "12345"
            let order = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order", comment: "")
            let deliverd = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Scheduled Sucessfully", comment: "")
            let stringOne = "\(order) \(orderId) \(deliverd)"
            orderPlacedLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "\(stringOne)", comment: "")
            let stringTwo = "\(orderId)"

            let range = (stringOne as NSString).range(of: stringTwo)

            let attributedText = NSMutableAttributedString.init(string: stringOne)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            self.orderPlacedLabel.attributedText = attributedText
            closeButton.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        }else{
            let orderId = self.orderSucessViewVCVM?.orderId ?? "12345"
            let order = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order", comment: "")
            let deliverd = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Placed Sucessfully", comment: "")
            let stringOne = "\(order) \(orderId) \(deliverd)"
            orderPlacedLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "\(stringOne)", comment: "")
            let stringTwo = "\(orderId)"

            let range = (stringOne as NSString).range(of: stringTwo)

            let attributedText = NSMutableAttributedString.init(string: stringOne)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            self.orderPlacedLabel.attributedText = attributedText
            closeButton.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.orderSucessViewVCVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.orderSucessViewVCVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.orderSucessViewVCVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.orderSucessViewVCVM?.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
               // self.dismiss(animated: true, completion: {
                if isFromSchedule == "isFromSchedule"{
                    let vc = self.storyboard?.instantiateViewController(identifier: "tabVC")
                    vc!.modalPresentationStyle = .fullScreen
                    isScheduledDateTime = ""
                    isFromSchedule = ""
                    self.present(vc!, animated: true, completion: nil)
                }else{
                    selectedIndexValues = "0"
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "OrderOntheWayVC") as! OrderOntheWayVC
                    vc.orderPlacedScreen = "CancelNow"
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .fullScreen
                    vc.orderOntheWayVM = self.orderSucessViewVCVM?.getOrderOntheWayVM()
                    self.present(vc, animated: true, completion: nil)
                }
                    
              //  })
            }
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.orderSucessViewVCVM?.getOrderTrack()
    }
    
    @objc func closeBtn(){
        //self.orderSucessViewVCVM?.getOrderTrack()
        self.dismiss(animated: true)
    }
}
