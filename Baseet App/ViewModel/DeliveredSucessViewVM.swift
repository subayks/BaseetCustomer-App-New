//
//  DeliveredSucessViewVM.swift
//  Baseet App
//
//  Created by Subendran on 25/09/22.
//

import Foundation
class DeliveredSucessViewVM {
    var orderTrackModel: OrderTrackModel?
    
    init(orderTrackModel: OrderTrackModel) {
        self.orderTrackModel = orderTrackModel
    }
    
    func getFoodItemsList() ->String {
        var foodItem = String()
        if let foodItems = self.orderTrackModel?.details {
            for item in foodItems {
                foodItem = "\(foodItem), \(item.foodDetails?.name ?? "")"
            }
        }
        return foodItem
    }
    
    func getFeedbackViewModel() ->FeedbackViewModel {
        return FeedbackViewModel(orderId: self.orderTrackModel?.id ?? 0)
    }
}
