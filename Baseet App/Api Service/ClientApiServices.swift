//
//  ClientApiServices.swift
//  Saloon Hub
//
//  Created by Subendran on 13/06/22.
//

import Foundation
protocol ClientApiServicesProtocol {
    func uploadImage(finalURL: String, withParameters: ImageRequestParam, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func updateSaloonInfo(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getServicesList(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func onBoardEmployee(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getSubscriptionInfoList(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getSaloonId(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getEmployeesList(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getDashboardInfo(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func makeBookingCall(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getSlotsInfo(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func makeBookingReject(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getBookingHistoryCall(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func deleteSalonEmployee(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func addEmployeeEditFlow(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
}

class ClientApiServices: ClientApiServicesProtocol {
    func addEmployeeEditFlow(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(OnboardedEmployeeModel.self, from: result!)
                    
                    
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    func deleteSalonEmployee(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(OnboardedEmployeeModel.self, from: result!)
                    
                    //
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    func getBookingHistoryCall(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(BookingHistoryModel.self, from: result!)
                    
                    
//                    if values.status == "fail" {
//                        completion(false,errorCode,values as AnyObject?,error)
//                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func makeBookingReject(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(ConfirmBookingModel.self, from: result!)
                    
                    
//                    if values.status == "fail" {
//                        completion(false,errorCode,values as AnyObject?,error)
//                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getSlotsInfo(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(SlotsModel.self, from: result!)
                    
                    //
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func makeBookingCall(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void){
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(ConfirmBookingModel.self, from: result!)
                    
                    
//                    if values.status == "fail" {
//                        completion(false,errorCode,values as AnyObject?,error)
//                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    func getDashboardInfo(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(OnBoardSaloonModel.self, from: result!)
                    
                    //
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getEmployeesList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(OnBoardedEmployeesModel.self, from: result!)
                    
                    //
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getSaloonId(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(OnBoardSaloonModel.self, from: result!)
                    
                    
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getSubscriptionInfoList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(SubscriptionModel.self, from: result!)
                    
                    //
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func onBoardEmployee(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(OnboardedEmployeeModel.self, from: result!)
                    
                    
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getServicesList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(SaloonServicesModel.self, from: result!)
                    
                    //
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func updateSaloonInfo(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(OnBoardSaloonModel.self, from: result!)
                    
                    
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    func uploadImage(finalURL: String, withParameters: ImageRequestParam, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.uploadImage(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
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
                    let values = try! decoder.decode(ImageModel.self, from: result!)
                    
                    
                    //                    if values.status == "fail" {
                    //                        completion(false,errorCode,values as AnyObject?,error)
                    //                    }
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
