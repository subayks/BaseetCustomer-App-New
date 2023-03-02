//
//  MyFavoritesVM.swift
//  Baseet App
//
//  Created by Subendran on 20/09/22.
//

import Foundation

class MyFavoritesVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var favModel: FavouriteModel?
    var shopDetailsModel: ShopDetailsModel?
    var navigateToDetailsClosure:(()->())?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func wishListCall() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getFavouriteList(finalURL: "\(Constants.Common.finalURL)/customer/wish-list", completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.favModel = result as? FavouriteModel
                    self.reloadClosure?()
                } else {
                   self.alertClosure?( errorMessage ?? "Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getMyFevTableViewCellVM(index: Int) ->MyFevTableViewCellVM {
        return MyFevTableViewCellVM(restaurent: self.favModel?.restaurant?[index] ?? RestaurantsModel())
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
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getRestarentDishViewControllerVM() ->RestarentDishViewControllerVM {
        return RestarentDishViewControllerVM(shopDetailsModel: self.shopDetailsModel!)
    }
    
    func removeFavouriteCall(id: Int) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = ""
            self.apiServices?.removeWishList(finalURL: "\(Constants.Common.finalURL)/customer/wish-list/remove?restaurant_id=\(id)", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.wishListCall()
                } else {
                   self.alertClosure?( errorMessage ?? "Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
}
