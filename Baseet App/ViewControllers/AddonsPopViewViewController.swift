//
//  AddonsPopViewViewController.swift
//  Baseet App
//
//  Created by apple on 21/11/22.
//

import UIKit
import Alamofire

class AddonsPopViewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet weak var tblVieww: UITableView!
    var addonPriceArray = [Int]()
    var addonNameArray = [String]()
    var idName:String!
    var productName:String!
    var productID = [String]()
    var foodItems: [FoodItems]?
    var cartId:String!
    var cartIdArray = [String]()
    var addonQuantity:String!
    var addonId:Int!
    var food_qtyArray = [String]()
    var cartfoodidArray = [String]()
    var cartFoodId:String!
    var foodQuantity:String!
    var cartAddonsId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVieww.delegate = self
        self.tblVieww.dataSource = self
        self.AddonsData()
        self.getAddonsCart()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func getAddonsCart(){
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false
        {
            showToast(message: "Please Login To Acess This Feature", font: .systemFont(ofSize: 16))
        }else{
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
            let userid = UserDefaults.standard.string(forKey: "User_Id")
            print(headers)
            AF.request("\(Constants.Common.finalURL)/products/get_cart?user_id=\(userid!)", method: .get, encoding: JSONEncoding.default,headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let json):
                            print(json)
                            guard let response = json as? NSDictionary else{
                                return
                            }
                            
                            let data = response["data"] as! Array<Any>
                            for dic in data{
                                let mydic = dic as! [String:AnyObject]
                                let id = mydic["id"] as! String
                                let cart_id = mydic["cartid"] as! String
                                self.cartIdArray.append(cart_id)
                                let food_qty = mydic["food_qty"] as! String
                                let cartfoodid = mydic["cartfoodid"] as! String
                                self.cartfoodidArray.append(cartfoodid)
                                self.food_qtyArray.append(food_qty)
                                guard let addon = mydic["addon"] as? Array<Any> else{
                                    return
                                }
                                if addon.isEmpty{
                                    self.showToast(message: "No AddOn Found", font: .systemFont(ofSize: 16))
                                }else{
                                    for myAdd in addon{
                                        let myAdddic = myAdd as! NSDictionary
                                        let addonname = myAdddic["addonname"] as! String
                                        let addonprice = myAdddic["addonprice"] as! String
                                        UserDefaults.standard.set(addonprice, forKey: "addonPrice")
                                        let addonquantity = myAdddic["addonquantity"] as! String
                                        let id = myAdddic["id"] as! String
                                        self.addonNameArray.append(addonname)
                                        
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
    
    
    func AddonsData(){
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false
        {
            showToast(message: "Please Login To Acess This Feature", font: .systemFont(ofSize: 16))
        }else{
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
            let userid = UserDefaults.standard.string(forKey: "User_Id")
            let resID =  Int((UserDefaults.standard.string(forKey: "RestaurentId") ?? "") as String)
            print(headers)
            AF.request("\(Constants.Common.finalURL)/products/product_by_restaurant?restaurant_id=\(resID!)&category_id=0&limit=20&offset=1", method: .get, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { [self] response in
                        switch response.result {
                        case .success(let json):
                            print(json)
                            guard let response = json as? NSDictionary else{
                                return
                            }
                            self.addonPriceArray.removeAll()
                            self.addonNameArray.removeAll()
                            self.productID.removeAll()
                            let data = response["products"] as! Array<Any>
                            for dic in data{
                                let mydic = dic as! [String:AnyObject]
                                let id = mydic["id"] as! Int
                                if idName == String(id){
                                    self.productID.append(String(id))
                                    print(self.productID)
                                    let addon = mydic["add_ons"] as! Array<Any>
                                    if addon.isEmpty{
                                        self.showToast(message: "No AddOn Found", font: .systemFont(ofSize: 16))
                                    }else{
                                        for myAdd in addon{
                                            let myAdddic = myAdd as! NSDictionary
                                            let addonname = myAdddic["name"] as! String
                                            let addonprice = myAdddic["price"] as! Int
                                            self.addonNameArray.append(addonname)
                                            self.addonPriceArray.append(addonprice)
                                            print(addonPriceArray)
                                        }
                                    }
                                }else{
                                    showToast(message: "No Data Found", font: .systemFont(ofSize: 16))
                                }
                                
                            }
                            DispatchQueue.main.async {
                                self.tblVieww.reloadData()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addonNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVieww.dequeueReusableCell(withIdentifier: "cell") as! AddonPopUpViewTableViewCell
            cell.selectionStyle = .none
            cell.priceLbl.text = "\(addonPriceArray[indexPath.row])"
            cell.foodItem.text = addonNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let price = addonPriceArray[indexPath.row]
        self.cartFoodId = cartfoodidArray[indexPath.row]
        self.foodQuantity = food_qtyArray[indexPath.row]
        self.cartId = cartIdArray[indexPath.row]
        self.UpdateCart()
    }
    
    func UpdateCart(){
        if Reachability.isConnectedToNetwork(){
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
            let parameters = [
                "token": token!,"food_id":"\(cartFoodId!)","food_qty":"\(foodQuantity!)","addon":["addonname":"chickenBiryani","addonprice":"10","addonquantity":"0","id":"46"],"cart_id":"\(self.cartId!)"
            ] as! [String : Any]
            print(parameters)
                let url = "\(Constants.Common.finalURL)/products/update_cart"
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
                        response in
                        switch (response.result) {
                        case .success(let JSON):
                            print(response)
                            let response = JSON as! NSDictionary
                            print(response)
                            let message = response["message"] as! String
                            if message == "Cart Updated Successfully"{
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: message, comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            break
                        case .failure:
                           
                            print(Error.self)
                            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            break
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
