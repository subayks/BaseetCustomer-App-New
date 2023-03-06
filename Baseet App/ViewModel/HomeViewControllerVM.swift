//
//  HomeViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 01/08/22.
//

import Foundation
import Alamofire

class HomeViewControllerVM {
    var apiServices: HomeApiServicesProtocol?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var shopListModel: ShopListModel?
    var popularListModel: PopularShopListModel?
    var reloadCollectionViewDown:(()->())?
    var categoryList: [CategoryListModel]?
    var reloadCollectionViewTop:(()->())?
    var reloadCollectionViewHomeSlider:(()->())?
    var shopDetailsModel: ShopDetailsModel?
    var navigateToDetailsClosure:(()->())?
    var getCartCountClosure:(()->())?
    var getCartModel: GetCartModel? {
        didSet {
            self.getCartCountClosure?()
        }
    }
    var zoneModel: ZoneModel?
    var navigateToCartClosure:(()->())?
    var restaurantIDArray = [Int]()
    var restaurantNameArray = [String]()
    var foodIdArray = [Int]()
    var FoodNameArray = [String]()
    var restaurantType:String!
    var restaurantTypeArray = [String]()
    var restaurantFoodTypeArray = [String]()
    var foodPrice:Int!
    var foodName:String!
    var foodDescription:String!
    var foodImg:String!

    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func makeShopNearyByCall() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let lat = UserDefaults.standard.string(forKey: "lat")
            let long = UserDefaults.standard.string(forKey: "long")
           let httpHeaders =  [
           "Content-Type": "application/json",
             "latitude": "\(lat ?? "")",
             "longitude": "\(long ?? "")",
             "radius": "50"
           ]
        print(httpHeaders)
            self.apiServices?.getShopNearBy(finalURL: "\(Constants.Common.finalURL)/restaurants/get-nearby", httpHeaders: httpHeaders, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                print(
                    "\(Constants.Common.finalURL)/restaurants/get-nearby")
            DispatchQueue.main.async
            {
                self.hideLoadingIndicatorClosure?()
                if status == true
                {
                    self.shopListModel = result as? ShopListModel
                    DispatchQueue.main.async {
                        self.reloadCollectionViewDown?()
                    }
                   
                }
                else
                {
                    self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        }
        else
        {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func makePopularCall() {
        if Reachability.isConnectedToNetwork() {
           self.showLoadingIndicatorClosure?()
           let httpHeaders =  [
           "Content-Type": "application/json",
           "zoneId": "1"
           ]
        self.apiServices?.getPopular(finalURL:"\(Constants.Common.finalURL)/restaurants/popular", httpHeaders: httpHeaders, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            print("\(Constants.Common.finalURL)/restaurants/popular")
            DispatchQueue.main.async
            {
                self.hideLoadingIndicatorClosure?()
                if status == true
                {
                    self.popularListModel = result as? PopularShopListModel
                    self.reloadCollectionViewDown?()
                }
                else
                {
                    self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        }
        else
        {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func makeCategoryListCall() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getCategoryList(finalURL: "\(Constants.Common.finalURL)/categories",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.categoryList = result as? [CategoryListModel]
                    self.reloadCollectionViewTop?()
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func makeBannerCall(){
        if Reachability.isConnectedToNetwork(){
            self.showLoadingIndicatorClosure?()
                let headers : HTTPHeaders = [
                    "Content-Type" : "application/x-www-form-urlencoded",
                    "zoneId":"1"
                ]
                print(headers)
                AF.request("\(Constants.Common.finalURL)/banners", method: .get, encoding: JSONEncoding.default,headers: headers)
                        .responseJSON { response in
                            switch response.result {
                            case .success(let json):
                                print(json)
                                guard let response = json as? [String:AnyObject] else{
                                    return
                                }
                                self.restaurantIDArray.removeAll()
                                self.restaurantNameArray.removeAll()
                                self.restaurantTypeArray.removeAll()
                                let banners = response["banners"] as? Array<Any>
                                if banners?.count == 0{
                                    
                                }else{
                                    for bannerList in banners!{
                                        let dict = bannerList as! [String:AnyObject]
                                        self.restaurantType = dict["type"] as? String
                                        if self.restaurantType == "restaurant_wise"{
                                            self.restaurantType = "restaurant_wise"
                                            guard let restaurant = dict["restaurant"] as? [String:AnyObject] else{
                                                return
                                            }
                                            let id = restaurant["id"] as? Int ?? 0
                                            let appcoverlogo = restaurant["appcoverlogo"] as? String ?? ""
                                            self.restaurantIDArray.append(id)
                                            self.restaurantNameArray.append(appcoverlogo)
                                            self.restaurantTypeArray.append(self.restaurantType)
                                        }else{
                                            self.restaurantType = "item_wise"
                                            guard let food = dict["food"] as? [String:AnyObject] else{
                                                return
                                            }
                                            let foodID = food["id"] as? Int ?? 0
                                            let foodName = food["appimage"] as? String ?? ""
                                            self.foodImg = food["appimage"] as? String ?? ""
                                            self.foodPrice = food["price"] as? Int ?? 0
                                            self.foodName = food["name"] as? String ?? ""
                                            self.foodDescription = food["description"] as? String ?? ""
                                            self.restaurantIDArray.append(foodID)
                                            self.restaurantNameArray.append(foodName)
                                            self.restaurantTypeArray.append(self.restaurantType)
                                        }
                                        DispatchQueue.main.async {
                                            self.reloadCollectionViewHomeSlider?()
                                        }
                                    }

                                }
                                case .failure(let error):
                                print(error)
                                self.alertClosure?("Unable To Connect Server")
                                
                            }
                    }
            
        }else{
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func makeShopDetailsCall(id: Int, isCartClicked: Bool = false) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            print("\(Constants.Common.finalURL)/products/product_by_restaurant?restaurant_id=\(id)&category_id=0&limit=10&offset=1")
            self.apiServices?.getShopDetails(finalURL: "\(Constants.Common.finalURL)/products/product_by_restaurant?restaurant_id=\(id)&category_id=0&limit=10&offset=1",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.shopDetailsModel = result as? ShopDetailsModel
                    if isCartClicked {
                        self.navigateToCartClosure?()
                    } else {
                        self.navigateToDetailsClosure?()
                    }
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getCartCall() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
          print("\(Constants.Common.finalURL)/products/get_cart?user_id=\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))")
            self.apiServices?.getCartApi(finalURL: "\(Constants.Common.finalURL)/products/get_cart?user_id=\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))", completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.getCartModel = result as? GetCartModel
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func changeZoneId() {
        if Reachability.isConnectedToNetwork() {
          //  self.showLoadingIndicatorClosure?()
            let lat = UserDefaults.standard.string(forKey: "lat")
            let long = UserDefaults.standard.string(forKey: "long")
            print("\(Constants.Common.finalURL)/config/get-zone-id?lat=\(lat ?? "")&lng=\(long ?? "")")
            self.apiServices?.getZoneID(finalURL: "\(Constants.Common.finalURL)/config/get-zone-id?lat=\(lat ?? "")&lng=\(long ?? "")",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
          //      self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.zoneModel = result as? ZoneModel
                    UserDefaults.standard.set(self.zoneModel?.zoneId, forKey: "zoneID")
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getHomeCollectionViewDownCellVM(index: Int) ->HomeCollectionViewDownCellVM {
        if self.shopListModel?.restaurants?.count != nil {
            return HomeCollectionViewDownCellVM(restaurantsModel: (self.shopListModel?.restaurants?[index])!)
            
        }
//        if self.popularListModel?.Popurestaurants?.count != nil {
//            return HomeCollectionViewDownCellVM(popularModel: (self.popularListModel?.Popurestaurants?[index])!)
//
//        }
        return HomeCollectionViewDownCellVM(restaurantsModel: RestaurantsModel())
    }
    
    
    func getHomeCollectionViewCellVM(index: Int) ->HomeCollectionViewCellVM {
        if self.categoryList?.count != nil {
            return HomeCollectionViewCellVM(categoryListModel: (self.categoryList?[index])!)
        }
        return HomeCollectionViewCellVM(categoryListModel: CategoryListModel())
    }
    
    func getRestarentDishViewControllerVM() ->RestarentDishViewControllerVM {
        return RestarentDishViewControllerVM(shopDetailsModel: self.shopDetailsModel!)
    }
    
    func getRestaurentFoodPicksVCVM() ->RestaurentFoodPicksVCVM {
        return RestaurentFoodPicksVCVM(shopDetailsModel: self.shopDetailsModel ?? ShopDetailsModel(), getCartModel: self.getSelectedFood())
    }
    
    func getSelectedFood() ->[CartDataModel] {
        let selectedItems = self.getCartModel?.data ?? [CartDataModel()]
        return selectedItems
    }
    
    func getRecipeDetailsVCVM(id: Int) ->RecipeDetailsVCVM {
        return RecipeDetailsVCVM(proDuctDetailsModel: FoodItems(), index: 0, shopDetailsModel: self.shopDetailsModel ?? ShopDetailsModel())
    }
}
