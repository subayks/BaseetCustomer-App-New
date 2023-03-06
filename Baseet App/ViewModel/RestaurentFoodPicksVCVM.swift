//
//  RestaurentFoodPicksVCVM.swift
//  Baseet App
//
//  Created by Subendran on 09/08/22.
//

import Foundation

class RestaurentFoodPicksVCVM {
    var apiServices: HomeApiServicesProtocol?
    var getCartModel: [CartDataModel]?
    var reloadTableViewClosure:(()->())?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var updateCartModel: UpdateCartModel?
    var itemId = [Int]()
    var itemCount = [Int]()
    var userID = String()
    var coupontype:String!
    var distance:Int!
    var getCartData: GetCartModel?
    var notes: String?
    var shopDetailsModel: ShopDetailsModel?
    var addToCartModel: AddToCartModel?
    var reloadRecipieCollectionView:(()->())?
    var isNewAddon: Bool = false
    var newIndex: Int?

    var foodItems: [FoodItems]? {
        didSet {
            self.reloadRecipieCollectionView?()
        }
    }
    
    init(shopDetailsModel: ShopDetailsModel? = ShopDetailsModel(), getCartModel: [CartDataModel], apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.getCartModel = getCartModel
        print(self.getCartModel)
        self.apiServices = apiServices
        self.shopDetailsModel = shopDetailsModel
        self.userID = self.getCartModel?[0].cartuserid ?? ""
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getRestFoodPickTableViewCellVM(index: Int) ->RestFoodPickTableViewCellVM {
        return RestFoodPickTableViewCellVM(foodItems: self.getCartModel?[index] ?? CartDataModel())
    }
    
    func updateCartCall(itemCount: Int, index: Int, addOns: [AddOns]? = nil, isIncrementFlow: Bool, repeatMode: Bool = false) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            var queryParam = String()
            
            if addOns != nil {
                queryParam = self.getCartParams(itemCount: itemCount, index: index, addOns: addOns ?? [AddOns](), isIncrementFlow: isIncrementFlow)
                print(queryParam)
            } else {
                if repeatMode {
                    queryParam = self.getRepeatModeParam(index: index)
                } else {
                    queryParam = self.getCartParams(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
                }
                print(queryParam)
            }
            print("\(Constants.Common.finalURL)/products/update_cart")
            self.apiServices?.updateCartApi(finalURL: "\(Constants.Common.finalURL)/products/update_cart", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.updateCartModel = result as? UpdateCartModel
                        let item = self.getCartModel?[index]
                        self.itemId.append(Int(item?.id ?? "") ?? 0)
                        self.itemCount.append(itemCount)
                        self.getCartCall()
                        //      self.updateValues(itemCount: itemCount, index: index, addOns: addOns)
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
            print(coupontype)
            if coupontype == nil{
                coupontype = ""
                distance = 0
                self.showLoadingIndicatorClosure?()
                print("\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)&coupon_type=\(coupontype!)&distance=\(distance!)")
                self.apiServices?.getCartApi(finalURL: "\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)&coupon_type=\(coupontype!)&distance=\(distance!)", completion: { [self] (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                    print("\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)&coupon_type=\(self.coupontype!)&distance=\(distance!)")
                    
                    DispatchQueue.main.async {
                        self.hideLoadingIndicatorClosure?()
                        if status == true {
                            self.getCartData = result as? GetCartModel
                            self.getCartModel = self.getCartData?.data
                            print("\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)")
                            self.reloadTableViewClosure?()
                        } else {
                            self.alertClosure?(errorMessage ?? "Some Technical Problem")
                        }
                    }
                })
            }else{
                self.showLoadingIndicatorClosure?()
                print("\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)&coupon_type=\(coupontype!)&distance=\(distance!)")
                self.apiServices?.getCartApi(finalURL: "\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)&coupon_type=\(coupontype!)&distance=\(distance!)", completion: { [self] (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                    print("\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)&coupon_type=\(self.coupontype!)&distance=\(distance!)")
                    
                    DispatchQueue.main.async {
                        self.hideLoadingIndicatorClosure?()
                        if status == true {
                            self.getCartData = result as? GetCartModel
                            self.getCartModel = self.getCartData?.data
                            print("\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)")
                            self.reloadTableViewClosure?()
                        } else {
                            self.alertClosure?(errorMessage ?? "Some Technical Problem")
                        }
                    }
                })
            }
            
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    //    func updateValues(itemCount: Int, index: Int, addOns: [AddOns]? = nil, cartId: Int? = nil) {
    //        var item = self.foodOrderItems?.foodItems?[index]
    //        self.itemId.append(Int(item?.id ?? "") ?? 0)
    //        self.itemCount.append(itemCount)
    //        item?.foodQty = "\(itemCount)"
    ////        if cartId != nil {
    ////        item?.cartId = cartId
    ////        }
    ////        if addOns != nil && addOns?.count != 0{
    ////        item?.addOns = addOns
    ////        }
    //        self.foodOrderItems?.foodItems?.remove(at: index)
    //        self.foodOrderItems?.foodItems?.insert(item ?? CartDataModel(), at: index)
    //        self.reloadTableViewClosure?()
    //    }
    
    //    func getCartParamforAddOn(itemCount: Int, index: Int, addOns:[ AddOns], isIncrementFlow: Bool = false) -> String {
    //        let item = self.getCartModel?[index]
    //        var jsonToReturn: NSDictionary = NSDictionary()
    //        var addOnsArray = [NSDictionary]()
    //
    //        if addOns.count > 0 {
    //            for addonItem in (addOns) {
    //                addOnsArray.append(["addonname": "\(addonItem.name ?? "")", "addonprice": "\(addonItem.price ?? 0)", "addonquantity": "\(addonItem.itemQuantity ?? 0)", "id": "\(addonItem.id ?? 0)"])
    //            }
    //        }
    //
    //        if addOnsArray.count > 0 {
    //            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(item?.foodQty ?? "")", "addon": addOnsArray, "cart_id": "\(item?.cartid ?? "")"]
    //        } else {
    //            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(item?.foodQty ?? "")", "addon": [], "cart_id": "\(item?.cartid ?? "")"]
    //        }
    //        return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    //    }
    
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
    
    func getLocationDeliveryVCVM(orderType: String) ->LocationDeliveryVCVM {
        return LocationDeliveryVCVM(totalPrice: "\(self.priceCalculation() + self.taxCalculation())",discountAmount: String(self.totalSaving()), taxAmount: String(self.taxCalculation()), notes: self.notes ?? "", orderType: orderType)
    }
    
    //    func priceCalculation() ->Int {
    //        var priceArray = [Int]()
    //        if let selectedFoodItems = self.foodOrderItems?.foodItems {
    //            for item in selectedFoodItems {
    //                priceArray.append((item.price! as NSString).integerValue * (Int(item.foodQty ?? "") ?? 0))
    //            if let adOnItem = item.addon, adOnItem.count > 0 {
    //            for adOn in adOnItem {
    //                if adOn.addonquantity != nil && (Int(adOn.addonquantity ?? "") ?? 0) > 0 {
    //                    priceArray.append((Int(adOn.addonprice ?? "") ?? 0) * (Int(adOn.addonquantity ?? "") ?? 0))
    //                }
    //            }
    //            }
    //        }
    //            return priceArray.sum()
    //        }
    //        return 0
    //    }
    
    func priceCalculation() ->Int {
        var priceArray = [Int]()
        if let selectedFoodItems = self.getCartModel {
            for item in selectedFoodItems {
                priceArray.append(item.tprice ?? 0)
                UserDefaults.standard.set(item.tprice ?? 0, forKey: "tprice")
                print(item.tprice!)
            }
            return priceArray.sum()
        }
        return 0
    }
    
    func deliveryCharge() ->String{
        var deliveryChargeArray = [String]()
        if let selectedFoodItems = self.getCartModel {
            for item in selectedFoodItems {
                deliveryChargeArray.append(item.deliverycharge ?? "")
                UserDefaults.standard.set(item.deliverycharge ?? "", forKey: "deliveryCharge")
                print(item.deliverycharge!)
            }
        }

        return ""
    }
    
    func totalSaving() ->Double {
        var discount = [Double]()
        if let selectedFoodItems = self.getCartModel {
            for item in selectedFoodItems {
                discount.append(Double(item.discount ?? "") ?? 0.00)
            }
            return discount.sum()
        }
        return 0
    }
    
    func taxCalculation() ->Int {
        var taxArray = [Int]()
        if let selectedFoodItems = self.getCartModel {
            for item in selectedFoodItems {
                taxArray.append(Int(item.tax ?? "") ?? 0)
            }
            return taxArray.sum()
        }
        return 0
    }
    
    func grandTotal() ->Int {
        return (self.priceCalculation() + self.taxCalculation())
    }
    
    func grandTotalAmount() ->Double{
        return Double(self.priceCalculation() + self.taxCalculation())
    }
    
    func getAddNoteVCVM() ->AddNoteVCVM {
        return AddNoteVCVM(notes: self.notes ?? "", voiceRecord: "")
    }
    
    func customizeAddons(productIndex: Int) ->[AddOns] {
        let cartProduct =  self.getProduct(selectedIndex: productIndex)
        return cartProduct.addOns ?? [AddOns]()
    }
    
    func getProduct(selectedIndex: Int) ->FoodItems{
        var foodItems = FoodItems()
        if let cartProduct =  self.shopDetailsModel?.products, let selectedProdut = self.getCartModel?[selectedIndex], let selectedAdons = selectedProdut.addon {
            
            for item in cartProduct {
                if item.name == selectedProdut.name {
                    foodItems = item
                    if let finalList = foodItems.addOns {
                        for (index,values) in finalList.enumerated() {
                            for i in selectedAdons {
                                if i.addonname == values.name {
                                    foodItems.addOns?[index].itemQuantity = Int(i.addonquantity ?? "")
                                }
                            }
                        }
                       // return foodItems
                    }
                }
            }
        }
        return foodItems
    }
    
    
    func getAddOnViewControllerVM(index: Int) ->AddOnViewControllerVM {
        return AddOnViewControllerVM(addOns: self.customizeAddons(productIndex: index), isFromCheckoutScreen: true)
    }
    
    func decideFlow(itemCount: Int, index: Int, addOns: [AddOns]? = nil, isIncrementFlow: Bool, repeatMode: Bool = false, isCustomizeFlow: Bool = false) {
        if repeatMode {
            self.updateCartCall(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow, repeatMode: repeatMode)
        } else if isCustomizeFlow {
            self.updateCartCall(itemCount: 1, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow, repeatMode: repeatMode)
        } else {
            if self.isNewAdon(index: index, addOns: addOns) && isIncrementFlow {
                self.createCartCall(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
            } else {
                self.updateCartCall(itemCount: itemCount, index: self.newIndex ?? index, addOns: addOns, isIncrementFlow: isIncrementFlow)
            }
        }
    }
    
    func getRepeatModeParam(index: Int) ->String {
        let item = self.getCartModel?[index]
        var jsonToReturn: NSDictionary = NSDictionary()
        var addOnsArray = [NSDictionary]()
        var adOnQuantity = 0
        adOnQuantity = (Int(item?.foodQty ?? "") ?? 0) + 1
        
        if item?.addon != nil {
            if let addOnItems = item?.addon, addOnItems.count > 0 {
                for itemValue in (addOnItems) {
                    addOnsArray.append(["addonname": "\(itemValue.addonname ?? "")", "addonprice": "\(itemValue.addonprice ?? "")", "addonquantity": "\(adOnQuantity)", "id": "\(itemValue.id ?? "")"])
                }
                jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(adOnQuantity)", "addon": addOnsArray, "cart_id": "\(item?.cartid ?? "")"]
                return self.convertDictionaryToJsonString(dict: jsonToReturn)!
            }
        } else {
            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(adOnQuantity)", "addon": [], "cart_id": "\(item?.cartid ?? "")"]
            return self.convertDictionaryToJsonString(dict: jsonToReturn)!
        }
        return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    }
    
    func getCartParams(itemCount: Int, index: Int, addOns: [AddOns]? = nil, isIncrementFlow: Bool = false) -> String {
        let item = self.getCartModel?[index]
        var jsonToReturn: NSDictionary = NSDictionary()
        var addOnsArray = [NSDictionary]()
        var adOnQuantity = 0
        //May be decrement flow or increment with no Addon
        if self.isNewAddon {
            adOnQuantity = 1
        } else {
            if self.newIndex != nil {
                adOnQuantity = (Int(item?.foodQty ?? "") ?? 0) + 1
            } else {
                adOnQuantity = itemCount
            }
        }
        
        if addOns == nil {
            if let addOnItems = item?.addon, addOnItems.count > 0 {
                for itemValue in (addOnItems) {
                    if itemValue.addonquantity != nil &&  itemValue.addonquantity != "0" {
                        if isIncrementFlow {
                            if self.isNewAddon {
                                jsonToReturn =  ["food_id": "\(item?.id ?? "")", "food_qty": "1", "addon": [], "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
                            } else {
                                jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(item?.cartid ?? "")"]
                            }
                            return self.convertDictionaryToJsonString(dict: jsonToReturn)!
                        } else {
                            if let foodQty = Int(item?.foodQty ?? ""), foodQty > 0 {
                                adOnQuantity = foodQty - 1
                                addOnsArray.append(["addonname": "\(itemValue.addonname ?? "")", "addonprice": "\(itemValue.addonprice ?? "")", "addonquantity": "\(adOnQuantity)", "id": "\(itemValue.id ?? "")"])
                                jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(item?.cartid ?? "")"]
                            }
                            return self.convertDictionaryToJsonString(dict: jsonToReturn)!
                        }
                    }
                }
            } else {
                if !self.hasItemWithNoAddOn() {
                    jsonToReturn =  ["food_id": "\(item?.id ?? "")", "food_qty": "1", "addon": [], "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
                } else {
                    jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": [], "cart_id": "\(item?.cartid ?? "")"]
                }
                return self.convertDictionaryToJsonString(dict: jsonToReturn)!
            }
        } else {
            //Addon flow
            if let addOns = addOns, addOns.count > 0 {
                let selectedAddon = addOns.filter({$0.itemQuantity != nil})
                for item in (selectedAddon) {
                    addOnsArray.append(["addonname": "\(item.name ?? "")", "addonprice": "\(item.price ?? 0)", "addonquantity": "\(adOnQuantity )", "id": "\(item.id ?? 0)"])
                }
                //create flow if new add is selected
                if self.isNewAddon {
                    jsonToReturn =  ["food_id": "\(item?.id ?? "")", "food_qty": "1", "addon": addOnsArray, "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))"]
                } else {
                    jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(adOnQuantity)", "addon": addOnsArray, "cart_id": "\(item?.cartid ?? "")"]
                }
            } else {
                jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": [], "cart_id": "\(item?.cartid ?? "")"]
            }
            
        }
        return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    }
    
    func isNewAdon(index: Int, addOns: [AddOns]? = nil) ->Bool {
        var boolValues = [Bool]()
        
        
        if addOns != nil {
            let cartItem = self.getCartModel?.filter{$0.id == self.getCartModel?[index].id ?? ""}
            let itemWithAddon = cartItem?.filter{$0.addon?.count != 0}
            let itemWithOutAddon = cartItem?.filter{$0.addon?.count == 0 || $0.addon == nil}
            
            if itemWithOutAddon?.count ?? 0 > 0 && itemWithAddon?.count ?? 0 == 0 {
                self.isNewAddon = true
                return true
            } else {
                self.isNewAddon = self.indexOfItemWithAddon(items: self.getCartModel ?? [], addOns: addOns)
                return self.indexOfItemWithAddon(items: self.getCartModel ?? [], addOns: addOns)
            }
        } else {
            if (self.getCartModel?[index].addon != nil && self.getCartModel?[index].addon?.count != 0) && addOns == nil {
                if !self.hasItemWithNoAddOn() {
                    boolValues.append(true)
                } else {
                    boolValues.append(false)
                }
            } else {
                if !self.hasItemWithNoAddOn() {
                    boolValues.append(true)
                } else {
                    boolValues.append(false)
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
    
    func hasItemWithNoAddOn() ->Bool{
        let addOnItems = self.getCartModel?.filter({$0.addon?.count != 0})
        if addOnItems?.count == self.getCartModel?.count {
            return false
        } else {
            return true
        }
    }
    
    func isCartWithMoreAddonAvailable() ->Bool {
        let multipleCartItem = self.getCartModel?.filter({$0.addon?.count ?? 0 > 1})
        if multipleCartItem?.count ?? 0 > 0 {
            self.newIndex = self.getCartModel?.firstIndex{$0.addon?.count ?? 0 > 1}
            return false
        } else {
            return true
        }
    }
    
    func createCartCall(itemCount: Int, index: Int, addOns: [AddOns]? = nil, isIncrementFlow: Bool = false) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = self.getCartParams(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
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
    
    func updateValues(itemCount: Int, index: Int, addOns: [AddOns]? = nil, cartId: Int? = nil) {
        var item = self.foodItems?[index]
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
        self.foodItems?.remove(at: index)
        self.foodItems?.insert(item ?? FoodItems(), at: index)
        self.newIndex = nil
        getCartCall()
        //  self.reloadRecipieCollectionView?()
    }
    
}
