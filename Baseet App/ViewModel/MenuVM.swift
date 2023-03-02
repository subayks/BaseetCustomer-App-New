//
//  MenuVM.swift
//  Baseet App
//
//  Created by Subendran on 26/09/22.
//

import Foundation

class MenuVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
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
            self.apiServices?.getCustomerInfo(finalURL: "\(Constants.Common.finalURL)/customer/info",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.customerInfoModel = result as? CustomerInfoModel
                    UserDefaults.standard.set(self.customerInfoModel?.fName, forKey: "Name")
                    UserDefaults.standard.set(self.customerInfoModel?.appImage, forKey: "ProfileImage")
                    let app_image = self.customerInfoModel?.appImage
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
