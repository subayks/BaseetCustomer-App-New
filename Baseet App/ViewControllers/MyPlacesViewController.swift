//
//  MyPlacesViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit
import Alamofire

var MyPlacesZoneId:String!

class MyPlacesViewController: UIViewController {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPlacesTB: UITableView!
    var alertClosure:((String)->())?
    var addressArray = [String]()
    var latitudeArray = [String]()
    var longtitudeArray = [String]()
    var nameArray = [String]()
    var phoneNumberArray = [String]()
    var zoneIdArray = [Int]()
    var addresidArray = [Int]()
    var adressId:Int!
   var addressTypeArray = [String]()
    
    @IBOutlet weak var myplacesL: UILabel!
    @IBOutlet weak var myplacesDoha: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myplacesL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "myplaces", comment: "")
        myplacesDoha.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "myplacesDoha", comment: "")
        self.setupNavigationBar()
        self.myPlaces()
        self.myPlacesTB.delegate = self
        self.myPlacesTB.dataSource = self
        myPlacesTB.separatorStyle = .none
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        profileIcon.addGestureRecognizer(tapGestureRecognizer)
        profileIcon.isUserInteractionEnabled = true
    }
    
    @IBAction func myPlacesBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc private func didTapImageView(_ sender: UITapGestureRecognizer) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLocationViewController") as! ChangeLocationViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.nameLabel.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.nameLabel.isHidden = false
            self.nameLabel.text = "Add New Place"
            //UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
    
    func myPlaces(){
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false
        {
            showToast(message: "Please Login To Acess This Feature", font: .systemFont(ofSize: 16))
        }else{
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
            print(headers)
            AF.request("\(Constants.Common.finalURL)/customer/address/list", method: .get, encoding: JSONEncoding.default,headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let json):
                            print(json)
                            guard let response = json as? Array<Any> else{
                                return
                            }
                            if response.isEmpty{
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "No Places found.", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                self.latitudeArray.removeAll()
                                self.longtitudeArray.removeAll()
                                self.addressArray.removeAll()
                                self.zoneIdArray.removeAll()
                                self.nameArray.removeAll()
                                self.phoneNumberArray.removeAll()
                                self.addressTypeArray.removeAll()
                                for mydic in response{
                                    let dic = mydic as! [String:AnyObject]
                                    let address = dic["address"] as! String
                                    let latitude = dic["latitude"] as! String
                                    let longtitude = dic["longitude"] as! String
                                    let contact_person_number = dic["contact_person_number"] as? String ?? "\(UserDefaults.standard.string(forKey: "PhoneNumber")!)"
                                    let contact_person_name = dic["contact_person_name"] as? String
                                    let id = dic["id"] as? Int ?? 0
                                    self.addresidArray.append(id)
                                    let zone_id = dic["zone_id"] as! Int ?? 0
                                    let address_type = dic["address_type"] as? String
                                    self.latitudeArray.append(latitude)
                                    self.longtitudeArray.append(longtitude)
                                    self.addressArray.append(address)
                                    self.zoneIdArray.append(zone_id)
                                    self.nameArray.append(contact_person_name ?? "UnKnown")
                                    self.phoneNumberArray.append(contact_person_number)
                                    self.addressTypeArray.append(address_type ?? "UnKnown")
                                    DispatchQueue.main.async {
                                        self.myPlacesTB.reloadData()
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            print(error)
                            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                }
        }
        }
        

}

extension MyPlacesViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyPlacesTableViewCell
        cell.locationLbl.text = "\(addressArray[indexPath.row])"
        let addType = addressTypeArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "tabVC")
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        MyPlacesZoneId = "1"
        UserDefaults.standard.set(latitudeArray[indexPath.row], forKey: "lat")
        UserDefaults.standard.set(longtitudeArray[indexPath.row], forKey: "long")
        UserDefaults.standard.set(addressArray[indexPath.row], forKey: "myPlaces")
        self.present(vc, animated: true, completion: nil)
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
        
        let add = UIContextualAction(style: .normal, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete", comment: "")) { (contextualAction, view, actionPerformed: @escaping (Bool) -> Void) in
                
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Are you sure you want to delete the Address", comment: ""), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "No", comment: ""), style: .cancel, handler: { (alertAction) in
            actionPerformed(false)
            }))

            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Yes", comment: ""), style: .destructive, handler: { (alertAction) in
           
                self.adressId = self.addresidArray[indexPath.row]
                self.deleteApi()
            }))
                    
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [add])
    }
    
    func deleteApi(){
        if Reachability.isConnectedToNetwork(){
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)"
            ]
            print(headers)
            let parameters = [
                "address_id": "\(self.adressId!)"
                ]
            print(parameters)
            AF.request("\(Constants.Common.finalURL)/customer/address/delete", method: .delete, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { [self] response in
                        switch response.result {
                        case .success(let json):
                            let response = json as! NSDictionary
                            print(response)
                             let message = response["message"] as? String
                                print(message)
                            if message == "Successfully removed!"{
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: message!, comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                    self.myPlaces()
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
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
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: "Please Check Internet Connection"), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    
    
    
}
