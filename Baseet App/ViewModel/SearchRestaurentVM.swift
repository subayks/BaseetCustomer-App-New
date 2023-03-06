//
//  SearchRestaurentVM.swift
//  Baseet App
//
//  Created by Subendran on 21/09/22.
//

import Foundation

class SearchRestaurentVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var searchModel: SearchModel?
    var navigateToDetailsClosure:((Int)->())?
    var shopDetailsModel: ShopDetailsModel?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getSearchItem(query: String) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            // let id = self.addToCartModel?.data?[0].userId
            print("\(Constants.Common.finalURL)/restaurants/search?name=\(query)")
            self.apiServices?.getSearchList(finalURL: "\(Constants.Common.finalURL)/restaurants/search?name=\(query)", completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async { [self] in
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.searchModel = result as? SearchModel
                        if searchModel?.restaurants?.count == 0{
                            self.alertClosure?(errorMessage ?? "No Restaurants Found")
                            reloadClosure?()
                        }else{
                            reloadClosure?()
                        }
                        reloadClosure?()
                    } else {
                        self.alertClosure?(errorMessage ?? "Some Technical Problem")
                    }
                }
            })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    
    func getSearchProductItem(query: String) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            // let id = self.addToCartModel?.data?[0].userId
            print("\(Constants.Common.finalURL)/restaurants/search?name=\(query)")
            self.apiServices?.getSearchList(finalURL: "\(Constants.Common.finalURL)/restaurants/search?name=\(query)", completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async { [self] in
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.searchModel = result as? SearchModel
                        if searchModel?.products?.count == 0{
                            self.alertClosure?(errorMessage ?? "No Products Found")
                            reloadClosure?()
                        }else{
                            reloadClosure?()
                        }
                        // reloadClosure?()
                        
                    } else {
                        self.alertClosure?(errorMessage ?? "Some Technical Problem")
                    }
                }
            })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    
    func makeShopDetailsCall(id: Int, foodId: Int) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getShopDetails(finalURL: "\(Constants.Common.finalURL)/products/product_by_restaurant?restaurant_id=\(id)&category_id=0&limit=10&offset=1",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.shopDetailsModel = result as? ShopDetailsModel
                        self.navigateToDetailsClosure?(foodId)
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
    
    func getRecipeDetailsVCVM(id: Int) ->RecipeDetailsVCVM {
        let foodProduct = self.searchModel?.products?.filter{$0.id == id}
        return RecipeDetailsVCVM(proDuctDetailsModel: foodProduct?[0] ?? FoodItems(), index: 0, shopDetailsModel: self.shopDetailsModel ?? ShopDetailsModel())
    }
    
    func getMyFevTableViewCellVM(index: Int) ->HomeCollectionViewDownCellVM {
        return HomeCollectionViewDownCellVM(restaurantsModel: self.searchModel?.restaurants?[index] ?? RestaurantsModel())
    }
    
    func getFoodItemTableViewCellVM() ->FoodItemTableViewCellVM {
        return FoodItemTableViewCellVM(products: self.searchModel?.products ?? [FoodItems]())
    }
    
}
