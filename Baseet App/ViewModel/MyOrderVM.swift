//
//  MyOrderVM.swift
//  Baseet App
//
//  Created by Subendran on 24/09/22.
//

import Foundation

class MyOrderVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var navigateToDetailsClosure:(()->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var ordersListModel: OrdersListModel?
    var orderTrackModel: OrderTrackModel?
    var limit = 10
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func makeOrderListCall(type: Int, limitAdded: Int) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            var endPoint = ""
            self.limit = self.limit + limitAdded
            if type == 0 {
                //endPoint = "/customer/order/list?limit=\(self.limit)&offset=1"
                endPoint = "/customer/order/running-orders?limit=\(self.limit)&offset=1"
                print(endPoint)
            } else {
                endPoint = "/customer/order/past-orders?limit=\(self.limit)&offset=1"
                print(endPoint)
            }
            print("\(Constants.Common.finalURL)\(endPoint)")
            self.apiServices?.orderListApi(finalURL: "\(Constants.Common.finalURL)\(endPoint)",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    
                    self.ordersListModel = result as? OrdersListModel
                    /*if self.ordersListModel?.orders?.count == 0{
                        self.alertClosure?(errorMessage ?? "Some Technical Problem")
                    }else{
                     self.reloadClosure?()
                    }*/
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
    
    func getMyCurrentOrderTableViewCellVM(index: Int, type: Int) ->MyCurrentOrderTableViewCellVM {
        UserDefaults.standard.set(self.ordersListModel?.orders?[index].id, forKey: "orderID")
        return MyCurrentOrderTableViewCellVM(myOrder: self.ordersListModel?.orders?[index] ?? Orders(), type: type)
        
    }
    
    func getMyPostOrderTableViewCellVM(index: Int, type: Int) ->MyPastOrderTableViewCellVM {
        return MyPastOrderTableViewCellVM(myOrder: self.ordersListModel?.orders?[index] ?? Orders(), type: type)
    }
    
    func getOrderID(index: Int){
        let id = self.ordersListModel?.orders?[index].id
        UserDefaults.standard.set(id, forKey: "OrderID")
    }
    
    func getOrderTrack(index: Int) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let id = self.ordersListModel?.orders?[index].id
            self.apiServices?.orderTrackDetails(finalURL: "\(Constants.Common.finalURL)/customer/order/track?order_id=\(id ?? 0)",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.orderTrackModel = result as? OrderTrackModel
                    self.navigateToDetailsClosure?()
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
        return OrderOntheWayVM(orderTrackModel: self.orderTrackModel ?? OrderTrackModel())
    }
    
}
