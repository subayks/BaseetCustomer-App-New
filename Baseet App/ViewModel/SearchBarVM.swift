//
//  SearchBarVM.swift
//  Baseet App
//
//  Created by Subendran on 21/09/22.
//

import Foundation

class SearchBarVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var searchModel: SearchModel?
    var navigateToDetailsClosure:(()->())?
    var shopDetailsModel: ShopDetailsModel?
    var shopListModel: ShopListModel?
    var iconArray = [String]()
    
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
            self.apiServices?.getShopNearBy(finalURL: "\(Constants.Common.finalURL)/restaurants/get-nearby", httpHeaders: httpHeaders, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.shopListModel = result as? ShopListModel
                        self.imageArray()
                    } else {
                        self.alertClosure?(errorMessage ?? "Some Technical Problem")
                    }
                }
            })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func imageArray() {
        if let restaurents = self.shopListModel?.restaurants {
            for item in restaurents {
                self.iconArray.append(item.applogo ?? "")
            }
        }
        self.reloadClosure?()
    }
    
    func makeShopDetailsCall(id: Int) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getShopDetails(finalURL: "\(Constants.Common.finalURL)/products/product_by_restaurant?restaurant_id=\(id)&category_id=0&limit=10&offset=1",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.shopDetailsModel = result as? ShopDetailsModel
                    self.navigateToDetailsClosure?()
                } else {
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
    
    func getRestarentDishViewControllerVM() ->RestarentDishViewControllerVM {
        return RestarentDishViewControllerVM(shopDetailsModel: self.shopDetailsModel!)
    }
    
}
