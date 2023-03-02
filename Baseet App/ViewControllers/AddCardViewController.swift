//
//  AddCardViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 12/07/22.
//

import UIKit

class AddCardViewController: UIViewController {
    
    
    

    @IBOutlet weak var addCardView: UIView!
    
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var expirydateTF: UITextField!
    @IBOutlet weak var CvvTF: UITextField!
    @IBOutlet weak var cardHolderNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
//        self.hideView
//            .addGestureRecognizer(gesture)
        
//        backBtn.backgroundColor = UIColor.clear
//        backBtn!.layer.shadowColor =  UIColor.white.cgColor
        
//        hideView.frame = self.view.bounds
//        hideView.blurImage()
//        self.view.addSubview(self.hideView)
        
        addCardView.clipsToBounds = true
        addCardView.layer.cornerRadius = 30
        addCardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        
      
      
    }
    
    
//    @objc func checkAction(sender : UITapGestureRecognizer) {
//        print("yes")
//        self.dismiss(animated: true,completion: nil)
//    }

    
    
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
    }
    

   
}

extension UIView{
    func blurImage()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
