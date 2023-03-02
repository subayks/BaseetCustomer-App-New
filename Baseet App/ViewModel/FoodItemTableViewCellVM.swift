//
//  FoodItemTableViewCellVM.swift
//  Baseet App
//
//  Created by Subendran on 22/09/22.
//

import Foundation
class FoodItemTableViewCellVM {
    var products: [FoodItems]?
    
    init(products: [FoodItems]) {
        self.products = products
    }
    
    func getResDishCollectionViewCellTwoVM(index: Int) ->ResDishCollectionViewCellTwoVM {
        return ResDishCollectionViewCellTwoVM(foodItems: (self.products?[index])!)
    }
}
