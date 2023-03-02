//
//  MyPlacesModelVM.swift
//  Baseet App
//
//  Created by apple on 24/11/22.
//

import Foundation

class MyPlacesVM {
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

    init(shopDetailsModel: ShopDetailsModel? = ShopDetailsModel(), getCartModel: [CartDataModel], apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.getCartModel = getCartModel
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
    
    func updateCartCall(itemCount: Int, index: Int, addOns: [AddOns]? = nil) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            var queryParam = String()
            if addOns != nil {
                queryParam = self.getCartParamforAddOn(itemCount: itemCount, index: index, addOns: addOns ?? [AddOns]())
            } else {
                queryParam = self.getCartParam(itemCount: itemCount, index: index)
            }
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
    
    func getCartParam(itemCount: Int, index: Int) -> String {
        let item = self.getCartModel?[index]
        var jsonToReturn: NSDictionary = NSDictionary()
        var addOnsArray = [NSDictionary]()

        if let addOns = item?.addon, addOns.count > 0 {
            for addonItem in (addOns) {
                addOnsArray.append(["addonname": "\(addonItem.addonname ?? "")", "addonprice": "\(addonItem.addonprice ?? "")", "addonquantity": "\(addonItem.addonquantity ?? "")", "id": "\(addonItem.id ?? "")"])
            }
        }
        
        if addOnsArray.count > 0 {
            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(item?.cartid ?? "")"]
        } else {
            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": [], "cart_id": "\(item?.cartid ?? "")"]
        }
        return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    }
    
    func getCartParamforAddOn(itemCount: Int, index: Int, addOns:[ AddOns]) -> String {
        let item = self.getCartModel?[index]
        var jsonToReturn: NSDictionary = NSDictionary()
        var addOnsArray = [NSDictionary]()

        if addOns.count > 0 {
            for addonItem in (addOns) {
                addOnsArray.append(["addonname": "\(addonItem.name ?? "")", "addonprice": "\(addonItem.price ?? 0)", "addonquantity": "\(addonItem.itemQuantity ?? 0)", "id": "\(addonItem.id ?? 0)"])
            }
        }
        
        if addOnsArray.count > 0 {
            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(item?.foodQty ?? "")", "addon": addOnsArray, "cart_id": "\(item?.cartid ?? "")"]
        } else {
            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(item?.foodQty ?? "")", "addon": [], "cart_id": "\(item?.cartid ?? "")"]
        }
        return self.convertDictionaryToJsonString(dict: jsonToReturn)!
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
    
    func getLocationDeliveryVCVM(orderType: String) ->LocationDeliveryVCVM {
        print("myplaces")
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
            }
            return priceArray.sum()
        }
        return 0
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
    
    func grandTotal() ->String {
        return "QR \(self.priceCalculation() + self.taxCalculation())"
    }
    
    func grandTotalAmount() ->Double{
        return Double(self.priceCalculation() + self.taxCalculation())
    }
    
    func getAddNoteVCVM() ->AddNoteVCVM {
        return AddNoteVCVM(notes: self.notes ?? "", voiceRecord: "")
    }

    func customizeAddons(productIndex: Int) ->[AddOns] {
     //   var addOns = [AddOns]()
        
        //        let product = self.getCartModel?[productIndex]
        //        if let cartProduct =  self.shopDetailsModel?.products {
        //        for item in cartProduct {
        //            if item.name == product?.name {
        //                if let addOnsList =  item.addOns {
        //                    for item in addOnsList {
        //                        var addOn = AddOns()
        //                        addOn = item
        //                        addOn.quantity = product.quantity
        //                        addOns.append(addOn)
        //                    }
        //                }
        //            }
        //        }
        //        }
        
        let cartProduct =  self.getProduct(selectedIndex: productIndex)
//        if let addOnValue = cartProduct.addOns {
//            for item in addOnValue {
//                var addOn = AddOns()
//                addOn = item
//                addOn.quantity = item.quantity
//                addOns.append(addOn)
//            }
//        }
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
                          
                            foodItems.addOns?[index].itemQuantity = Int(selectedAdons[index].addonquantity ?? "")
                        }
                        return foodItems
                    }
                }
            }
        }
        return foodItems
    }
    
    
    func getAddOnViewControllerVM(index: Int) ->AddOnViewControllerVM {
        return AddOnViewControllerVM(addOns: self.customizeAddons(productIndex: index))
    }
    
    
    func decideFlow(itemCount: Int, index: Int, addOns: [AddOns]? = nil) {
      //  if  self.shopDetailsModel?.products?[index].cartId != nil {
            self.updateCartCall(itemCount: itemCount, index: index, addOns: addOns)
      //  }
//        else {
//            if itemCount > 0 {
//                if self.checkOtherShopItems() {
//                    self.deleteClosure?("The Cart has some items from different restaurent, Are you sure, you want to clear?")
//                } else {
//                     self.createCartCall(itemCount: itemCount, index: index, addOns: addOns)
//                }
//            }
//        }
    }
    
}
