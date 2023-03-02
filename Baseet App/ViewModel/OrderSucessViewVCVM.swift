//
//  OrderSucessViewVCVM.swift
//  Baseet App
//
//  Created by Subendran on 19/08/22.
//

import Foundation
class OrderSucessViewVCVM {
    
    var orderId: String?
    var apiServices: HomeApiServicesProtocol?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var orderTrackModel: OrderTrackModel?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    init(orderId: String, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.orderId = orderId
        self.apiServices = apiServices
    }
    
    func getOrderTrack() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.orderTrackDetails(finalURL: "\(Constants.Common.finalURL)/customer/order/track?order_id=\(self.orderId ?? "")",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.orderTrackModel = result as? OrderTrackModel
                    self.navigationClosure?()
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getOrderOntheWayVM() ->OrderOntheWayVM {
        return OrderOntheWayVM(orderTrackModel: self.orderTrackModel ?? OrderTrackModel(), isFromSuccessScreen: true)
    }
    
    
}
