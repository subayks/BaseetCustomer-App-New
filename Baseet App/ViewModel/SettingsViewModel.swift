//
//  SettingsViewModel.swift
//  Baseet App
//
//  Created by Subendran on 23/09/22.
//

import Foundation

class SettingsViewModel {
    var apiServices: HomeApiServicesProtocol?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var customerInfoModel: CustomerInfoModel?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getCustomerInfo() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            print("\(Constants.Common.finalURL)/customer/info")
            self.apiServices?.getCustomerInfo(finalURL: "\(Constants.Common.finalURL)/customer/info",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.customerInfoModel = result as? CustomerInfoModel
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
    
    func getEditProfileViewModel() ->EditProfileViewModel {
        return EditProfileViewModel(customerInfoModel: self.customerInfoModel ?? CustomerInfoModel())
    }
    
}
