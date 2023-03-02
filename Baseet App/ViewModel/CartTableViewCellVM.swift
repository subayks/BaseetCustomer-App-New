//
//  CartTableViewCellVM.swift
//  Baseet App
//
//  Created by Subendran on 17/08/22.
//

import Foundation

class CartTableViewCellVM {
    var foodItems: CartDataModel?
    
    init(foodItems: CartDataModel) {
        self.foodItems = foodItems
    }
}
