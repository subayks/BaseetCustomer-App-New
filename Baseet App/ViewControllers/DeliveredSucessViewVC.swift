//
//  DeliveredSucessViewVC.swift
//  Baseet App
//
//  Created by VinodKatta on 26/07/22.
//

import UIKit

class DeliveredSucessViewVC: UIViewController {
    
    @IBOutlet weak var foodItemsList: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    var deliveredSucessViewVM: DeliveredSucessViewVM?
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.orderPrice.text = "Paid \(self.deliveredSucessViewVM?.orderTrackModel?.orderAmount ?? 0) QR"
        print(self.orderPrice.text!)
        self.foodItemsList.text = self.deliveredSucessViewVM?.getFoodItemsList()
        closeButton.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FeedbackViewController") as! FeedbackViewController
        vc.feedbackViewModel = self.deliveredSucessViewVM?.getFeedbackViewModel()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func closeBtn(){
        self.dismiss(animated: true)
    }
    
}


