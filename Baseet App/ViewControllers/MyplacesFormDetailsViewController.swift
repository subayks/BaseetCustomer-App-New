//
//  MyplacesFormDetailsViewController.swift
//  Baseet App
//
//  Created by apple on 18/11/22.
//

import UIKit
import Alamofire

class MyplacesFormDetailsViewController: UIViewController {
    
    var finalDiscountAppledAmount:Int!
    
    var addressText:String!
     
    @IBOutlet weak var othersBtn: UIButton!
    
    @IBOutlet weak var workBtn: UIButton!
    
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var othersTF: UITextField!
    
    @IBOutlet weak var buildingNoTF: UITextField!
    
    @IBOutlet weak var zoneTF: UITextField!
    
    @IBOutlet weak var streetTF: UITextField!
    
    @IBOutlet weak var FloorTF: UITextField!
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    var restaurentFoodPicksVCVM: RestaurentFoodPicksVCVM?
    
    var myPlacesVCVM: MyPlacesVM?
    
    var locationDeliveryVCVM: LocationDeliveryVCVM?
    
    var btnALLTerritory = [UIButton]()
    
    var edit:String!
    
    var address_type:String!
    
    var mobileno:String!
    var name:String!
    var zoneID:Int!
    var address:String!
    var latitude:String!
    var longtitude:String!
    var home:String!
    var work:String!
    var others:String!
    
    @IBOutlet weak var editPlaceLbl: UILabel!{
        didSet{
            editPlaceLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add new Place", comment: "")
        }
    }
    
    @IBOutlet weak var saveBtn: UIButton!
    var locatonClosure:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            nameTF.textAlignment = .left
            addressTF.textAlignment = .left
            buildingNoTF.textAlignment = .left
            FloorTF.textAlignment = .left
            zoneTF.textAlignment = .left
            othersTF.textAlignment = .left
            FloorTF.textAlignment = .left
            streetTF.textAlignment = .left
            phoneNumberTF.textAlignment = .left
            
            
        }else{
            nameTF.textAlignment = .right
            addressTF.textAlignment = .right
            buildingNoTF.textAlignment = .right
            FloorTF.textAlignment = .right
            zoneTF.textAlignment = .right
            othersTF.textAlignment = .right
            FloorTF.textAlignment = .right
            streetTF.textAlignment = .right
            phoneNumberTF.textAlignment = .right
            
        }
       
        nameTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Name", comment: "")
        addressTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Address Short Name", comment: "")
        buildingNoTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Building No", comment: "")
        FloorTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Floor", comment: "")
        zoneTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Zone", comment: "")
        othersTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Others", comment: "")
        streetTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Street", comment: "")
        phoneNumberTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone No (Optional)", comment: "")
        homeBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Home", comment: ""), for: .normal)
        workBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Work", comment: ""), for: .normal)
        saveBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Save", comment: ""), for: .normal)
        othersTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Others", comment: "")
        if edit == "Edit Form"{
            self.addressTF.text = address!
            self.nameTF.text = name!
            self.zoneTF.text = "\(zoneID!)"
            self.phoneNumberTF.text = mobileno
            //self.editPlaceLbl.text = "Edit Place"
            //saveBtn.setTitle("Update", for: .normal)
            saveBtn.addTarget(self, action: #selector(Editplace), for: .touchUpInside)
        }else{
            self.addressTF.text = ""
            self.nameTF.text = ""
            self.zoneTF.text = ""
            self.phoneNumberTF.text = ""
            //self.editPlaceLbl.text = "Add New Place"
            //saveBtn.setTitle("Save", for: .normal)
            saveBtn.addTarget(self, action: #selector(Editplace), for: .touchUpInside)
        }
        
        self.latitude = UserDefaults.standard.string(forKey: "lat")
        self.longtitude = UserDefaults.standard.string(forKey: "long")
        
    }
    
    @objc func Editplace(){
        if latitude == nil{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Location Is Not Updated", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else if longtitude == nil{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Location Is Not Updated", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else if zoneTF.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "PLEASE ENTER ZONE", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else if buildingNoTF.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "PLEASE ENTER BUILDING NO", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else if streetTF.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "PLEASE ENTER STREET NO", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else if address_type == nil{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "PLEASE Select Address Type", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if Reachability.isConnectedToNetwork(){
                let token = UserDefaults.standard.string(forKey: "AuthToken")
                let headers : HTTPHeaders = [
                    "Authorization": " \(token!)"
                ]
                print(headers)
                let parameters = [
                    "address": "\(self.addressText!)",
                    "latitude": "\(self.latitude!)",
                    "longitude": "\(self.longtitude!)",
                    "contact_person_name": "\(self.nameTF.text!)",
                    "contact_person_number": "\(self.phoneNumberTF.text!)",
                    "building_no":"\(buildingNoTF.text!)",
                    "street":"\(streetTF.text!)",
                    "floor": "\(FloorTF.text!)",
                    "zone_id":"\(zoneTF.text!)",
                    "address_type":"\(address_type!)"
                    ]
                print(parameters)
                AF.request("\(Constants.Common.finalURL)/customer/address/add", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                    .responseJSON { [self] response in
                            switch response.result {
                            case .success(let json):
                                let response = json as! NSDictionary
                                print(response)
                                 let message = response["message"] as? String
                                    print(message)
                                if message == "Successfully added!"{
                                    if isFormPlaces == "isFormPlaces"{
                                        self.dismiss(animated: true)
                                        self.locatonClosure?()
                                    }else{
                                        let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: message!, comment: ""), preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                            let vc = storyboard.instantiateViewController(identifier: "MyPlacesViewController") as! MyPlacesViewController
                                            vc.modalTransitionStyle = .coverVertical
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true, completion: nil)
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
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func HomeBtnTap(_ sender: UIButton) {

        address_type = "Home"
        if sender.currentImage == UIImage(named: "radio-button"){

            sender.setImage(UIImage(named: "radio-button-2"), for: .normal)
            workBtn.setImage(UIImage(named: "radio-button"), for: .normal)
            othersBtn.setImage(UIImage(named: "radio-button"), for: .normal)
            
        }else{

            sender.setImage(UIImage(named: "radio-button"), for: .normal)
        }
    }
    
    @IBAction func WorkBtnTap(_ sender: UIButton) {
        address_type = "Work"
        if sender.currentImage == UIImage(named: "radio-button"){

            sender.setImage(UIImage(named: "radio-button-2"), for: .normal)
            homeBtn.setImage(UIImage(named: "radio-button"), for: .normal)
            othersBtn.setImage(UIImage(named: "radio-button"), for: .normal)

        }else{

            sender.setImage(UIImage(named: "radio-button"), for: .normal)
        }
    }
    
    @IBAction func OthersBtnTap(_ sender: UIButton) {
        address_type = "others"
        if sender.currentImage == UIImage(named: "radio-button"){

            sender.setImage(UIImage(named: "radio-button-2"), for: .normal)
            homeBtn.setImage(UIImage(named: "radio-button"), for: .normal)
            workBtn.setImage(UIImage(named: "radio-button"), for: .normal)

        }else{

            sender.setImage(UIImage(named: "radio-button"), for: .normal)
        }
    }
    

}
