//
//  NotificationsViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 26/09/22.
//

import Foundation
class NotificationsViewControllerVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var navigateToDetailsClosure:(()->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var notificationModel: NotificationModel?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getNotifications() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.notificationApi(finalURL: "\(Constants.Common.finalURL)/customer/notifications",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.notificationModel = result as? NotificationModel
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
    
    func getNotificationsTableViewCellVM(index: Int) ->NotificationsTableViewCellVM {
        return NotificationsTableViewCellVM(notificationModel: self.notificationModel?.notifications?[index] ?? NotificationDataModel())
    }
}
