//
//  LogoutVC.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class LogoutVC: UIViewController {
    @IBOutlet weak var logoutlBl: UIButton!
    
    @IBOutlet weak var cancelLbl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutDiscription.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "logoutLbl", comment: "")
        logoutlBl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LOGOUT", comment: ""), for: .normal)
        cancelLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CANCEL", comment: ""), for: .normal)
        
       
        
        // Do any additional setup after loading the view.
    }
   
    
    @IBOutlet weak var logoutDiscription: UILabel!
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func Logout(_ sender: Any) {
        UserDefaults.resetStandardUserDefaults()
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LocationAccessVC") as! LocationAccessVC
        let navigationController = UINavigationController(rootViewController: viewController )
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
//
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        
    }
    
}
