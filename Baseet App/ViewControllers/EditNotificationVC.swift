//
//  EditNotificationVC.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class EditNotificationVC: UIViewController {

    @IBOutlet weak var editNotifL: UILabel!
    
    @IBOutlet weak var showall: UILabel!
    @IBOutlet weak var hideall: UILabel!
    @IBOutlet weak var dontshow: UILabel!
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        showall.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "showall", comment: "")
        hideall.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "hideall", comment: "")
        dontshow.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "dontshow", comment: "")
        saveBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "saveBtn", comment: ""), for: .normal)
        self.setupNavigationBar()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.nameLabel.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.nameLabel.isHidden = false
            self.nameLabel.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
            self.profileIcon.loadImageUsingURL(UserDefaults.standard.string(forKey: "ProfileImage"))
        }
    }

}
