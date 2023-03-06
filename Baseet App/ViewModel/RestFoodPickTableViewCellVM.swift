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
    
    func addonNames() ->String {
        var nameArray = [String]()
        if let addon = foodItems?.addon {
            for item in addon {
                nameArray.append(item.addonname ?? "")
            }
            if nameArray.count > 1 {
                return "Addons: " + nameArray[0] + "..."
            } else {
                return "Addons: " + nameArray[0]
            }
        }
        return ""
    }
    
}
