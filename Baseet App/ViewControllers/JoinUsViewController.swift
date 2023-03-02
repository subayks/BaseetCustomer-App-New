//
//  JoinUsViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 19/07/22.
//

import UIKit

class JoinUsViewController: UIViewController {
    
    @IBOutlet weak var joinUsL: UILabel!
    @IBOutlet weak var designLblL: UILabel!
    @IBOutlet weak var businessLblL: UILabel!
    @IBOutlet weak var businessTypeL: UILabel!
    @IBOutlet weak var contactPeesonL: UILabel!
    @IBOutlet weak var MobileL: UILabel!
    @IBOutlet weak var emailL: UILabel!
    @IBOutlet weak var desciptionL: UILabel!
    
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var submitBtnn: UIButton!
    
    @IBOutlet weak var businessTF: UITextField!{
        didSet{
            businessTF.layer.borderColor = UIColor.white.cgColor
            businessTF.layer.cornerRadius = 30
            businessTF.layer.borderWidth = 1
            businessTF.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var bType: UITextField!{
        didSet{
            bType.layer.borderColor = UIColor.white.cgColor
            bType.layer.cornerRadius = 30
            bType.layer.borderWidth = 1
            bType.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var contactPersonTF: UITextField!{
        didSet{
            contactPersonTF.layer.borderColor = UIColor.white.cgColor
            contactPersonTF.layer.cornerRadius = 30
            contactPersonTF.layer.borderWidth = 1
            contactPersonTF.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var mobileTF: UITextField!{
        didSet{
            mobileTF.layer.borderColor = UIColor.white.cgColor
            mobileTF.layer.cornerRadius = 30
            mobileTF.layer.borderWidth = 1
            mobileTF.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var emailTF: UITextField!{
        didSet{
            emailTF.layer.borderColor = UIColor.white.cgColor
            emailTF.layer.cornerRadius = 30
            emailTF.layer.borderWidth = 1
            emailTF.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var descriptionTF: UITextField!{
        didSet{
            descriptionTF.layer.borderColor = UIColor.white.cgColor
            descriptionTF.layer.cornerRadius = 30
            descriptionTF.layer.borderWidth = 1
            descriptionTF.layer.masksToBounds = true
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        self.designLblL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "designLblLl", comment: "")
        self.joinUsL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "joinUsL", comment: "")
        self.businessLblL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "businessLblL", comment: "")
        self.businessTypeL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "businessTypeL", comment: "")
        self.contactPeesonL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "contactPeesonL", comment: "")
        self.MobileL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "MobileL", comment: "")
        self.emailL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "emailL", comment: "")
        self.desciptionL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "desciptionL", comment: "")
        self.signBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Sign In", comment: ""), for: .normal)
        self.submitBtnn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Submit", comment: ""), for: .normal)
        
        
        
        
       

        
    }
    

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    

}

extension UITextField {

    func underlined(){
        let border = CALayer()
        let width = CGFloat(10.0)
        border.borderColor = UIColor.white.cgColor
       
        border.borderWidth = width
        //self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
