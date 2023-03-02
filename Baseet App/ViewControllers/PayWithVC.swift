//
//  PayWithVC.swift
//  Baseet App
//
//  Created by VinodKatta on 25/07/22.
//

import UIKit

class PayWithVC: UIViewController {
    
    var paymentType:((PaymentType)->())?

    @IBOutlet weak var paywithL: UILabel!
    
    @IBOutlet weak var cashBtn: UIButton!{
        didSet{
            cashBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cash", comment: ""), for: .normal)
        }
    }
    
    @IBOutlet weak var cardBtn: UIButton!{
        didSet{
            cardBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Card", comment: ""), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paywithL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "paywith", comment: "")

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionDebitCard(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
        self.paymentType?(.card)
    }
    
    @IBAction func actionCash(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
        self.paymentType?(.cash)
    }
    
    @IBAction func addBtnn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddCardViewController") as! AddCardViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
