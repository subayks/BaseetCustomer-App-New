//
//  SearchRestaurentVC.swift
//  Baseet App
//
//  Created by Subendran on 21/09/22.
//

import UIKit
import SearchTextField
import Alamofire


class SearchRestaurentVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchHereTF: SearchTextField!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchBarField: UISearchBar!
    
    var searchRestaurentVM = SearchRestaurentVM()
    
    var restarentDishViewControllerVM: RestarentDishViewControllerVM?
    
    var restaurantsArray = [String]()
    
    var productsArray = [String]()
    
    var searchingField:String!
    
    @IBOutlet weak var restaurantNameLbl: UILabel!
    
    @IBOutlet weak var RestaurantBtn: UIButton!{
        didSet{
            self.RestaurantBtn.layer.cornerRadius = 10
            self.RestaurantBtn.layer.masksToBounds = true
        }
    }
    
    var itemsID:String!
    
    var restaurantstId:String!
    
    @IBOutlet weak var itemsBtn: UIButton!{
        didSet{
            self.itemsBtn.layer.cornerRadius = 10
            self.itemsBtn.layer.masksToBounds = true
        }
    }
    var query = ""
    
    @IBOutlet weak var searchTopLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "searchBarText", comment: "")
        searchTopLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search For Restaurents", comment: "")
        // Do any additional setup after loading the view.
