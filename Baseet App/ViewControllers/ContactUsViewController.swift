//
//  ContactUsViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 11/07/22.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weburlLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contactUsL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        contactUsL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "contactUsL", comment: "")
        self.setupNavigationBar()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction(_:)))
        emailLbl.addGestureRecognizer(tap)
        emailLbl.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        mobileNumberLbl.addGestureRecognizer(tap2)
        mobileNumberLbl.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapWeb(_:)))
        weburlLbl.addGestureRecognizer(tap3)
        weburlLbl.isUserInteractionEnabled = true
    }
    
    @objc func tapFunction(_ sender: UITapGestureRecognizer? = nil) {
        if !MFMailComposeViewController.canSendMail() {
                    print("Mail services are not available")
                    return
                }
                sendEmail()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let url: NSURL = URL(string: "TEL://97477161634")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
       
    }
    
    @objc func handleTapWeb(_ sender: UITapGestureRecognizer? = nil) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func sendEmail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients(["info@baseet.com"])
            composeVC.setSubject("Contact Team!")
            composeVC.setMessageBody("Contact Team To Solve Queries.", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }

   
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
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

    @IBAction func contactBackBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    

}
