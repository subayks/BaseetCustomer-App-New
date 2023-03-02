//
//  LocationDeliveryVCVM.swift
//  Baseet App
//
//  Created by Subendran on 19/08/22.
//

import Foundation

class LocationDeliveryVCVM {
    var apiServices: HomeApiServicesProtocol?
    var totalPrice: String?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var latitude: Double?
    var logitude: Double?
    var placeOrderModel: UpdateCartModel?
    var accessTokenModel: AccessTokenModel?
    var navigateToPaymentVC:((String)->())?
    var paymentType: PaymentType = .none
    var discountAmount: String?
    var taxAmount: String?
    var notes: String?
    var zoneModel: ZoneModel?
    var orderType: String?
    var discountAppled:String?
    
    init(totalPrice: String, discountAmount: String, taxAmount: String, notes: String, orderType: String, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.totalPrice = totalPrice
        self.taxAmount = taxAmount
        self.discountAmount = discountAmount
        self.notes = notes
        self.orderType = orderType
        self.apiServices = apiServices
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func placeOrderApi() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = self.getCartParam()
            self.apiServices?.placeOrderApi(finalURL: "\(Constants.Common.finalURL)/customer/order/place", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                print("\(Constants.Common.finalURL)/customer/order/place")
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.placeOrderModel = result as? UpdateCartModel
                    self.navigationClosure?()
                } else {

                self.alertClosure?(errorMessage ?? "Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getCartParam() -> String {
        let mobileNumber = UserDefaults.standard.string(forKey: "PhoneNumber")
        let Discount = UserDefaults.standard.integer(forKey: "Discount")
        discountAppled = UserDefaults.standard.string(forKey: "couponCode")
        print(discountAppled)
        if discountAppled == nil{
            let totalOrderAmount = UserDefaults.standard.string(forKey: "totalPrice")
            print(totalOrderAmount)
            var jsonToReturn: NSDictionary = NSDictionary()
            var paymentMode = ""
            if paymentType == .cash {
                paymentMode = "cash_on_delivery"
            } else if paymentType == .card {
                paymentMode =  "digital_payment"
            }
            let resID =  Int((UserDefaults.standard.string(forKey: "RestaurentId") ?? "") as String)
            jsonToReturn =  ["order_amount": "\(totalOrderAmount!)", "payment_method": paymentMode, "order_type": self.orderType ?? "", "order_time": self.currentTime(), "address": "Financial Street HYD", "latitude": "\(latitude ?? 0.0)", "longitude": "\(logitude ?? 0.0)", "contact_person_name": UserDefaults.standard.string(forKey: "Name") ?? "Unknown", "contact_person_number": "\(mobileNumber!)",  "restaurant_id": "\(resID ?? 0)", "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))","tax_amount": self.taxAmount ?? "", "discount_amount": Discount, "order_note": self.notes ?? "", "distance": distance!,"scheduled_at":isScheduledDateTime ?? ""]
            print(jsonToReturn)
            return self.convertDictionaryToJsonString(dict: jsonToReturn)!
        }else{
            var jsonToReturn: NSDictionary = NSDictionary()
            var paymentMode = ""
            if paymentType == .cash {
                paymentMode = "cash_on_delivery"
            } else if paymentType == .card {
                paymentMode =  "digital_payment"
            }
            let resID =  Int((UserDefaults.standard.string(forKey: "RestaurentId") ?? "") as String)
            jsonToReturn =  ["order_amount": "\(self.discountAppled ?? "")", "payment_method": paymentMode, "order_type": self.orderType ?? "", "order_time": self.currentTime(), "address": "Financial Street HYD", "latitude": "\(latitude ?? 0.0)", "longitude": "\(logitude ?? 0.0)", "contact_person_name": UserDefaults.standard.string(forKey: "Name") ?? "Unknown", "contact_person_number": "\(mobileNumber!)",  "restaurant_id": "\(resID ?? 0)", "user_id": "\(((UserDefaults.standard.string(forKey: "User_Id") ?? "") as String))","tax_amount": self.taxAmount ?? "", "discount_amount": Discount, "order_note": self.notes ?? "","distance": distance!,"scheduled_at":isScheduledDateTime ?? ""]
            print(jsonToReturn)
            return self.convertDictionaryToJsonString(dict: jsonToReturn)!
        }
        
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
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
    
    func getOrderSucessViewVCVM() ->OrderSucessViewVCVM {
        return OrderSucessViewVCVM(orderId: "\(self.placeOrderModel?.order_id ?? 12345)")
    }
    
    func getLoginParam() ->String {
    let jsonToReturn: NSDictionary = ["sadadId": "\(8962763)", "secretKey": "9H4ljR8UgNZ+KnHE", "domain": "www.baseetqa.com"]
    return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    }
    
    func accessToken() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let postParam = self.getLoginParam()
            self.apiServices?.accessTokenSADAD(finalURL: "https://api.sadadqatar.com/api-v4/userbusinesses/getsdktoken", withParameters: postParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.accessTokenModel = result as? AccessTokenModel
                    self.navigateToPaymentVC?(self.accessTokenModel?.accessToken ?? "")
                } else {

                self.alertClosure?(errorMessage ?? "Some technical problem")
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
}