//            let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//           view.addGestureRecognizer(tap)
        self.itemsBtn.titleLabel?.textColor = UIColor.red
        self.RestaurantBtn.addTarget(self, action: #selector(RestaurantBtnAction), for: .touchUpInside)
        self.itemsBtn.addTarget(self, action: #selector(ItemsAction), for: .touchUpInside)
        
        self.searchHereTF.delegate = self
    }
    

    
    func searchNames(){
        let token = UserDefaults.standard.string(forKey: "zoneID")
        let headers : HTTPHeaders = [
            "zoneId": "\(token!)"
        ]
        print(headers)
        print("\(Constants.Common.finalURL)/restaurants/search?name=\(searchHereTF.text!)")
        AF.request("\(Constants.Common.finalURL)/restaurants/search?name=\(searchHereTF.text!)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { [self] response in
                    switch response.result {
                    case .success(let json):
                        print(json)
                        let response = json as! [String:AnyObject]
                        self.restaurantsArray.removeAll()
                        self.productsArray.removeAll()
                       /* guard let message = response["errors"] as? [String:AnyObject] else{
                            return
                        }*/
                        DispatchQueue.main.async {
                            let restaurants = response["restaurants"] as? Array<Any>
                            for i in 0 ..< (restaurants?.count ?? 0){
                                let x = restaurants![i] as! [String:AnyObject]
                                let name = x["name"] as? String ?? ""
                                self.restaurantsArray.append(name)
                            }
                            let products = response["products"] as? Array<Any>
                            for i in 0 ..< (products?.count ?? 0){
                                let x = products![i] as! [String:AnyObject]
                                let name = x["name"] as? String ?? ""
                                self.productsArray.append(name)
                            }
                            self.restaurantsArray.append(contentsOf: self.productsArray)
                        }
                        
                    case .failure(let error):
                        print(error)
                       /* let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)*/
                    }
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        query = searchHereTF.text ?? ""
        
        if restaurantstId == "0"{
            self.searchRestaurentVM.getSearchItem(query: searchHereTF.text ?? "")
        }
         if itemsID == "1"{
            self.searchRestaurentVM.getSearchProductItem(query: searchHereTF.text ?? "")
        }
        self.searchHereTF.endEditing(true)
    }

    fileprivate func configureSimpleSearchTextField() {
        if searchHereTF.text!.count > 2{
            searchHereTF.startVisibleWithoutInteraction = true
            searchHereTF.filterStrings(restaurantsArray)
            print(restaurantsArray)
        }
            
       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.searchHereTF{
            searchNames()
            configureSimpleSearchTextField()
        }
        return true;
    }
    
    @objc func RestaurantBtnAction(){
        query = searchingField!
        restaurantstId = "0"
        itemsID = ""
        searchBarField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "searchBarText", comment: "")
        self.itemsBtn.backgroundColor = UIColor.white
        self.itemsBtn.titleLabel?.textColor = UIColor.red
        self.RestaurantBtn.backgroundColor = UIColor.red
        self.RestaurantBtn.titleLabel?.textColor = UIColor.white
        self.RestaurantBtn.titleLabel?.tintColor = UIColor.white
        print(searchingField!)
        self.searchingField = query
        self.searchRestaurentVM.getSearchItem(query: searchingField!)
        if (self.searchRestaurentVM.searchModel?.restaurants?.count == 0 ||  self.searchRestaurentVM.searchModel?.restaurants?.count == nil){
            self.showToast(message: "No Restaurants Found", font: .systemFont(ofSize: 16))
        }else{
            if query != "" {
                restaurantstId = "0"
                itemsID = ""
                print(searchingField!)
                self.searchingField = query
                self.searchRestaurentVM.getSearchItem(query: searchingField!)
            }
        }
    }
    @objc func ItemsAction(){
        query = searchingField!
        itemsID = "1"
        restaurantstId = ""
        searchBarField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "searchBarItemText", comment: "")
        self.RestaurantBtn.backgroundColor = UIColor.white
        self.RestaurantBtn.titleLabel?.textColor = UIColor.red
        self.itemsBtn.backgroundColor = UIColor.red
        self.itemsBtn.titleLabel?.textColor = UIColor.white
        self.itemsBtn.tintColor = UIColor.white
        itemsID = "1"
        restaurantstId = ""
        self.searchingField = query
        print(query)
        self.searchRestaurentVM.getSearchProductItem(query: query)
        if (self.searchRestaurentVM.searchModel?.products?.count == 0 ||  self.searchRestaurentVM.searchModel?.products?.count == nil){
            self.showToast(message: "No Items Found", font: .systemFont(ofSize: 16))
        }else{
            if query != "" {
                itemsID = "1"
                restaurantstId = ""
                self.searchingField = query
                print(query)
                self.searchRestaurentVM.getSearchProductItem(query: query)
            }
        }
       
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.restaurantsArray.removeAll()
        self.productsArray.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchRestaurentVM.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.searchTableView.reloadData()
            }
        }
        
        self.searchRestaurentVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.searchRestaurentVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.searchRestaurentVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.searchRestaurentVM.searchModel = nil
                self.searchTableView.reloadData()
            }
        }
        
        self.searchRestaurentVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestarentDishViewController") as! RestarentDishViewController
                // vc.modalTransitionStyle = .coverVertical
                vc.restarentDishViewControllerVM = self.searchRestaurentVM.getRestarentDishViewControllerVM()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if query != "" {
            self.searchBarField.text = query
            self.searchRestaurentVM.getSearchItem(query: query)
        }
        
        if restaruantItems == "EmptyRestaurants"{
            restaurantstId = ""
            itemsID = "1"
            if restaurantstId == "0"{
                query = self.searchingField ?? ""
                itemsBtn.setTitleColor(.red, for: .normal)
                RestaurantBtn.backgroundColor = UIColor.red
                RestaurantBtn.setTitleColor(.white, for: .normal)
                itemsBtn.backgroundColor = UIColor.white
                itemsBtn.tintColor = UIColor.red
                self.searchRestaurentVM.getSearchItem(query: searchingField ?? "")
            }else{
                query = self.searchingField ?? ""
                RestaurantBtn.setTitleColor(.red, for: .normal)
                itemsBtn.backgroundColor = UIColor.red
                itemsBtn.setTitleColor(.white, for: .normal)
                RestaurantBtn.backgroundColor = UIColor.white
                RestaurantBtn.tintColor = UIColor.red
                itemsBtn.tintColor = UIColor.white
                print(searchHereTF.text!)
                self.searchRestaurentVM.getSearchProductItem(query: searchingField ?? "")
            }
            self.searchHereTF.endEditing(true)
        }else{
            restaurantstId = "0"
            itemsID = ""
            if restaurantstId == "0"{
                query = self.searchingField ?? ""
                itemsBtn.setTitleColor(.red, for: .normal)
                RestaurantBtn.backgroundColor = UIColor.red
                RestaurantBtn.setTitleColor(.white, for: .normal)
                itemsBtn.backgroundColor = UIColor.white
                itemsBtn.tintColor = UIColor.red
                self.searchRestaurentVM.getSearchItem(query: searchingField ?? "")
            }else{
                query = self.searchingField ?? ""
                RestaurantBtn.setTitleColor(.red, for: .normal)
                itemsBtn.backgroundColor = UIColor.red
                itemsBtn.setTitleColor(.white, for: .normal)
                itemsBtn.tintColor = UIColor.white
                RestaurantBtn.backgroundColor = UIColor.white
                RestaurantBtn.tintColor = UIColor.red
                print(searchHereTF.text!)
                self.searchRestaurentVM.getSearchProductItem(query: searchingField ?? "")
            }
            self.searchHereTF.endEditing(true)
        }
 
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true)
        self.restaurantsArray.removeAll()
        self.productsArray.removeAll()
        restaruantItems = ""
        productItems = ""
        self.searchingField = ""
    }
}

