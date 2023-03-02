//
//  ResDishCollectionViewCellTwoVM.swift
//  Baseet App
//
//  Created by Subendran on 09/08/22.
//

import Foundation

class ResDishCollectionViewCellTwoVM {
    var foodItems: FoodItems?
    
    init(foodItems: FoodItems) {
        self.foodItems = foodItems
    }
    
    func getItemQuantity() ->Int {
        return self.foodItems?.itemQuantity ?? 0
    }
}
