//
//  RecipeDetailsVCVM.swift
//  Baseet App
//
//  Created by Subendran on 06/08/22.
//

import Foundation
import UIKit

class RecipeDetailsVCVM {
    var proDuctDetailsModel: FoodItems?
    var index: Int?
    var apiServices: HomeApiServicesProtocol?
    var getCartModel: GetCartModel?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var reloadRecipieCollectionView:(()->())?
    var newIndex: Int?
    var deleteClosure:((String)->())?
    var isNewAddon: Bool = false
    var shopDetailsModel: ShopDetailsModel?
    var updateCartModel: UpdateCartModel?
    var addToCartModel: AddToCartModel?
    var showAdOnClosure:((Int, Int, [AddOns])->())?
    var navigateToCartViewClosure:(()->())?

    init(proDuctDetailsModel: FoodItems, index: Int, shopDetailsModel: ShopDetailsModel, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.shopDetailsModel = shopDetailsModel
        self.apiServices = apiServices
        self.proDuctDetailsModel = proDuctDetailsModel
        self.index = index
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getAddOnViewControllerVM() ->AddOnViewControllerVM {
        return AddOnViewControllerVM(addOns: self.proDuctDetailsModel?.addOns ?? [AddOns()])
    }
    
    func updateAdons(addOns: [AddOns]) {
        self.proDuctDetailsModel?.addOns = addOns
    }
    
    func setupAdons() ->[AddOns]{
        let adOns = self.proDuctDetailsModel?.addOns?.filter{$0.itemQuantity ?? 0 > 0}
        return adOns ?? [AddOns()]
    }
    
    func getAddOnViewControllerVM(index: Int) ->AddOnViewControllerVM {
        return AddOnViewControllerVM(addOns: self.proDuctDetailsModel?.addOns ?? [AddOns()])
    }
    
    func getCartCall(isFromCartScreen: Bool = false) {
        if Reachability.isConnectedToNetwork() {
            
            self.showLoadingIndicatorClosure?()
            // let id = self.addToCartModel?.data?[0].userId
            self.apiServices?.getCartApi(finalURL: "\(Constants.Common.finalURL)/products/get_cart?user_id=\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))", completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                print("\(Constants.Common.finalURL)/products/get_cart?user_id=\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))")
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.getCartModel = result as? GetCartModel
                        if self.getCartModel?.data?.count ?? 0 > 0 {
                            self.checkCurrentShopItems()
                        } else if isFromCartScreen {
                            let resID =  Int((UserDefaults.standard.string(forKey: "RestaurentId") ?? "") as String)
                          //  self.makeShopDetailsCall(limit: 10, id: resID ?? 0)
                        } else {
                            self.reloadRecipieCollectionView?()
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
    
    func decideFlow(itemCount: Int, index: Int, addOns: [AddOns]? = nil, isIncrementFlow: Bool) {
        if self.proDuctDetailsModel?.cartId != nil {
            if self.isNewAdon(index: index, addOns: addOns) && isIncrementFlow {
                self.createCartCall(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
            } else {
                self.updateCartCall(itemCount: itemCount, index: self.newIndex ?? index, addOns: addOns, isIncrementFlow: isIncrementFlow)
            }
        } else {
            if itemCount > 0 {
                if self.checkOtherShopItems() {
                    // self.deleteClosure?("The Cart has some items from different restaurent, Are you sure, you want to clear?")
                    self.deleteClosure?(LocalizationSystem.sharedInstance.localizedStringForKey(key: "This is different restaurant. You have to clear the cart first.", comment: ""))
                } else {
                    self.isNewAddon = true
                    self.createCartCall(itemCount: itemCount, index: index, addOns: addOns)
                }
            }
        }
    }
    
    func isNewAdon(index: Int, addOns: [AddOns]? = nil) ->Bool {
        let item = self.proDuctDetailsModel
        var boolValues = [Bool]()
        //New Item
        if let items = self.getCartModel?.data {
            let cartItems = items.filter{$0.id == "\(String(describing: item?.id ?? 0))"}
            if cartItems.count == 0 {
                self.isNewAddon = true
                return true
            }
        }
        
        if addOns != nil {
            if let items = self.getCartModel?.data {
                let cartItem = items.filter{$0.id == "\(String(describing: item?.id ?? 0))"}
                let itemWithAddon = cartItem.filter{$0.addon?.count != 0}
                let itemWithOutAddon = cartItem.filter{$0.addon?.count == 0 || $0.addon == nil}
                if cartItem.count > 0 {
                    if itemWithOutAddon.count > 0 && itemWithAddon.count == 0 {
                        self.isNewAddon = true
                        return true
                    } else {
                        return self.indexOfItemWithAddon(items: items, addOns: addOns)
                    }
                } else {
                    self.isNewAddon = true
                    return true
                }
            }
        } else {
            if !self.hasItemWithNoAddOn() {
                self.isNewAddon = true
                boolValues.append(true)
            } else {
                self.isNewAddon = false
                boolValues.append(false)
                self.newIndex = self.getCartModel?.data?.firstIndex{$0.id == "\(String(describing: item?.id ?? 0))"}
            }
        }
        
        if boolValues.contains(false) {
            isNewAddon = false
            return false
        } else {
            isNewAddon = true
            return true
        }
    }
    
    func indexOfItemWithAddon(items: [CartDataModel], addOns: [AddOns]? = nil) ->Bool {
        var boolValues = [Bool]()
        
        for (cartIndex, cartItems) in items.enumerated() {
            if let cartAddons = cartItems.addon, cartAddons.count > 0, let addOnValues = addOns {
                for cartAddonValues in  cartAddons {
                    let selectedAddon = addOnValues.filter({$0.itemQuantity != nil})
                    if selectedAddon.count > 0 {
                        if selectedAddon.count > 1 {
                            self.isNewAddon = self.isCartWithMoreAddonAvailable()
                            return self.isCartWithMoreAddonAvailable()
                        } else {
                            if cartAddons.count  > 1 {
                                if selectedAddon.count == 1 {
                                    boolValues.append(true)
                                } else {
                                    self.newIndex = cartIndex
                                    boolValues.append(false)
                                }
                            } else {
                                for (values) in selectedAddon {
                                    if cartAddonValues.addonname != values.name {
                                        boolValues.append(true)
                                    } else {
                                        self.newIndex = cartIndex
                                        boolValues.append(false)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        if boolValues.contains(false) {
            isNewAddon = false
            return false
        } else {
            isNewAddon = true
            return true
        }
    }
    
    func isCartWithMoreAddonAvailable() ->Bool {
        let multipleCartItem = self.getCartModel?.data?.filter({$0.addon?.count ?? 0 > 1})
        if multipleCartItem?.count ?? 0 > 0 {
            self.newIndex = self.getCartModel?.data?.firstIndex{$0.addon?.count ?? 0 > 1}
            return false
        } else {
            return true
        }
    }
    
    func hasItemWithNoAddOn() ->Bool{
        let addOnItems = self.getCartModel?.data?.filter({$0.addon?.count != 0})
        if addOnItems?.count == self.getCartModel?.data?.count {
            return false
        } else {
            return true
        }
    }
    
    func getCartParam(itemCount: Int, index: Int, addOns: [AddOns]? = nil, isIncrementFlow: Bool = false) -> String {
        let item = self.proDuctDetailsModel
        var jsonToReturn: NSDictionary = NSDictionary()
        var addOnsArray = [NSDictionary]()
        var adOnQuantity = 0
        if self.isNewAddon {
            adOnQuantity = 1
        } else {
            adOnQuantity = itemCount
        }
        //Mostly Decrement flow
        if addOns == nil {
            if let addOnItems = item?.addOns, addOnItems.count > 0 {
                for itemValue in (addOnItems) {
                    if itemValue.itemQuantity != nil &&  itemValue.itemQuantity != 0 {
                        if isIncrementFlow {
                            if self.isNewAddon {
                                jsonToReturn =  ["food_id": "\(item?.id ?? 0)", "food_qty": "1", "addon": [], "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
                            } else {
                                jsonToReturn = ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(item?.cartId ?? 0)"]
                            }
                            return self.convertDictionaryToJsonString(dict: jsonToReturn)!
                        } else {
                            if item?.itemQuantity ?? 0  > 0 {
                                adOnQuantity = (item?.itemQuantity ?? 0) - 1
                                addOnsArray.append(["addonname": "\(itemValue.name ?? "")", "addonprice": "\(itemValue.price ?? 0)", "addonquantity": "\(adOnQuantity)", "id": "\(itemValue.id ?? 0)"])
                            }
                        }
                    }
                }
            } else {
                if self.isNewAddon {
                    jsonToReturn =  ["food_id": "\(item?.id ?? 0)", "food_qty": "1", "addon": [], "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
                    return self.convertDictionaryToJsonString(dict: jsonToReturn)!
                } else {
                    let cartItem = self.getCartModel?.data?[index]
                    jsonToReturn = ["food_id": "\(cartItem?.id ?? "")", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(cartItem?.cartid ?? "")"]
                    jsonToReturn = ["food_id": "\(cartItem?.id ?? "")", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(cartItem?.cartid ?? "")"]
                    return self.convertDictionaryToJsonString(dict: jsonToReturn)!
                }
            }
        } else {
            if let addOns = addOns, addOns.count > 0 {
                //create flow if new add is selected
                if self.isNewAddon || self.getCartModel?.data?.count == 0 {
                    let selectedAddon = addOns.filter({$0.itemQuantity != nil})
                    for item in (selectedAddon) {
                        addOnsArray.append(["addonname": "\(item.name ?? "")", "addonprice": "\(item.price ?? 0)", "addonquantity": "\(adOnQuantity)", "id": "\(item.id ?? 0)"])
                    }
                    jsonToReturn =  ["food_id": "\(item?.id ?? 0)", "food_qty": "1", "addon": addOnsArray, "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
                } else {
                    let cartItem = self.getCartModel?.data?[index]
                    if let selectedAddon = cartItem?.addon?.filter({$0.addonquantity != nil}) {
                        for addonItem in (selectedAddon) {
                            let quanity = itemCount
                            addOnsArray.append(["addonname": "\(addonItem.addonname ?? "")", "addonprice": "\(addonItem.addonprice ?? "")", "addonquantity": "\(quanity)", "id": "\(addonItem.id ?? "")"])
                        }
                    }
                    jsonToReturn = ["food_id": "\(cartItem?.id ?? "")", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(cartItem?.cartid ?? "")"]
                }
                return self.convertDictionaryToJsonString(dict: jsonToReturn)!
            } else {
                //Create Cart
                if self.isNewAddon {
                    jsonToReturn =  ["food_id": "\(item?.id ?? 0)", "food_qty": "1", "addon": [], "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
                    return self.convertDictionaryToJsonString(dict: jsonToReturn)!
                }
            }
        }
        
        if item?.cartId != nil {
            if addOnsArray.count > 0 {
                jsonToReturn = ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(item?.cartId ?? 0)"]
            } else {
                jsonToReturn = ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": [], "cart_id": "\(item?.cartId ?? 0)"]
            }
        } else {
            //Create Cart
            if addOnsArray.count > 0 {
                jsonToReturn =  ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": addOnsArray, "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
            } else {
                jsonToReturn =  ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": [], "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
            }
        }
        return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    }
    
    func createCartCall(itemCount: Int, index: Int, addOns: [AddOns]? = nil, isIncrementFlow: Bool = false) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = self.getCartParam(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
            print(queryParam)
            print("\(Constants.Common.finalURL)/products/cart")
            self.apiServices?.addToCartApi(finalURL: "\(Constants.Common.finalURL)/products/cart", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.addToCartModel = result as? AddToCartModel
                        self.updateValues(itemCount: itemCount, index: index, addOns: addOns,cartId: self.addToCartModel?.data?[0].id ?? 0)
                    } else {
                        self.alertClosure?(errorMessage ?? "Some Technical problem")
                        self.getCartCall()
                    }
                }
            })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func updateCartCall(itemCount: Int, index: Int, addOns: [AddOns]? = nil, isIncrementFlow: Bool) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = self.getCartParam(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
            print(queryParam)
            print("\(Constants.Common.finalURL)/products/update_cart")
            self.apiServices?.updateCartApi(finalURL: "\(Constants.Common.finalURL)/products/update_cart", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.updateCartModel = result as? UpdateCartModel
                        self.updateValues(itemCount: itemCount, index: index, addOns: addOns)
                    } else {
                        self.alertClosure?( errorMessage ?? "Some technical problem")
                    }
                }
            })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func convertDictionaryToJsonString(dict: NSDictionary) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:dict, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            return jsonDataString
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        return nil
    }
    
    func checkCurrentShopItems() {
        let currentShopItem = self.getCartModel?.data?.filter({$0.restaurantId == "\(self.shopDetailsModel?.restaurant?.id ?? 0)"})
        if currentShopItem?.count ?? 0 > 0 {
            //self.isInitialUpdate = false
          //  self.updatePreviousItems(cartdataModel: currentShopItem ?? [CartDataModel]())
        }
        self.reloadRecipieCollectionView?()
    }
    
    func checkOtherShopItems() ->Bool{
        let otherShopItem = self.getCartModel?.data?.filter({$0.restaurantId != "\(self.shopDetailsModel?.restaurant?.id ?? 0)"})
        if otherShopItem?.count ?? 0 > 0 {
            return true
        } else {
            return false
        }
    }
    
    func updateValues(itemCount: Int, index: Int, addOns: [AddOns]? = nil, cartId: Int? = nil) {
        var item = self.proDuctDetailsModel
        item?.itemQuantity = itemCount
        if cartId != nil {
            item?.cartId = cartId
        }
        if itemCount == 0 {
            item?.cartId = nil
        }
        if addOns != nil && addOns?.count != 0{
            item?.addOns = addOns
        }
        self.proDuctDetailsModel = nil
        self.proDuctDetailsModel = item
        self.newIndex = nil
        getCartCall()
        //  self.reloadRecipieCollectionView?()
    }
    
    func isItemAvailable() ->Bool {
        if let items = self.getCartModel?.data {
            let itemAvailable = items.filter{(Int($0.foodQty ?? "")  ?? 0) > 0}
            if itemAvailable.count == 0 {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    func deleteCart() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let cartID = self.getCartModel?.data?[0].cartid ?? ""
            print("\(Constants.Common.finalURL)/products/cart_delete/\(cartID)")
            self.apiServices?.deleteCartApi(finalURL: "\(Constants.Common.finalURL)/products/cart_delete/\(cartID)", completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.getCartCall()
                    } else {
                        self.alertClosure?( errorMessage ?? "Some technical problem")
                    }
                }
            })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getRestaurentFoodPicksVCVM() ->RestaurentFoodPicksVCVM {
        return RestaurentFoodPicksVCVM(shopDetailsModel: self.shopDetailsModel, getCartModel: self.getSelectedFood())
    }
    
    func getSelectedFood() ->[CartDataModel] {
        let selectedItems = self.getCartModel?.data ?? [CartDataModel()]
        return selectedItems
    }
    
    func setUpItemsList() {
        UserDefaults.standard.set(self.shopDetailsModel?.restaurant?.id, forKey: "RestaurentId")
        self.getCartCall()
    }
    
//    func updatePreviousItems(cartdataModel: [CartDataModel]) {
//        self.proDuctDetailsModel = self.shopDetailsModel?.products
//        for item in cartdataModel {
//            if  let index = self.foodItems?.firstIndex(where: {$0.id == Int(item.cartfoodid ?? "")}) {
//                var foodItem = self.foodItems?[index]
//                foodItem?.itemQuantity = Int(item.foodQty ?? "")
//                self.foodItems?.remove(at: index)
//
//                if item.cartid != nil {
//                    foodItem?.cartId = Int(item.cartid ?? "")
//                }
//
//                if Int(item.foodQty ?? "") == 0 {
//                    foodItem?.cartId = nil
//                }
//
//                if let adonItem = item.addon, adonItem.count != 0 {
//                    for values in adonItem {
//                        guard let adonIndex = foodItem?.addOns?.firstIndex(where: {$0.id == Int(values.id ?? "")}) else { return }
//                        var adOnFinalItem = foodItem?.addOns?[adonIndex]
//                        adOnFinalItem?.id = Int(values.id ?? "")
//                        adOnFinalItem?.price = Int(values.addonprice ?? "")
//                        adOnFinalItem?.itemQuantity = Int(values.addonquantity ?? "")
//                        adOnFinalItem?.name = values.addonname
//                        adOnFinalItem?.restaurantId = foodItem?.restaurantId
//                        foodItem?.addOns?.remove(at: adonIndex)
//                        foodItem?.addOns?.insert(adOnFinalItem ?? AddOns(), at: adonIndex)
//                    }
//                }
//                self.foodItems?.insert(foodItem ?? FoodItems(), at: index)
//            }
//        }
//        //   self.reloadRecipieCollectionView?()
//    }
}
