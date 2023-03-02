//
//  FeedbackViewModel.swift
//  Baseet App
//
//  Created by Subendran on 03/10/22.
//

import Foundation

class FeedbackViewModel {
    var apiServices: HomeApiServicesProtocol?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var customerInfoModel: CustomerInfoModel?
    var orderId: Int?
    var finalRating: Int = 0
    
    init(orderId: Int, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
        self.orderId = orderId
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func giveFeedBack(comment: String) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.feedbackApi(finalURL: "\(Constants.Common.finalURL)/products/reviews/submit?food_id=\(self.orderId ?? 0)&order_id=\(self.orderId ?? 0)&comment=\(comment)&rating=\(self.finalRating)",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
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
    
}
