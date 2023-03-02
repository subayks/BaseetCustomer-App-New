//
//  RestFoodPickTableViewCellVM.swift
//  Baseet App
//
//  Created by Subendran on 11/08/22.
//

var productID:String!

import Foundation

class RestFoodPickTableViewCellVM {
    var foodItems: CartDataModel?
    
    init(foodItems: CartDataModel) {
        self.foodItems = foodItems
    }
    
}
