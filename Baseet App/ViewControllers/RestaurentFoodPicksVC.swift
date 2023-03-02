//
//  RestaurentFoodPicksVC.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit
import Alamofire
import CoreLocation
var couponcodeValue:String!
var removeCoupon:Int!
var distance:Int!
var isFormPlaces:String!
var deliveryCharge:String!

class RestaurentFoodPicksVC: UIViewController,UIPopoverPresentationControllerDelegate,YourCellDelegate {
    
    
    @IBOutlet weak var ChooseBtn: UIButton!{
        didSet{
            ChooseBtn.layer.cornerRadius = 10.0
            ChooseBtn.layer.masksToBounds = true
            ChooseBtn.layer.borderWidth = 1.0
            ChooseBtn.layer.borderColor = UIColor.red.cgColor
        }
    }
    @IBOutlet weak var repeatBtn: UIButton!{
        didSet{
            repeatBtn.layer.cornerRadius = 10.0
            repeatBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var mainVieww: UIView!
    @IBOutlet weak var RepeatView: UIView!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationName: UIButton!
    @IBOutlet weak var savingsOverView: UIView!
    @IBOutlet weak var addSpecialNote: UIImageView!
    @IBOutlet weak var totalSavingsAmountLabel: UILabel!
    @IBOutlet weak var restaurentName: UILabel!
    @IBOutlet weak var restaurentImage: UIImageView!
    @IBOutlet weak var restFoodPick: UITableView!
    @IBOutlet weak var addSpecialNotLbl: UILabel!
    var restarentDishViewControllerVM: RestarentDishViewControllerVM?
    var removekey:String!
    var tprice:Int!
    var discount_type:String!
    var idArray = [String]()
    var discount:Double!
    var DiscountAmount:Double!
    var myTotalAmount:Double!
    var finalAmount:Double!
    var finalDiscountAppledAmount:Int!
    var totalDiscountWithoutCoupon:String!
    @IBOutlet weak var totalsavingLblL: UILabel!
    @IBOutlet weak var listofYourSelectedItemL: UILabel!
    @IBOutlet weak var addspecalNote: UILabel!
    var coupon_type:String!
    @IBOutlet weak var addspecialNotesImage: UIImageView!
    var addonPriceArray = [String]()
    var addonNameArray = [String]()
    var idName:String!
    var productID = [String]()
    var cartidArray = [String]()
    var ResAddonPriceArray = [Int]()
    var resID:Int!
    var changedValues:(([Int], [Int])->())?
    var locatonDelivery_VC: LocationDeliveryVC!
    var restaurentFoodPicksVCVM: RestaurentFoodPicksVCVM?
    var getCartModel: [CartDataModel]?
    var addonQuanittiyArray = [String]()
    var addonIdArray = [String]()
    var isMainVieww:String!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    var itemCout: Int?
    var isIncrementFlow: Bool?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("NewFunctionName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("ReduceFunctionName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideRepeatedViews), name: Notification.Name("RemovePopUpView"), object: nil)
        UserDefaults.standard.removeObject(forKey: "couponCode")
        UserDefaults.standard.removeObject(forKey: "Discount")
        totalsavingLblL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key:"totalsaving", comment: "")
        listofYourSelectedItemL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "listofselect", comment: "")
        addspecalNote.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "addspe", comment: "")
        
        self.setupValues()
        locatonDelivery_VC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDeliveryVC") as? LocationDeliveryVC
        let tap = UITapGestureRecognizer(target: self, action: #selector(RestaurentFoodPicksVC.tapFunction))
        addspecialNotesImage.isUserInteractionEnabled = true
        addspecialNotesImage.addGestureRecognizer(tap)
        restFoodPick.register(UINib(nibName: "BasketFooterViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "BasketFooterViewCell")
        self.setupNavigationBar()
        closeBtn.addTarget(self, action: #selector(hideRepeatedViews), for: .touchUpInside)
        ChooseBtn.addTarget(self, action: #selector(CustomizeAddons), for: .touchUpInside)
    }
    
    
    @objc func functionName (notification: NSNotification){
        finalDiscountAppledAmount = 0
        print(finalDiscountAppledAmount!)
        restFoodPick.reloadData()
    }
    
    @IBAction func actionRepeat(_ sender: Any) {
        self.restaurentFoodPicksVCVM?.decideFlow(itemCount: self.itemCout ?? 0, index: self.index ?? 0, isIncrementFlow: self.isIncrementFlow ?? false, repeatMode: true)
        self.RepeatView.isHidden = true
    }
    
    @IBAction func actionIChoose(_ sender: Any) {
        self.navigateToAdOnView(itemCount: self.itemCout ?? 0, index: self.index ?? 0, isIncrementFlow: self.isIncrementFlow ?? false)
        self.RepeatView.isHidden = true
    }
    
    @objc func hideRepeatedViews(){
        self.RepeatView.isHidden = true
    }
    
    @objc func functionChange (notification: NSNotification){
        finalDiscountAppledAmount = 0
        print(finalDiscountAppledAmount!)
        restFoodPick.reloadData()
    }
    
    func didTapButton(_ sender: UIButton) {
        let foodItem = self.restaurentFoodPicksVCVM?.shopDetailsModel?.products?[sender.tag]
        print(foodItem?.addOns! as Any)
        if foodItem?.addOns != nil && foodItem?.addOns?.count ?? 0 >= 0 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
            vc.addOnViewControllerVM = self.restaurentFoodPicksVCVM?.getAddOnViewControllerVM(index: sender.tag)
            vc.addOns  = { (addOns) in
                DispatchQueue.main.async {
                    self.restaurentFoodPicksVCVM?.decideFlow(itemCount: 1, index: sender.tag, addOns: addOns, isIncrementFlow: true)
                }
            }
            vc.makeCartCall = {
                self.restaurentFoodPicksVCVM?.decideFlow(itemCount: 1, index: sender.tag, isIncrementFlow: true)
            }
            vc.modalTransitionStyle  = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        } else {
            self.restaurentFoodPicksVCVM?.decideFlow(itemCount: 1, index: sender.tag, isIncrementFlow: true)
        }
    }
    
    @objc func RemoveCouponsGrandTotal(){
        self.finalDiscountAppledAmount == 0
        print(finalDiscountAppledAmount)
        restFoodPick.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.distanceBetweenKms()
        RepeatView.isHidden = true
        RepeatView.layer.cornerRadius = 10.0
        RepeatView.layer.masksToBounds = true
        self.totalSavingsAmountLabel.text = "QR 0.0"
        self.restaurentFoodPicksVCVM?.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                //self.totalSavingsAmountLabel.text = "QR \(Double(self.restaurentFoodPicksVCVM?.totalSaving() ?? 0))"
                self.restFoodPick.reloadData()
            }
        }
        
        self.restaurentFoodPicksVCVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.restaurentFoodPicksVCVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.restaurentFoodPicksVCVM?.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.restFoodPick.reloadData()
            }
        }
        
        self.restaurentFoodPicksVCVM?.reloadRecipieCollectionView = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.restFoodPick.reloadData()
            }
        }
        
    }
    
    func distanceBetweenKms(){
        let restLat = UserDefaults.standard.string(forKey: "lat")
        let resLong = UserDefaults.standard.string(forKey: "long")
        let lat = Double(restLat!)
        let long = Double(resLong!)
        let sourceLocation = CLLocation(latitude: lat!, longitude: long!)
        print(sourceLocation)
        let restaruantLat = self.restaurentFoodPicksVCVM?.getCartModel?[0].restauranLatitude
        let restaurantLong = self.restaurentFoodPicksVCVM?.getCartModel?[0].restauranLongitude
        let destinLat = Double(restaruantLat!)
        let destinLong = Double(restaurantLong!)
        let destinationLocation = CLLocation(latitude: destinLat!, longitude: destinLong!)
        print(destinationLocation)
        distance = Int(sourceLocation.distance(from: destinationLocation) / 1000)
        print(distance)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        couponcodeValue = ""
        removeCoupon = 1
        DiscountAmount = 0
        print(removeCoupon)
        self.totalSavingsAmountLabel.text = "QR 0.0"
        
    }
    
    func setupNavigationBar() {
        self.locationName.setTitle(UserDefaults.standard.string(forKey: "City_Name"), for: .normal)
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.userName.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.userName.isHidden = false
            self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
    
    func setupValues() {
        self.restaurentName.text = self.restaurentFoodPicksVCVM?.getCartModel?[0].restauranName
        self.restaurentImage.loadImageUsingURL(self.restaurentFoodPicksVCVM?.getCartModel?[0].restauranApplogo)
        self.savingsOverView.layer.borderWidth = 2
        self.savingsOverView.layer.borderColor = UIColor(red: 239/255, green: 250/255, blue: 255/255, alpha: 1).cgColor
        // self.totalSavingsAmountLabel.text = "QR \(Double(self.restaurentFoodPicksVCVM?.totalSaving() ?? 0))"
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNoteVC") as! AddNoteVC
        // vc.modalTransitionStyle  = .crossDissolve
        vc.addNotesVM = self.restaurentFoodPicksVCVM?.getAddNoteVCVM() ?? AddNoteVCVM()
        vc.notes = {  (notes, recording) in
            DispatchQueue.main.async {
                self.restaurentFoodPicksVCVM?.notes = notes
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.changedValues?(self.restaurentFoodPicksVCVM?.itemId ?? [Int](), self.restaurentFoodPicksVCVM?.itemCount ?? [Int]())
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc func actionAddMore() {
        self.changedValues?(self.restaurentFoodPicksVCVM?.itemId ?? [Int](), self.restaurentFoodPicksVCVM?.itemCount ?? [Int]())
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc func actionTakeAway() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            vc.navigationClosure =  { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                    vc.modalTransitionStyle  = .crossDissolve
                    vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "take_away")
                    //vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
            vc.modalTransitionStyle  = .crossDissolve
            vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "take_away")
            //vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func RemoveCouponslist(){
        self.finalDiscountAppledAmount = 0
        print(finalDiscountAppledAmount!)
        self.restFoodPick.reloadData()
        self.totalSavingsAmountLabel.text = "QR 0.0"
    }
    
    
    
    
    @objc func couponCodelist(){
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            vc.navigationClosure =  { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                    vc.modalTransitionStyle  = .crossDissolve
                    vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "take_away")
                    self.present(vc, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        } else{
            if removeCoupon == 0{
                NotificationCenter.default.addObserver(self, selector: #selector(RemoveCouponsGrandTotal), name: Notification.Name("RemoveCouponName"), object: nil)
                self.restFoodPick.reloadData()
            }else{
                if isResHomeId == "resID"{
                    resID =  Int((UserDefaults.standard.string(forKey: "ResHomeID") ?? "") as String)
                }else{
                    resID =  Int((UserDefaults.standard.string(forKey: "RestaurentId") ?? "") as String)
                }
                let token = UserDefaults.standard.string(forKey: "AuthToken")
                let headers : HTTPHeaders = [
                    "Authorization": " \(token!)",
                    "zoneId":"\(UserDefaults.standard.string(forKey: "zoneID")!)"
                ]
                print(headers)
                AF.request("\(Constants.Common.finalURL)/coupon/apply?code=\(couponcodeValue!)&restaurant_id=\(resID!)", method: .get, encoding: JSONEncoding.default,headers: headers)
                    .responseJSON { [self] response in
                        switch response.result {
                        case .success(let json):
                            print(json)
                            print("\(Constants.Common.finalURL)/coupon/apply?code=\(couponcodeValue!)&restaurant_id=\(resID!)")
                            let response = json as? NSDictionary
                            self.discount_type = response!["discount_type"] as?  String
                            if self.discount_type == "percent"{
                                removeCoupon = 0
                                NotificationCenter.default.post(name: Notification.Name("disableKeyboard"), object: nil)
                                print(removeCoupon)
                                self.discount = response!["discount"] as? Double
                                print(discount)
                                UserDefaults.standard.set(self.discount, forKey: "Discount")
                                self.myTotalAmount = self.restaurentFoodPicksVCVM?.grandTotalAmount()
                                print(self.myTotalAmount!)
                                self.coupon_type = response!["coupon_type"] as! String
                                self.DiscountAmount = (Double((self.myTotalAmount*self.discount)/100))
                                print(self.DiscountAmount)
                                self.finalAmount = (self.myTotalAmount!) - (self.DiscountAmount!)
                                print(self.finalAmount)
                                self.finalDiscountAppledAmount = Int(self.finalAmount)
                                print(self.finalDiscountAppledAmount)
                                UserDefaults.standard.set(self.finalDiscountAppledAmount, forKey: "finalDiscount")
                                self.tprice = (self.restaurentFoodPicksVCVM?.priceCalculation())
                                print(self.tprice)
                                self.restFoodPick.reloadData()
                                self.totalSavingsAmountLabel.text = "QR \(self.DiscountAmount!)"
                                print(self.totalSavingsAmountLabel.text!)
                                couponcodeValue == ""
                                self.restaurentFoodPicksVCVM?.coupontype = self.coupon_type!
                                self.restaurentFoodPicksVCVM?.distance = distance!
                                restaurentFoodPicksVCVM?.getCartCall()
                                let overLayerView = OverLayerView()
                                overLayerView.QrAmount = "\(self.discount!)%"
                                overLayerView.couponName = "\(self.coupon_type!)"
                                overLayerView.appear(sender: self)
                                DispatchQueue.main.async {
                                    self.restFoodPick.reloadData()
                                }
                            }else{
                                self.discount = response!["discount"] as? Double
                                UserDefaults.standard.set(self.discount, forKey: "Discount")
                                self.myTotalAmount = self.restaurentFoodPicksVCVM?.grandTotalAmount()
                                print(self.myTotalAmount!)
                                if self.discount == nil{
                                    let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Coupon Not Found", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }else{
                                    self.DiscountAmount = (Double((self.myTotalAmount - self.discount)))
                                    print(self.DiscountAmount)
                                    self.finalAmount = (self.myTotalAmount!) - (self.discount!)
                                    print(self.finalAmount)
                                    self.finalDiscountAppledAmount = Int(self.finalAmount)
                                    print(self.finalDiscountAppledAmount)
                                    self.restFoodPick.reloadData()
                                }
                                
                            }
                            
                            guard let errors = response!["errors"] as? Array<Any> else{
                                return
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Code Not Found.", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            for mydic in errors{
                                let dic = mydic as! NSDictionary
                                let code = dic["code"] as! String
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Coupon Not Found", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        case .failure(let error):
                            print(error)
                            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Coupon not Found", comment: ""), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                
            }
            
            
        }
        
    }
    
    @objc func actionOrderNow() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            vc.navigationClosure =  { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                    vc.modalTransitionStyle  = .crossDissolve
                    vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                    if self.finalDiscountAppledAmount == nil{
                        vc.discountAppliedNameLbl = 0
                    }else{
                        vc.discountAppliedNameLbl = self.finalDiscountAppledAmount!
                    }
                    //vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        } else {
            print(loginBool)
            if loginBool == true{
                loginBool == false
                isFormPlaces = "isFormPlaces"
                let storyboard = UIStoryboard.init(name: "MyPlacesStoryboard", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "MyplacesFormDetailsViewController") as! MyplacesFormDetailsViewController
                vc.addressText = UserDefaults.standard.string(forKey: "Location_Info")
                if finalDiscountAppledAmount == nil{
                    vc.finalDiscountAppledAmount = 0
                }else{
                    vc.finalDiscountAppledAmount = self.finalDiscountAppledAmount!
                }
                vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                vc.locatonClosure = {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                    vc.modalTransitionStyle  = .crossDissolve
                    vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                    self.present(vc, animated: true, completion: nil)
                }
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                vc.modalTransitionStyle  = .crossDissolve
                if finalDiscountAppledAmount == nil{
                    vc.discountAppliedNameLbl = 0
                }else{
                    vc.discountAppliedNameLbl = self.finalDiscountAppledAmount!
                }
                
                vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension RestaurentFoodPicksVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurentFoodPicksVCVM?.getCartModel?.count == 0 ? 1: self.restaurentFoodPicksVCVM?.getCartModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.restaurentFoodPicksVCVM?.getCartModel?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddMoreItemCell", for: indexPath) as! AddMoreItemCell
            RepeatView.isHidden = true
            //self.totalSavingsAmountLabel.text = "0.0"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestFoodPickTableViewCell
            cell.RestFoodPickTableViewCellVM = self.restaurentFoodPicksVCVM?.getRestFoodPickTableViewCellVM(index: indexPath.row)
            /*let button : UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
            button.frame = CGRect(x: 115, y: 90, width: 100, height: 24)
            // button.setTitle("customize", for: .normal)
            button.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Customize", comment: ""), for: .normal)
            button.backgroundColor = UIColor.red
            button.layer.cornerRadius = 5
            button.tag = indexPath.row
            button.addTarget(self, action: #selector(CustomizeAddons), for: .touchUpInside)
            cell.contentView.addSubview(button)*/
            cell.buttonAdd.tag = indexPath.row
            cell.itemAdded  = { (itemCount, index, isAdded) in
                if isAdded {
                    //  self.restaurentFoodPicksVCVM?.updateCartCall(itemCount: itemCount, index: index, isIncrementFlow: isAdded)
                //    self.restaurentFoodPicksVCVM?.decideFlow(itemCount: itemCount, index: indexPath.row, isIncrementFlow: isAdded)
                    if self.restaurentFoodPicksVCVM?.getCartModel?[indexPath.row].addon?.count == 0{
                        self.restaurentFoodPicksVCVM?.decideFlow(itemCount: itemCount, index: indexPath.row, isIncrementFlow: isAdded)
                    } else {
                        self.itemCout = itemCount
                        self.index = index
                        self.isIncrementFlow = isAdded
                        let selectedItem = self.restaurentFoodPicksVCVM?.getCartModel?[index]
                        self.itemName.text = selectedItem?.name
                        let itemPrice = selectedItem?.tprice ?? 0 - (Int(selectedItem?.discount ?? "") ?? 0)
                        self.itemPrice.text = selectedItem?.price
                        self.RepeatView.isHidden = false
                        
                    //    self.navigateToAdOnView(itemCount: itemCount, index: index, isIncrementFlow: isAdded)
                    }
                } else {
                    self.restaurentFoodPicksVCVM?.decideFlow(itemCount: itemCount, index: indexPath.row, isIncrementFlow: isAdded)
                }
                
                //                    if self.restaurentFoodPicksVCVM?.getCartModel?[indexPath.row].addon?.count == 0{
                //                        self.restaurentFoodPicksVCVM?.updateCartCall(itemCount: itemCount, index: index, isIncrementFlow: isAdded)
                //                    }else{
                //
                //                        } else {
                //                            self.restaurentFoodPicksVCVM?.decideFlow(itemCount: itemCount, index: indexPath.row, isIncrementFlow: isAdded)
                //                        }
                //                    }
                
                cell.customizeBtn.tag = indexPath.row
                cell.customizeBtn.addTarget(self, action: #selector(self.CustomizeAddons(_sender:)), for: .touchUpInside)
            }
            
            if self.restaurentFoodPicksVCVM?.getCartModel?[indexPath.row].addon?.count == 0{
                cell.customizeBtn.isHidden = true
            }else{
                cell.customizeBtn.isHidden = false
            }
            //cell.buttonAdd.addTarget(self, action: #selector(repeatViews), for: .touchUpInside)
            return cell
        }
    }
    
    func navigateToAdOnView(itemCount: Int, index: Int, addon: [AddOns]? = nil, isIncrementFlow: Bool) {
        
        let foodItem = self.restaurentFoodPicksVCVM?.shopDetailsModel?.products?[index]
        print(foodItem?.addOns! as Any)
        if foodItem?.addOns != nil && foodItem?.addOns?.count ?? 0 >= 0 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
            vc.addOnViewControllerVM = self.restaurentFoodPicksVCVM?.getAddOnViewControllerVM(index: index)
            vc.addOns  = { (addOns) in
                DispatchQueue.main.async {
                    self.restaurentFoodPicksVCVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
                }
            }
            vc.makeCartCall = {
                self.restaurentFoodPicksVCVM?.decideFlow(itemCount: itemCount, index: index, isIncrementFlow: isIncrementFlow)
            }
            
            vc.modalTransitionStyle  = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func repeatViews(){
        self.RepeatView.isHidden = false
        NotificationCenter.default.post(name: Notification.Name("AddRepeatingItems"), object: nil)
    }
    
    @objc func CustomizeAddons(_sender: UIButton){
        let foodItem = self.restaurentFoodPicksVCVM?.shopDetailsModel?.products?[_sender.tag]
        print(foodItem?.addOns! as Any)
        if foodItem?.addOns != nil && foodItem?.addOns?.count ?? 0 >= 0 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
            vc.addOnViewControllerVM = self.restaurentFoodPicksVCVM?.getAddOnViewControllerVM(index: _sender.tag)
            vc.addOns  = { (addOns) in
                DispatchQueue.main.async {
                    self.restaurentFoodPicksVCVM?.decideFlow(itemCount: 1, index: _sender.tag, addOns: addOns, isIncrementFlow: true)
                }
            }
            vc.makeCartCall = {
                self.restaurentFoodPicksVCVM?.decideFlow(itemCount: 1, index: _sender.tag, isIncrementFlow: true)
            }
            vc.modalTransitionStyle  = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        } else {
            self.restaurentFoodPicksVCVM?.decideFlow(itemCount: 1, index: _sender.tag, isIncrementFlow: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (self.restaurentFoodPicksVCVM?.getCartModel?.count ?? 0) > 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BasketFooterViewCell") as! BasketFooterViewCell
            headerView.couponCodeTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ApplyCouponCode", comment: "")
            headerView.takeAway.layer.cornerRadius = 10
            headerView.orderNow.layer.cornerRadius = 10
            headerView.takeAway.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Schedule Order", comment: ""), for:.normal)
            headerView.orderNow.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ordernow", comment: ""), for: .normal)
            //headerView.takeAway.addTarget(self, action:#selector(self.actionTakeAway), for: .touchUpInside)
            headerView.orderNow.addTarget(self, action:#selector(self.actionOrderNow), for: .touchUpInside)
            headerView.addMoreItem.addTarget(self, action:#selector(self.actionAddMore), for: .touchUpInside)
            headerView.itemTotalValue.text = "QR \(self.restaurentFoodPicksVCVM?.priceCalculation() ?? 0)"
            headerView.taxValue.text = "QR \(self.restaurentFoodPicksVCVM?.taxCalculation() ?? 0)"
            headerView.takeAway.addTarget(self, action: #selector(Schedule), for: .touchUpInside)
            if self.finalDiscountAppledAmount == nil{
                headerView.grandTotalValue.text = "QR \((self.restaurentFoodPicksVCVM?.grandTotal())!)"
            }else if self.finalDiscountAppledAmount == 0{
                if removeCoupon == 0{
                    print(removeCoupon)
                    headerView.grandTotalValue.text = "QR \((self.restaurentFoodPicksVCVM?.grandTotal())!)"
                }else{
                    print(removeCoupon)
                    headerView.grandTotalValue.text = "QR \((self.restaurentFoodPicksVCVM?.grandTotal())!)"
                }
                
            }else{
                headerView.grandTotalValue.text = "QR \((self.finalDiscountAppledAmount)! + distance)"
            }
            headerView.addMoreItem.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add More Item", comment: ""), for: .normal)
            headerView.itemTotalLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "item Total", comment: "")
            headerView.taxandChargesL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Tax & Charges", comment: "")
            headerView.grandL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Grand Total", comment: "")
            
            couponcodeValue = headerView.couponCodeTF.text!
            if removeCoupon == nil{
                //headerView.applyCouponCodeBtn.setTitle("Apply", for: .normal)
                headerView.applyCouponCodeBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Apply", comment: ""), for: .normal)
                headerView.applyCouponCodeBtn.addTarget(self, action: #selector(couponCodelist), for: .touchUpInside)
            }else{
                if removeCoupon == 0{
                    headerView.couponCodeTF.isUserInteractionEnabled = false
                    // headerView.applyCouponCodeBtn.setTitle("Remove", for: .normal)
                    headerView.applyCouponCodeBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Remove", comment: ""), for: .normal)
                    headerView.applyCouponCodeBtn.addTarget(self, action: #selector(RemoveCouponslist), for: .touchUpInside)
                    print(self.finalDiscountAppledAmount)
                    if finalDiscountAppledAmount == 0{
                        print("apply")
                        removeCoupon = 1
                        headerView.couponCodeTF.isUserInteractionEnabled = true
                        headerView.applyCouponCodeBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Apply", comment: ""), for: .normal)
                        //headerView.applyCouponCodeBtn.setTitle("Apply", for: .normal)
                        headerView.applyCouponCodeBtn.addTarget(self, action: #selector(couponCodelist), for: .touchUpInside)
                        
                    }else{
                        print("remove")
                        headerView.applyCouponCodeBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Remove", comment: ""), for: .normal)
                        headerView.couponCodeTF.isUserInteractionEnabled = false
                        //headerView.applyCouponCodeBtn.setTitle("Remove", for: .normal)
                        headerView.applyCouponCodeBtn.addTarget(self, action: #selector(RemoveCouponslist), for: .touchUpInside)
                    }
                }else{
                    headerView.applyCouponCodeBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Apply", comment: ""), for: .normal)
                    //headerView.applyCouponCodeBtn.setTitle("Apply", for: .normal)
                    headerView.applyCouponCodeBtn.addTarget(self, action: #selector(couponCodelist), for: .touchUpInside)
                }
                
            }
            
            if DiscountAmount == nil{
                headerView.discountAmountAppledLbl.text = "QR 0"
            }else{
                if self.finalDiscountAppledAmount == 0{
                    headerView.discountAmountAppledLbl.text = "QR 0"
                }else{
                    headerView.discountAmountAppledLbl.text = "QR \(Int(self.DiscountAmount!))"
                    print(self.DiscountAmount!)
                }
                
            }
            let delivery = restaurentFoodPicksVCVM?.deliveryCharge()
            deliveryCharge = UserDefaults.standard.string(forKey: "deliveryCharge")
            headerView.deliveryChargeLbl.text = "QR \(deliveryCharge!)"
            
            if LocalizationSystem.sharedInstance.getLanguage() == "en"{
                
                headerView.discountAmountLbl.textAlignment = .left
                headerView.deliveryChargeHeadingLbl.textAlignment = .left
                headerView.deliveryChargeLbl.textAlignment = .left
                headerView.deliveryChargeHeadingLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivery Charge", comment: "")
                headerView.discountAmountLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Discount Amount", comment: "")
            }else{
                headerView.discountAmountLbl.textAlignment = .right
                headerView.deliveryChargeHeadingLbl.textAlignment = .right
                headerView.deliveryChargeLbl.textAlignment = .right
                headerView.deliveryChargeHeadingLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivery Charge", comment: "")
                headerView.discountAmountLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Discount Amount", comment: "")
                
            }
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 383
    }
    
    @objc func Schedule(){
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            vc.navigationClosure =  { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                    vc.modalTransitionStyle  = .crossDissolve
                    vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                    if self.finalDiscountAppledAmount == nil{
                        vc.discountAppliedNameLbl = 0
                    }else{
                        vc.discountAppliedNameLbl = self.finalDiscountAppledAmount!
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        } else {
            if loginBool == true{
                loginBool == false
                isFormPlaces = "isFormPlaces"
                let storyboard = UIStoryboard.init(name: "MyPlacesStoryboard", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "MyplacesFormDetailsViewController") as! MyplacesFormDetailsViewController
                vc.addressText = UserDefaults.standard.string(forKey: "Location_Info")
                if finalDiscountAppledAmount == nil{
                    vc.finalDiscountAppledAmount = 0
                }else{
                    vc.finalDiscountAppledAmount = self.finalDiscountAppledAmount!
                }
                vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                vc.locatonClosure = {
                    let storyboard = UIStoryboard.init(name: "MyPlacesStoryboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "ScheduleTimeViewController") as! ScheduleTimeViewController
                    vc.restauraneName = self.restaurentFoodPicksVCVM?.getCartModel?[0].restauranName
                    vc.imageName = self.restaurentFoodPicksVCVM?.getCartModel?[0].restauranApplogo
                    vc.restauraentID = self.restaurentFoodPicksVCVM?.getCartModel?[0].restaurantId
                    print(Int((UserDefaults.standard.string(forKey: "RestaurentId") ?? "") as String))
                    vc.scheduleClosure = {
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                        vc.modalTransitionStyle  = .crossDissolve
                        if self.finalDiscountAppledAmount == nil{
                            vc.discountAppliedNameLbl = 0
                        }else{
                            vc.discountAppliedNameLbl = self.finalDiscountAppledAmount!
                        }
                        vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                        self.present(vc, animated: true, completion: nil)
                    }
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                }
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard.init(name: "MyPlacesStoryboard", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "ScheduleTimeViewController") as! ScheduleTimeViewController
                vc.restauraneName = self.restaurentFoodPicksVCVM?.getCartModel?[0].restauranName
                vc.imageName = self.restaurentFoodPicksVCVM?.getCartModel?[0].restauranApplogo
                vc.restauraentID = self.restaurentFoodPicksVCVM?.getCartModel?[0].restaurantId
                vc.scheduleClosure = {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                    vc.modalTransitionStyle  = .crossDissolve
                    if self.finalDiscountAppledAmount == nil{
                        vc.discountAppliedNameLbl = 0
                    }else{
                        vc.discountAppliedNameLbl = self.finalDiscountAppledAmount!
                    }
                    vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                    self.present(vc, animated: true, completion: nil)
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }
            
            
        }
        
    }
}
