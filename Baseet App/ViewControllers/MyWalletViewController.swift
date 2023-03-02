//
//  MyWalletViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 12/07/22.
//

import UIKit

class MyWalletViewController: UIViewController {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var card_VC: MyWalletViewController!
    
    @IBOutlet weak var myWalletL: UILabel!
    @IBOutlet weak var addMonyWL: UILabel!
    @IBOutlet weak var proceedtAdd: UIButton!
    @IBOutlet weak var anyDebitorCreditL: UILabel!
    @IBOutlet weak var addnewCrdL: UIButton!
    @IBOutlet weak var termsandConditionsL: UIButton!
    
    @IBOutlet weak var walletBalance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walletBalance.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "walletBalance", comment: "")
        myWalletL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "myWalletL", comment: "")
        
        addMonyWL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "addMonyWL", comment: "")
        proceedtAdd.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "proceedtAdd", comment: ""), for: .normal)
        anyDebitorCreditL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "anyDebitorCreditL", comment: "")
        addnewCrdL.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "addnewCrdL", comment: ""), for: .normal)
        termsandConditionsL.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "TermsConditions", comment: ""), for: .normal)
        
        
        
        
        
        
        
        self.setupNavigationBar()
        
        card_VC = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
        

        // Do any additional setup after loading the view.
    }
    
    func show_menu(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddCardViewController") as! AddCardViewController
        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.nameLabel.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.nameLabel.isHidden = false
            self.nameLabel.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
   
    
    func close_menu()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCardBtn(_ sender: Any)
    {
        show_menu()
    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer)
    {
        switch gesture.direction
        {
        case UISwipeGestureRecognizer.Direction.right:
            show_menu()
        case UISwipeGestureRecognizer.Direction.left:
            close_menu()
        default:
            break
        }
    }
    
    @IBAction func myWalletBackBtn(_ sender: Any) {
        
        self.dismiss(animated: true,completion: nil)
    }
    

}

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
