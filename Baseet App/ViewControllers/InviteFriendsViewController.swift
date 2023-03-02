//
//  InviteFriendsViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 11/07/22.
//

import UIKit

class InviteFriendsViewController: UIViewController {

    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var refaralCodeL: UILabel!
    @IBOutlet weak var inviteFrndsL: UILabel!
    
    @IBOutlet weak var pastReferalL: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pastReferalL.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "pastReferalL", comment: "")
        refaralCodeL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "refaralCodeL", comment: "")
        inviteFrndsL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "inviteFrndsL", comment: "")
        
        self.setupNavigationBar()
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

    @IBAction func inviteBack(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
}