extension SearchRestaurentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.searchRestaurentVM.searchModel?.restaurants?.count != nil && self.searchRestaurentVM.searchModel?.restaurants?.count != 0) && (self.searchRestaurentVM.searchModel?.products?.count != nil && self.searchRestaurentVM.searchModel?.products?.count != 0) {
            return 5
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfSections(in: tableView) == 2 {
            if section == 1 {
                return 1
            } else {
                return self.searchRestaurentVM.searchModel?.restaurants?.count ?? 0
            }
        } else {
            if self.searchRestaurentVM.searchModel?.products?.count ?? 0 > 0 {
                return  1
            } else {
                return self.searchRestaurentVM.searchModel?.restaurants?.count == 0 ? 1: self.searchRestaurentVM.searchModel?.restaurants?.count ?? 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if numberOfSections(in: tableView) == 1 {
            if (self.searchRestaurentVM.searchModel?.restaurants?.count != 0 &&  self.searchRestaurentVM.searchModel?.restaurants?.count != nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurentCell", for: indexPath) as! RestaurentCell
                cell.homeCollectionViewDownCellVM = self.searchRestaurentVM.getMyFevTableViewCellVM(index: indexPath.row)
                return cell
            } else if  (self.searchRestaurentVM.searchModel?.products?.count != 0 &&  self.searchRestaurentVM.searchModel?.products?.count != nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemTableViewCell", for: indexPath) as! FoodItemTableViewCell
                cell.itemId = { (id) in
                    DispatchQueue.main.async {
                        self.searchRestaurentVM.makeShopDetailsCall(id: id)
                    }
                }
                cell.foodItemTableViewCellVM = self.searchRestaurentVM.getFoodItemTableViewCellVM()
                return cell
            }
            else {
                if (self.searchRestaurentVM.searchModel?.restaurants?.count == 0 ||  self.searchRestaurentVM.searchModel?.restaurants?.count == nil) ||  (self.searchRestaurentVM.searchModel?.products?.count == 0 ||  self.searchRestaurentVM.searchModel?.products?.count == nil) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NoResultFoundCell", for: indexPath) as! NoResultFoundCell
                    if self.searchingField == "" {
                        cell.noResultLabel.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "No Result Found", comment: "")
                    } else {
                        cell.noResultLabel.text = "No Result Found"
                    }
                    return cell
                }
            }
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemTableViewCell", for: indexPath) as! FoodItemTableViewCell
                cell.foodItemTableViewCellVM = self.searchRestaurentVM.getFoodItemTableViewCellVM()
                cell.itemId = { (id) in
                    DispatchQueue.main.async {
                        self.searchRestaurentVM.makeShopDetailsCall(id: id)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurentCell", for: indexPath) as! RestaurentCell
                cell.homeCollectionViewDownCellVM = self.searchRestaurentVM.getMyFevTableViewCellVM(index: indexPath.row)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.searchRestaurentVM.searchModel?.restaurants?[indexPath.row].id else { return }
        self.searchRestaurentVM.makeShopDetailsCall(id: id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if numberOfSections(in: tableView) == 1 {
            if (self.searchRestaurentVM.searchModel?.restaurants?.count != 0 &&  self.searchRestaurentVM.searchModel?.restaurants?.count != nil) {
                return 293
            }else{
                return 500
            }
        }
        return 0
        
    }
}

//Textfield delegates
extension SearchRestaurentVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query = searchBar.text ?? ""
        if restaurantstId == "0"{
            self.searchRestaurentVM.getSearchItem(query: searchingField ?? "")
        }
         if itemsID == "1"{
            self.searchRestaurentVM.getSearchProductItem(query: searchingField ?? "")
        }
        self.searchBarField.endEditing(true)
    }
    
//    func navigateToAdOnView(itemCount: Int, index: Int, addon: [AddOns]? = nil) {
//        let foodItem = self.restarentDishViewControllerVM?.foodItems?[index]
//        if foodItem?.addOns != nil && foodItem?.addOns?.count ?? 0 > 0 {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
//        vc.addOnViewControllerVM = self.restarentDishViewControllerVM?.getAddOnViewControllerVM(index: index)
//        vc.addOns  = { (addOns) in
//            DispatchQueue.main.async {
//                self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns)
//            }
//        }
//        vc.modalTransitionStyle  = .crossDissolve
//       // vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//        } else {
//            self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index)
//        }
//    }
}
