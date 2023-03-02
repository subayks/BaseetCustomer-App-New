//
//  OrderOntheWayVM.swift
//  Baseet App
//
//  Created by Subendran on 24/09/22.
//

import Foundation

struct OrderInfo {
    var title: String?
    var image: String?
    var isSelected: Bool?
}

class OrderOntheWayVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var navigateToDetailsClosure:(()->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var successClosure:(()->())?

    var orderTrackModel: OrderTrackModel?
    let orderState = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order Processed", comment: ""),
                      LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order On the Way", comment: ""),
                      LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order Delivered", comment: ""),]
    
    
    let imageNames = ["SandClock","OnTheWay","ss"]
    var orderInfoArray = [OrderInfo]()
    var originalOrderInfoArray = [OrderInfo]()
    var isFromSuccessScreen: Bool?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    init(orderTrackModel: OrderTrackModel, isFromSuccessScreen: Bool = false, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.orderTrackModel = orderTrackModel
        self.isFromSuccessScreen = isFromSuccessScreen
        self.apiServices = apiServices
    }
    
    func setupOrderInfo() {
        for i in 0..<orderState.count {
            var orderInfo = OrderInfo()
            orderInfo.title = orderState[i]
            orderInfo.image = imageNames[i]
            orderInfo.isSelected = false
            self.orderInfoArray.append(orderInfo)
            self.originalOrderInfoArray.append(orderInfo)
        }
        setupOderStatus()
    }
    
    func getDeliveryManViewModel() ->DeliveryDetailsCellVM {
        return DeliveryDetailsCellVM(deliveryManModel: self.orderTrackModel?.deliveryMan ?? DeliveryMan(), deliveryTime: self.orderTrackModel?.delivered ?? "")
    }
    
    func getOrderItemsListCellVM(index: Int) ->OrderItemsListCellVM {
        return OrderItemsListCellVM(foodDetails: self.orderTrackModel?.details?[index] ?? Details())
    }
    
    func setupOderStatus() {
        if self.orderTrackModel?.orderStatus == OrderStatus.processing.rawValue {
            self.orderInfoArray = self.originalOrderInfoArray
            var orderInfo = self.orderInfoArray[0]
            self.orderInfoArray.remove(at: 0)
            orderInfo.isSelected = true
            self.orderInfoArray.insert(orderInfo, at: 0)
        } else  if self.orderTrackModel?.orderStatus == OrderStatus.picked_up.rawValue {
            self.orderInfoArray = self.originalOrderInfoArray
            var orderInfo = self.orderInfoArray[1]
            self.orderInfoArray.remove(at: 1)
            orderInfo.isSelected = true
            self.orderInfoArray.insert(orderInfo, at: 1)
        } else if self.orderTrackModel?.orderStatus == OrderStatus.delivered.rawValue {
            self.orderInfoArray = self.originalOrderInfoArray
            var orderInfo = self.orderInfoArray[2]
            self.orderInfoArray.remove(at: 2)
            orderInfo.isSelected = true
            self.orderInfoArray.insert(orderInfo, at: 2)
            self.successClosure?()
        }
        self.reloadClosure?()
    }
    
    func getOrderTrack() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let id = self.orderTrackModel?.id
            self.apiServices?.orderTrackDetails(finalURL: "\(Constants.Common.finalURL)/customer/order/track?order_id=\(id ?? 0)",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.orderTrackModel = result as? OrderTrackModel
                    self.setupOderStatus()
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabel")
        }
    }
    
    func getMapkitViewVM() ->MapkitViewVM {
        return MapkitViewVM(orderTrackModel: self.orderTrackModel ?? OrderTrackModel())
    }
    
    func getDeliveredSucessViewVM() ->DeliveredSucessViewVM {
        return DeliveredSucessViewVM(orderTrackModel: self.orderTrackModel ?? OrderTrackModel())
    }
}
