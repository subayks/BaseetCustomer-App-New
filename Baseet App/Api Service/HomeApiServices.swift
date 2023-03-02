//
//  HomeApiServices.swift
//  Baseet App
//
//  Created by Subendran on 01/08/22.

import Foundation
protocol HomeApiServicesProtocol {
    func loginApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func replaceUser(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getShopNearBy(finalURL: String, httpHeaders: [String: String], completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
//    func getBannerBy(finalURL: String, httpHeaders: [String: String], completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getPopular(finalURL: String, httpHeaders: [String: String], completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getCategoryList(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getShopDetails(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getProductDetails(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func addToCartApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func updateCartApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func deleteCartApi(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getCartApi(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func placeOrderApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func accessTokenSADAD(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getFavouriteList(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func addWishList(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func addAddress(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func removeWishList(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getCouponList(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getSearchList(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func searchProductList(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getZoneID(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func uploadProfileApi(finalURL: String, withParameters: ImageRequestParam, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getCustomerInfo(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func updateProfileApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func orderTrackDetails(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func orderListApi(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func notificationApi(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func feedbackApi(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
}

class HomeApiServices: HomeApiServicesProtocol {
    
    
   
    
    
    func addAddress(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ReplaceUserModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
            }
        })
    }
    
    
    
    
    func getPopular(finalURL: String, httpHeaders: [String: String],completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let zoneId = UserDefaults.standard.string(forKey: "zoneID")
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            "zoneId": "\(zoneId ?? "")"
            ]
        NetworkAdapter.clientNetworkRequestArrayResponseCodable(withBaseURL: finalURL, withParameters: "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode([NotificationModel].self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )

    }
    
    func feedbackApi(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let zoneId = UserDefaults.standard.string(forKey: "zoneID")
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            "zoneId": "\(zoneId ?? "")"
            ]
        NetworkAdapter.clientNetworkRequestArrayResponseCodable(withBaseURL: finalURL, withParameters: "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode([NotificationModel].self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func notificationApi(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let zoneId = UserDefaults.standard.string(forKey: "zoneID")
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            "zoneId": "\(zoneId ?? "")"
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(NotificationModel.self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
        
    func orderListApi(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    
                    let values = try decoder.decode(OrdersListModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func orderTrackDetails(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(OrderTrackModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    
    func updateProfileApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ReplaceUserModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
            }
        })
    }
    
    func getCustomerInfo(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(CustomerInfoModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func uploadProfileApi(finalURL: String, withParameters: ImageRequestParam, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        NetworkAdapter.uploadImage(withBaseURL: finalURL, withParameters: withParameters, withHeaders: headers,  withHttpMethod: "POST", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ReplaceUserModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
            }
        })
    }
    
    func getZoneID(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
       
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: [String : String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ZoneModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func searchProductList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let zoneId = UserDefaults.standard.string(forKey: "zoneID")
        let headers = [
            "zoneId": "\(zoneId ?? "")",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(SearchModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getSearchList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let zoneId = UserDefaults.standard.string(forKey: "zoneID")
        let headers = [
            "zoneId": "\(zoneId ?? "")",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(SearchModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getCouponList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let zoneId = UserDefaults.standard.string(forKey: "zoneID")
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            "zoneId": "\(zoneId ?? "")",
            ]
        print(headers)
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(CouponModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func removeWishList(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "DELETE", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ReplaceUserModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
            }
        })
    }
    
    func addWishList(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ReplaceUserModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
            }
        })
    }
    
    
    func getFavouriteList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let zoneId = UserDefaults.standard.string(forKey: "zoneID")
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            "zoneId": "\(zoneId ?? "")",
            ]
        print(zoneId)
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(FavouriteModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func replaceUser(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void)  {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ReplaceUserModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    func loginApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(LoginModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func accessTokenSADAD(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {

        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(AccessTokenModel.self, from: result!)
                    if values.error != nil {
                        completion(false,errorCode,nil,values.error?.text)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func placeOrderApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            ]
        print(headers)
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(UpdateCartModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    
    func getCartApi(finalURL: String,  completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void) {
       
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(GetCartModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func deleteCartApi(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "PUT", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(UpdateCartModel.self, from: result!)
                    
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func updateCartApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(UpdateCartModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func addToCartApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(((UserDefaults.standard.string(forKey: "AuthToken") ?? "") as String))",
            
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(AddToCartModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getProductDetails(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(FoodItems.self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getShopDetails(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ShopDetailsModel.self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getCategoryList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestArrayResponseCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode([CategoryListModel].self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    
    func getShopNearBy(finalURL: String, httpHeaders: [String : String], completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: httpHeaders, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ShopListModel.self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    


    
}
