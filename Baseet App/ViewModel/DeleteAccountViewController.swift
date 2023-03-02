//
//  DeleteAccountViewController.swift
//  Baseet App
//
//  Created by apple on 06/01/23.
//

import UIKit
import Alamofire

class DeleteAccountViewController: UIViewController {
    
    var userid:String!
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?

    @IBOutlet weak var sorrylbl: UILabel!
    @IBOutlet weak var deleteAccountlbl: UILabel!
    @IBOutlet weak var deleteAccountBtn: UIButton!{
        didSet{
            self.deleteAccountBtn.layer.cornerRadius = 15.0
            self.deleteAccountBtn.layer.masksToBounds = true
            self.deleteAccountBtn.layer.borderColor = hexStringToUIColor(hex: "#C42929").cgColor
            self.deleteAccountBtn.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var keepAccountBtn: UIButton!{
        didSet{
            self.keepAccountBtn.layer.cornerRadius = 15.0
            self.keepAccountBtn.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sorrylbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "We're sorry to see you", comment: "")
        deleteAccountlbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete Account", comment: "")
        deleteAccountBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete Account", comment: ""), for: .normal)
        keepAccountBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Nevermind, keep you account", comment: ""), for: .normal)
        self.deleteAccountBtn.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        keepAccountBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    @objc func backAction(){
        self.dismiss(animated: true)
    }
    
    
    
    @objc func deleteAccount(){
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
                                       /*UserDefaults.resetStandardUserDefaults()
                                       if let bundleID = Bundle.main.bundleIdentifier {
                                           UserDefaults.standard.removePersistentDomain(forName: bundleID)
                                       }
                                       let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                       let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                                       vc.modalPresentationStyle = .fullScreen
                                       self.present(vc, animated: true, completion: nil)*/
                                       
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
