//
//  SettingsViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 11/07/22.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var settingsTB: UITableView!
    var userid:String!
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    
    @IBOutlet weak var settingsL: UILabel!
    
    var settingsViewModel = SettingsViewModel()
    let settingnamesArray = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "Edit", comment: ""),
                            // LocalizationSystem.sharedInstance.localizedStringForKey(key: "Security", comment: ""),
//                             LocalizationSystem.sharedInstance.localizedStringForKey(key: "Notifications", comment: ""),
                             LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change Location", comment: ""),
                             LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete Account", comment: "")]
    
    var logoImage: [UIImage] = [
        UIImage(named: "edit_profile")!,
        //UIImage(named: "scecurity")!,
       // UIImage(named: "notication")!,
        UIImage(named: "change_location")!,
        UIImage(named: "DeleteAccount")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "settingsL", comment: "")
        self.setupNavigationBar()
        //profileImage.image = UIImage.init(named: UserDefaults.standard.string(forKey: "ProfileImage")!)
        let image = UserDefaults.standard.string(forKey: "ProfileImage")
        if image == nil{
            
        }else
        {
            profileImage.downloaded(from: image!,contentMode: .scaleAspectFill)
            profileImage.MakeRounded()
        }
        
        nameLabel.text = UserDefaults.standard.string(forKey: "Name")
        let name = UserDefaults.standard.string(forKey: "Name")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.settingsViewModel.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.settingsViewModel.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.settingsViewModel.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.settingsViewModel.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let vc = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController
                vc.modalPresentationStyle = .fullScreen
                vc.editProfileViewModel = self.settingsViewModel.getEditProfileViewModel()
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func settingsBackBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileImage.isHidden = true
            self.nameLabel.isHidden = true
        } else {
            self.profileImage.isHidden = false
            self.nameLabel.isHidden = false
            self.nameLabel.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingnamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        
        cell.settinglbl.text = settingnamesArray[indexPath.row]
        cell.settingImge.image = logoImage[indexPath.row]
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0
        {
            self.settingsViewModel.getCustomerInfo()
        }
//        if indexPath.row == 2{
//
////            let vc = self.storyboard?.instantiateViewController(identifier:  "MyOrderVC") as! MyOrderVC
////            vc.modalPresentationStyle = .fullScreen
////            self.present(vc, animated: true, completion: nil)
//        }
        if indexPath.row == 1{

            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLocationViewController") as! ChangeLocationViewController
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
        if indexPath.row == 2{

//            let vc = self.storyboard?.instantiateViewController(identifier: "MyFavoritesViewController") as! MyFavoritesViewController
//           vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
            
           /* let storyboard = UIStoryboard.init(name: "MyPlacesStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "DeleteAccountViewController") as! DeleteAccountViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)*/
            
            let refreshAlert = UIAlertController(title: "", message: "Are You Sure You Want To Delete Account.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.deleteAccount()
            }))

            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                  
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func deleteAccount(){
        self.showLoadingIndicatorClosure?()
        if Reachability.isConnectedToNetwork(){
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)"
            ]
            print(headers)
            let parameters = ["":""]
            print(parameters)
            AF.request("\(Constants.Common.finalURL)/customer/inactive", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { [self] response in
                        switch response.result {
                        case .success(let json):
                            let response = json as! NSDictionary
                            print(response)
                            DispatchQueue.main.async {
                                let message = response["message"] as? String
                                   print(message)
                               if message == "messages.removed_successfully"{
                                   self.hideLoadingIndicatorClosure?()
                                   let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: message!, comment: ""), preferredStyle: UIAlertController.Style.alert)
                                   alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                       UserDefaults.resetStandardUserDefaults()
                                       if let bundleID = Bundle.main.bundleIdentifier {
                                           UserDefaults.standard.removePersistentDomain(forName: bundleID)
                                       }
                                       let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                       let viewController = storyboard.instantiateViewController(withIdentifier: "LocationAccessVC") as! LocationAccessVC
                                       let navigationController = UINavigationController(rootViewController: viewController )
                                       self.view.window?.rootViewController = viewController
                                       self.view.window?.makeKeyAndVisible()
                                   }))
                                   self.present(alert, animated: true, completion: nil)
                               }

                            }
                            
                        case .failure(let error):
                            print(error)
                            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                }
        }else{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: "Please Check Internet Connection"), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
}
