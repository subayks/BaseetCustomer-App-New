//
//  OffersViewVM.swift
//  Baseet App
//
//  Created by Subendran on 22/09/22.
//

import Foundation

class OffersViewVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var navigateToDetailsClosure:(()->())?
    var couponModel: CouponModel?
    var iconArray = [String]()
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func makeCouponListCall() {
        print("\(Constants.Common.finalURL)/coupon/list")
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getCouponList(finalURL: "\(Constants.Common.finalURL)/coupon/list",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.couponModel = result as? CouponModel
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
    
    func getCouponCellVM(index: Int) ->CouponCellVM {
        return CouponCellVM(couponItem: self.couponModel?.data?[index] ?? CouponItem())
    }
}
