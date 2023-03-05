//
//  HomeViewController.swift
//  SideMenu-IOS-Swift
//
//  Created by apple on 12/01/22.
//

import UIKit
import CoreLocation
import Alamofire
import SDWebImage
import Auk
import moa
import SearchTextField
var restaruantItems:String!
var productItems:String!
var isfromprofile:String!
var isfromcart:String!
var isfromoffers:String!
var isResHomeId:String!
var categoryIDHome:Int!

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collViewwsliderConst: NSLayoutConstraint!
    @IBOutlet weak var OfferCVConstraints: NSLayoutConstraint!
    var menu_vc: MenuVC!
    @IBOutlet weak var locationimg: UIImageView!
    @IBOutlet weak var viewallLbl: UILabel!
    @IBOutlet weak var snacksLbl: UILabel!
    @IBOutlet weak var nearbyreLbl: UILabel!
    var latitude:String!
    var longtitude:String!
    var address:String!
    @IBOutlet weak var homeSlidercollectionView: UICollectionView!
    @IBOutlet weak var basketBtn: UIButton!
    @IBOutlet weak var scrollVieww: UIScrollView!
    @IBOutlet weak var searchAction: UIButton!
    @IBOutlet weak var locationInfo: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartCount: UIButton!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var searchTF: SearchTextField!
    @IBOutlet weak var collectionViewTop: UICollectionView!
    @IBOutlet weak var collectionviewSec: UICollectionView!
    @IBOutlet weak var langButton: UIButton!
    @IBOutlet weak var collectionviewThird: UICollectionView!
    @IBOutlet weak var collectionviewDown: UICollectionView!
    var locationManager: CLLocationManager?
    var sliderImagesArray = [String]()
    var slidernamesArray = [String]()
    var sliderDescriptionArray = [String]()
    var BannerImagesArray = [String]()
    var filterOrdersArray = [String]()
    var restaurantsArray = [String]()
    var productsArray = [String]()
    var timer:Timer?
    var currentCellIndex = 0
    var sliderPriceArray = [String]()
    var catgoryIDArray = [Int]()

    @IBOutlet weak var menuBtn: UIButton!
    var homeViewControllerVM = HomeViewControllerVM()
    
    @IBOutlet weak var enView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        OfferCVConstraints.constant = 0
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.NextSlide), userInfo: nil, repeats: true)
        pageControl.numberOfPages = self.homeViewControllerVM.restaurantNameArray.count
        searchTF.delegate = self
        homeSlidercollectionView.delegate = self
        homeSlidercollectionView.dataSource = self
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            let ar = UIImage(named: "arabic")
            langButton.setImage(ar, for: .normal)
           
            let en = UIImage(named: "en")
            langButton.setImage(en, for: .normal)
         
           
        }
        
        self.homeViewControllerVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.homeViewControllerVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        filterOrdersArray = ["Fast Delivery","Rating 4.0*","Relevance"]
        //basketBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "basket", comment: ""), for: .normal)
        searchTF.placeholder   =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "searchText", comment: "")
        snacksLbl.text  =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "Snacks", comment: "")
        viewallLbl.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "", comment: "")
        nearbyreLbl.text =
            LocalizationSystem.sharedInstance.localizedStringForKey(key: "Near By Restaurant", comment: "")
        basketBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: " Basket", comment: ""), for: .normal)

        homeViewControllerVM.makeCategoryListCall()
        homeViewControllerVM.makeShopNearyByCall()
        homeViewControllerVM.makeBannerCall()
        locationPermissions()
        
        self.cartView.isHidden = true
        
        //        searchTF.addTarget(self, action: #selector(HomeViewController.textViewShouldBeginEditing(_:)), for: .editingChanged)
        
        //        searchTF.addTarget(self, action: #selector(HomeViewController.textFieldDidBeginEditing), for: UIControl.Event.touchDown)
        
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
        
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
        
        cartView.layer.cornerRadius = 30
        cartButton.layer.cornerRadius = 30
        cartCount.layer.cornerRadius = cartCount.frame.height/2
        self.cartCount.clipsToBounds = true
        
        cartView.layer.borderWidth = 2
        cartView.layer.borderColor = UIColor.systemGray6.cgColor
        
        
        if MyPlacesZoneId == "1"{
            address = UserDefaults.standard.string(forKey: "myPlaces")
            latitude = UserDefaults.standard.string(forKey: "lat")
            longtitude = UserDefaults.standard.string(forKey: "long")
            changeZoneId()
            self.locationInfo.text = "\(address!)"
        }else{
            self.locationInfo.text = UserDefaults.standard.string(forKey: "Location_Info")
        }
        
       
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.homeViewControllerVM.getCartCall()
        self.sliderApi()
     //   self.CategoryListCallApi()
    }
    
    
    func searchNames(){
        let token = UserDefaults.standard.string(forKey: "zoneID")
        let headers : HTTPHeaders = [
            "zoneId": "\(token!)"
        ]
        print(headers)
        AF.request("\(Constants.Common.finalURL)/restaurants/search?name=\(searchTF.text!)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
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
                            if restaurants?.count == 0{
                                print("restaurants Empty")
                                restaruantItems = "EmptyRestaurants"
                            }else{
                                for i in 0 ..< (restaurants?.count ?? 0){
                                    let x = restaurants![i] as! [String:AnyObject]
                                    let name = x["name"] as? String ?? ""
                                    self.restaurantsArray.append(name)
                                }
                            }
                            
                            let products = response["products"] as? Array<Any>
                            if products?.count == 0{
                                print("Products Empty")
                                productItems = "EmptyProducts"
                            }else{
                                for i in 0 ..< (products?.count ?? 0){
                                    let x = products![i] as! [String:AnyObject]
                                    let name = x["name"] as? String ?? ""
                                    self.productsArray.append(name)
                                }
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
    
    func CategoryListCallApi(){
        print("\(Constants.Common.finalURL)/categories")
         AF.request("\(Constants.Common.finalURL)/categories", method: .get, encoding: JSONEncoding.default)
                 .responseJSON { response in
                     switch response.result {
                     case .success(let json):
                         print(json)
                         self.catgoryIDArray.removeAll()
                         let response = json as! Array<Any>
                         
                         if response.isEmpty{
                             
                         }else{
                             for element in response {
                             let dic = element as! NSDictionary
                                 let category = dic["id"] as? Int ?? 0
                                 self.catgoryIDArray.append(category)
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
     }
        
    func sliderApi(){
       print("\(Constants.Common.finalURL)/products/get_slider")
        AF.request("\(Constants.Common.finalURL)/products/get_slider", method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        print(json)
                        let response = json as! Array<Any>
                        if response.isEmpty{
                            self.collViewwsliderConst.constant = 0
                            self.snacksLbl.isHidden = true
                        }else{
                            print(response)
                            self.snacksLbl.isHidden = false
                            self.collViewwsliderConst.constant = 205
                            self.slidernamesArray.removeAll()
                            self.sliderImagesArray.removeAll()
                            self.sliderPriceArray.removeAll()
                            self.sliderDescriptionArray.removeAll()
                            for element in response {
                            let dic = element as! NSDictionary
                                let category = dic["category"] as! String
                                self.snacksLbl.text = category
                                let data = dic["food"] as! Array<Any>
                                print(data)
                                if data.isEmpty{
                                   
                                }else{
                                    for dictionary in data{
                                        let dictinaryValues = dictionary as! NSDictionary
                                        let name = dictinaryValues["name"] as? String ?? ""
                                        print(name)
                                        self.slidernamesArray.append(name)
                                        let appimage = dictinaryValues["appimage"] as? String ?? ""
                                        self.sliderImagesArray.append(appimage)
                                        print(self.slidernamesArray)
                                        let price = dictinaryValues["price"] as? String ?? ""
                                        self.sliderPriceArray.append(price)
                                        let desc = dictinaryValues["description"] as? String ?? ""
                                        self.sliderDescriptionArray.append(desc)
                                    }

                                }
                        }
                            
                            DispatchQueue.main.async{
                               
                                self.collectionviewThird.reloadData()
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
    }
    
    func changeZoneId(){
        let token = UserDefaults.standard.string(forKey: "AuthToken")
        let headers : HTTPHeaders = [
            "Authorization": " \(token!)",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        print(headers)
        AF.request("\(Constants.Common.finalURL)/config/get-zone-id?lat=\(self.latitude!)&lng=\(self.longtitude!)", method: .get, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        print(json)
                        guard let response = json as? NSDictionary else{
                            return
                        }
                        let zone_id = response["zone_id"] as? Int ?? 0
                        print(zone_id)
                        UserDefaults.standard.set(zone_id, forKey: "zoneID")
                    case .failure(let error):
                        print(error)
                        let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
            }
    }
    
    
    @IBAction func LangAction(_ sender: Any) {
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            
          
           UIView.appearance().semanticContentAttribute = .forceLeftToRight
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
               let vc = storyboard.instantiateViewController(identifier: "tabVC")
               vc.modalPresentationStyle = .fullScreen
            
           
    
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            locationimg.isHidden = true
           
            
        } else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
             let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "tabVC")
                vc.modalPresentationStyle = .fullScreen

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        }
    }
    
    
    //setup location properties
    func locationPermissions() {
        //Get Location Permission
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingHeading()
        
        if CLLocationManager.locationServicesEnabled()  {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingHeading()
        }
    }
    
    func setupLabelTap() {
            
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.locationInfo.isUserInteractionEnabled = true
        self.locationInfo.addGestureRecognizer(labelTap)
            
        }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPlacesViewController") as! MyPlacesViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        isfromprofile = ""
        isfromcart = ""
        isfromoffers = ""
    }
    
    @objc func NextSlide(){
        if currentCellIndex < self.homeViewControllerVM.restaurantNameArray.count - 1{
            currentCellIndex = currentCellIndex + 1
        }else{
            currentCellIndex = 0
        }
        pageControl.currentPage = currentCellIndex
        homeSlidercollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .right, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.NextSlide), userInfo: nil, repeats: true)
        pageControl.numberOfPages = self.homeViewControllerVM.restaurantNameArray.count*/
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
        
        self.homeViewControllerVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
            self?.setupLabelTap()
        }
        
        self.homeViewControllerVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.homeViewControllerVM.reloadCollectionViewDown = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.collectionviewDown.reloadData()
            }
        }
        
        self.homeViewControllerVM.reloadCollectionViewTop = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.collectionViewTop.reloadData()
            }
        }
        
        self.homeViewControllerVM.reloadCollectionViewHomeSlider = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.homeSlidercollectionView.reloadData()
            }
        }
        
        self.homeViewControllerVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestarentDishViewController") as! RestarentDishViewController
                // vc.modalTransitionStyle = .coverVertical
                vc.restarentDishViewControllerVM = self.homeViewControllerVM.getRestarentDishViewControllerVM()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.homeViewControllerVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.homeViewControllerVM.getCartCountClosure = { [weak self]  in
            DispatchQueue.main.async {
                guard let self = self else {return}
                if let cartCountValue = self.homeViewControllerVM.getCartModel?.data?.count, cartCountValue > 0 {
                    self.cartView.isHidden = false
                self.cartCount.setTitle("\(cartCountValue)", for: .normal)
                } else {
                    self.cartView.isHidden = true
                }
            }
        }
        
        self.homeViewControllerVM.navigateToCartClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
                vc.restaurentFoodPicksVCVM = self.homeViewControllerVM.getRestaurentFoodPicksVCVM()
                vc.changedValues  = { (itemCount, index) in
                    DispatchQueue.main.async {
                        //   self.restarentDishViewControllerVM?.getCartCall(isFromCartScreen: true)
                        //  self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
                    }
                }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        searchTF.text = ""
        self.restaurantsArray.removeAll()
        self.productsArray.removeAll()
        homeViewControllerVM.changeZoneId()
        
        if isfromprofile == "fromProfileLogin"{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please Login", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
               /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)*/
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if isfromcart == "isfromCartLogin"{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please Login", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
              /*  let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)*/
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if isfromoffers == "isfromOffersList"{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please Login", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
               /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)*/
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer)
    {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            show_menu()
        case UISwipeGestureRecognizer.Direction.left:
            close_menu()
        default:
            break
        }
    }
    
    func show_menu()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MenuVC") as! MenuVC
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func close_menu()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCart(_ sender: Any) {
        let id = Int(self.homeViewControllerVM.getCartModel?.data?[0].restaurantId ?? "") ?? 0
        isResHomeId = "resID"
        UserDefaults.standard.set(Int(self.homeViewControllerVM.getCartModel?.data?[0].restaurantId ?? "") ?? 0, forKey: "ResHomeID")
        self.homeViewControllerVM.makeShopDetailsCall(id: id, isCartClicked: true)
       
    }
    
    @IBAction func menubtnAct(_ sender: Any)
    {
        self.show_menu()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            guard let locValue:CLLocation = manager.location else {return}
            
            let lat = locValue.coordinate.latitude
            let long = locValue.coordinate.longitude
            UserDefaults.standard.set(lat, forKey: "lat")
            UserDefaults.standard.set(long, forKey: "long")
            self.homeViewControllerVM.changeZoneId()
            
            CLGeocoder().reverseGeocodeLocation(locValue, completionHandler: {(placemarks, error) -> Void in
                    print(locValue)
                    guard error == nil else {
                        print("Reverse geocoder failed with error")
                        return
                    }
                guard placemarks!.count > 0 else {
                        print("Problem with the data received from geocoder")
                        return
                    }
                let pm = placemarks?[0]
                let locationDashBord = "\(pm!.locality ?? ""), \(pm!.subLocality ?? ""),\(pm!.administrativeArea ?? "") \(pm!.country ?? ""),\(pm!.postalCode ?? "")"
               print(locationDashBord)
                UserDefaults.standard.set(locationDashBord, forKey: "Location_Info")
                UserDefaults.standard.set((pm!.locality!), forKey: "City_Name")
            })
            //self.locationInfo.text = UserDefaults.standard.string(forKey: "Location_Info")
        } else if status == .denied {
            //Show Error Screen
        }
    }
    
    
    @IBAction func actionSearch(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SearchRestaurentVC") as! SearchRestaurentVC
        // vc.modalTransitionStyle = .coverVertical
      //  vc.restarentDishViewControllerVM = self.homeViewControllerVM.getRestarentDishViewControllerVM()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewTop
        {
            return self.homeViewControllerVM.categoryList?.count ?? 0
        }
        if collectionView == self.collectionviewSec
        {
            return filterOrdersArray.count
        }
        if collectionView == self.collectionviewThird
        {
            return sliderImagesArray.count
        }
        if collectionView == self.collectionviewDown
        {
            return self.homeViewControllerVM.shopListModel?.restaurants?.count ?? 0
        }
        
        if collectionView == self.homeSlidercollectionView{
            return self.homeViewControllerVM.restaurantNameArray.count
        }
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewTop {
            let cellA = collectionViewTop.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
            cellA.homeCollectionViewCellVM = self.homeViewControllerVM.getHomeCollectionViewCellVM(index: indexPath.row)
            return cellA
        }
        
        
        else if collectionView == self.collectionviewThird{
            let cellC = collectionviewThird.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewThirdCell
            if slidernamesArray.count > 0 && indexPath.row < slidernamesArray.count {
                cellC.sliderNameLbl.text = slidernamesArray[indexPath.item]
            }
            if slidernamesArray.count > 0 && indexPath.row < slidernamesArray.count {
                cellC.sliderImage.downloaded(from: sliderImagesArray[indexPath.row],contentMode: .scaleAspectFill)
            }
            return cellC
        }
        
        else if collectionView == self.collectionviewSec{
            let cellB = collectionviewSec.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewSecCell
            cellB.lblview.layer.borderColor = UIColor.red.cgColor
            cellB.lblview.layer.cornerRadius = 10
            cellB.lbl.text = filterOrdersArray[indexPath.row]
            
            // ...Set up cell
            
            return cellB
        }
        
        else if collectionView == self.homeSlidercollectionView{
            let cell = homeSlidercollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeSliderCollectionViewCell
            cell.SliderImg.downloaded(from: homeViewControllerVM.restaurantNameArray[indexPath.row],contentMode: .scaleAspectFill)
            print(homeViewControllerVM.restaurantNameArray[indexPath.row])
            return cell
        }
        
        else
        {
            let celldown = collectionviewDown.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewDownCell
            celldown.homeCollectionViewDownCellVM = self.homeViewControllerVM.getHomeCollectionViewDownCellVM(index: indexPath.row)
            return celldown
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionviewDown {
            self.homeViewControllerVM.makeShopDetailsCall(id: self.homeViewControllerVM.shopListModel?.restaurants?[indexPath.row].id ?? 0)
        }
        
        if collectionView == self.collectionviewSec{
            if indexPath.row == 0{
                self.homeViewControllerVM.makeShopNearyByCall()
            }
            if indexPath.row == 1{
               self.homeViewControllerVM.makePopularCall()
            }
            if indexPath.row == 2{
                self.homeViewControllerVM.makeShopNearyByCall()
            }

        }
        
        if collectionView == self.homeSlidercollectionView{
            if self.homeViewControllerVM.restaurantTypeArray[indexPath.item] == "restaurant_wise"{
                self.homeViewControllerVM.makeShopDetailsCall(id: self.homeViewControllerVM.restaurantIDArray[indexPath.row])
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsVC") as? RecipeDetailsVC
                vc?.modalPresentationStyle = .fullScreen
                vc?.isFromHomeBanners = "ReceipeBanners"
                vc?.priceItem = "\(self.homeViewControllerVM.foodPrice!)"
                vc?.ReceipImg = self.homeViewControllerVM.foodImg
                vc?.itemDescription = self.homeViewControllerVM.foodDescription
                vc?.productNameItem = self.homeViewControllerVM.foodName
                self.present(vc!, animated: true)
            }
        }
        
        if collectionView == self.collectionviewThird{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsVC") as? RecipeDetailsVC
            vc?.modalPresentationStyle = .fullScreen
            vc?.isFromHomeBanners = "ReceipeBanners"
            vc?.priceItem = sliderPriceArray[indexPath.item]
            vc?.ReceipImg = sliderImagesArray[indexPath.row]
            vc?.itemDescription = sliderDescriptionArray[indexPath.row]
            vc?.productNameItem = slidernamesArray[indexPath.row]
            self.present(vc!, animated: true)
        }
        
        if collectionView == self.collectionViewTop{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodCategoryRestaurantViewController") as? FoodCategoryRestaurantViewController
            vc?.modalPresentationStyle = .fullScreen
            vc?.categoryID = catgoryIDArray[indexPath.row]
            self.present(vc!, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionviewDown {
        let yourWidth = collectionView.bounds.width

        return CGSize(width: yourWidth, height: 262)
        }
        return CGSize(width: collectionView.bounds.width, height: 158)
    }
    
    
}


extension HomeViewController:UITextFieldDelegate
{
    fileprivate func configureSimpleSearchTextField() {
        if searchTF.text!.count > 2{
            searchTF.startVisibleWithoutInteraction = true
            searchTF.filterStrings(restaurantsArray)
            print(restaurantsArray)
        }
       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.searchTF{
            searchNames()
            configureSimpleSearchTextField()
        }
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SearchRestaurentVC") as! SearchRestaurentVC
        // vc.modalTransitionStyle = .coverVertical
      //  vc.restarentDishViewControllerVM = self.homeViewControllerVM.getRestarentDishViewControllerVM()
        vc.modalPresentationStyle = .fullScreen
        vc.searchingField = searchTF.text!
        self.present(vc, animated: true, completion: nil)
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
                                
                                
