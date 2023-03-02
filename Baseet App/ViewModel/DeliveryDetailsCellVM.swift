//
//  DeliveryDetailsCellVM.swift
//  Baseet App
//
//  Created by Subendran on 25/09/22.
//

import Foundation

class DeliveryDetailsCellVM {
    var deliveryManModel: DeliveryMan?
    var deliveryTime: String?
    
    init(deliveryManModel: DeliveryMan, deliveryTime: String) {
        self.deliveryManModel = deliveryManModel
        self.deliveryTime = deliveryTime
    }
}
