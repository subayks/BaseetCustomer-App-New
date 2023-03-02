//
//  OverLayerView.swift
//  CustomPopUp
//
//  Created by Sajjad Sarkoobi on 8.07.2022.
//

import UIKit

class OverLayerView: UIViewController {

    //IBOutlets
    @IBOutlet weak var savingsCouponsLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    var QrAmount:String!
    var couponName:String!
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        hide()
    }
    @IBOutlet weak var codeNameLbl: UILabel!
    init() {
        super.init(nibName: "OverLayerView", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        self.savingsCouponsLbl.text = "QR \(QrAmount!) Savings With These Coupons."
        self.codeNameLbl.text = "\(couponName!) Coupon Code Applied Sucessfully."
    }
    
    private func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10
    }
    
    func appear(sender: RestaurentFoodPicksVC) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.2) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
       
    }
}
