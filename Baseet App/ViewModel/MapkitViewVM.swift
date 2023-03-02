//
//  MapkitViewVM.swift
//  Baseet App
//
//  Created by Subendran on 25/09/22.
//

import Foundation
class MapkitViewVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var navigateToDetailsClosure:(()->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var orderTrackModel: OrderTrackModel?
    var id: Int?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    init(orderTrackModel: OrderTrackModel, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
        self.orderTrackModel = orderTrackModel
    }
    
    func getOrderTrack() {
        if Reachability.isConnectedToNetwork() {
         //   self.showLoadingIndicatorClosure?()
            let id = self.orderTrackModel?.id
            self.apiServices?.orderTrackDetails(finalURL: "\(Constants.Common.finalURL)/customer/order/track?order_id=\(id ?? 0)",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
             //   self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.orderTrackModel = result as? OrderTrackModel
                    self.reloadClosure?()
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
