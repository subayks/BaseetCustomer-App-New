//
//  ProfileViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var TestVieww: UIView!
    @IBOutlet weak var phoneVieww: UIView!
    @IBOutlet weak var emialVieww: UIView!
    @IBOutlet weak var nameVieww: UIView!
    @IBOutlet weak var profileBgVieww: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var TitleNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailId: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var namePLbl: UILabel!
    @IBOutlet weak var emailPLbl: UILabel!
    @IBOutlet weak var mobileNumberPlbl: UILabel!
    @IBOutlet weak var addressPLbl: UILabel!
    
    @IBOutlet weak var logOut: UIButton!
    var profileViewModel = ProfileViewModel()
    var logOut_vc: LogoutVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logOut.isHidden = true
        namePLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Name", comment: "")
        emailPLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email", comment: "")
        mobileNumberPlbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Mobile Number", comment: "")
        addressPLbl.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "Address", comment: "")
        
        logOut.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LogOut", comment: ""), for: .normal)
       
        logOut_vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutVC") as? LogoutVC
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
        
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false
        {
            TestVieww.isHidden = true
            phoneVieww.isHidden = true
            emialVieww.isHidden = true
            nameVieww.isHidden = true
            profileBgVieww.isHidden = true
            profileImage.isHidden = true
            let vc = self.storyboard?.instantiateViewController(identifier: "tabVC")
            vc!.modalPresentationStyle = .fullScreen
            isfromprofile = "fromProfileLogin"
            self.present(vc!, animated: true, completion: nil)
            
        }else{
            TestVieww.isHidden = false
            phoneVieww.isHidden = false
            emialVieww.isHidden = false
            nameVieww.isHidden = false
            profileBgVieww.isHidden = false
            profileImage.isHidden = false
            self.profileViewModel.showLoadingIndicatorClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.showLoadingView()
                }
            }
            
            self.profileViewModel.hideLoadingIndicatorClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.hideLoadingView()
                }
            }
            
            self.profileViewModel.alertClosure = { [weak self] (error) in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            self.profileViewModel.setupValuesClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.TitleNameLabel.text = self.profileViewModel.customerInfoModel?.fName
                    self.nameLabel.text = self.profileViewModel.customerInfoModel?.fName
                    self.phoneNumber.text = self.profileViewModel.customerInfoModel?.phone
                    self.emailId.text = self.profileViewModel.customerInfoModel?.email
                    self.addressLabel.text = UserDefaults.standard.string(forKey: "Location_Info")
                    self.phoneNumberLabel.text = self.profileViewModel.customerInfoModel?.phone
                    self.profileImage.loadImageUsingURL(self.profileViewModel.customerInfoModel?.appImage)
                }
            }
            self.profileViewModel.getCustomerInfo()
        }
        
        
    }
    
    func show_menu(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LogoutVC") as! LogoutVC
        vc.modalTransitionStyle = .crossDissolve
       // vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logoutpopViewBtn(_ sender: Any) {
        show_menu()
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController
        vc.modalPresentationStyle = .fullScreen
        vc.editProfileViewModel = self.profileViewModel.getEditProfileViewModel()
        self.present(vc, animated: true, completion: nil)
    }
}
